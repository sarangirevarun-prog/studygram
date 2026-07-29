import 'package:flutter/material.dart';
import 'package:study_gram/theme/colors.dart';
import 'package:study_gram/services/ak_assistant_service.dart';
import 'package:study_gram/services/ak_voice_service.dart';
import 'package:url_launcher/url_launcher.dart';

class AKBotDrawer extends StatefulWidget {
  final Map<String, dynamic> appContext;
  final Function(AKAction action) onExecuteAction;

  const AKBotDrawer({
    super.key,
    required this.appContext,
    required this.onExecuteAction,
  });

  static void show(
    BuildContext context, {
    required Map<String, dynamic> appContext,
    required Function(AKAction action) onExecuteAction,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AKBotDrawer(
        appContext: appContext,
        onExecuteAction: onExecuteAction,
      ),
    );
  }

  @override
  State<AKBotDrawer> createState() => _AKBotDrawerState();
}

class _AKBotDrawerState extends State<AKBotDrawer> with TickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final AKAssistantService _assistantService = AKAssistantService();
  final AKVoiceService _voiceService = AKVoiceService();

  final List<AKMessage> _messages = [];
  bool _isLoading = false;
  bool _isListening = false;
  int _countdownSeconds = 2;
  String _voiceInputText = "";
  String? _geminiApiKey;

  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _loadInitialState();
  }

  Future<void> _loadInitialState() async {
    await _assistantService.init();
    _geminiApiKey = await _assistantService.getApiKey();

    final savedHistory = await _assistantService.loadChatHistory();
    if (mounted) {
      setState(() {
        if (savedHistory.isNotEmpty) {
          _messages.clear();
          _messages.addAll(savedHistory);
        } else if (_messages.isEmpty) {
          _messages.add(
            AKMessage(
              text: "How can I help you?",
              isUser: false,
            ),
          );
        }
      });
    }

    // Automatically start voice listening when AK opens!
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted && !_isListening) {
        _toggleVoiceListening();
      }
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _textController.dispose();
    _scrollController.dispose();
    _voiceService.stopListening();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _handleSendMessage([String? overrideText]) async {
    final text = (overrideText ?? _textController.text).trim();
    if (text.isEmpty || _isLoading) return;

    if (_isListening) {
      await _voiceService.stopListening();
      setState(() => _isListening = false);
    }

    _textController.clear();

    setState(() {
      _messages.add(AKMessage(text: text, isUser: true));
      _isLoading = true;
    });
    _scrollToBottom();

    final response = await _assistantService.processQuery(text, widget.appContext, _messages);

    if (mounted) {
      setState(() {
        _messages.add(AKMessage(
          text: response.text,
          isUser: false,
          action: response.action,
        ));
        _isLoading = false;
      });
      _scrollToBottom();

      // Save last 3 chat turns persistently
      await _assistantService.saveChatHistory(_messages);

      // Execute Action
      if (response.action != null) {
        if (response.action!.type == AKActionType.toggleTheme) {
          // Instant dark/light mode toggle in-place without closing AK drawer!
          widget.onExecuteAction(response.action!);
          if (mounted) {
            setState(() {});
          }
        } else {
          // For screen navigation commands, minimize AK drawer fast
          Future.delayed(const Duration(milliseconds: 150), () {
            if (mounted) {
              Navigator.pop(context);
              widget.onExecuteAction(response.action!);
            }
          });
        }
      }
    }
  }

  Future<void> _toggleVoiceListening() async {
    if (_isListening) {
      await _voiceService.stopListening();
      setState(() => _isListening = false);
      return;
    }

    setState(() {
      _isListening = true;
      _voiceInputText = "";
      _countdownSeconds = 5;
    });

    await _voiceService.startListening(
      onResult: (words, isFinal) {
        if (mounted) {
          setState(() {
            _voiceInputText = words;
            _textController.text = words;
          });
        }
      },
      onAutoSend: (finalWords) {
        if (mounted && finalWords.isNotEmpty) {
          setState(() => _isListening = false);
          _handleSendMessage(finalWords);
        }
      },
      onTimerTick: (remainingSeconds) {
        if (mounted) {
          setState(() => _countdownSeconds = remainingSeconds);
        }
      },
      onWakeWordDetected: (wakeText) {
        debugPrint("Wake word detected: $wakeText");
      },
    );
  }

  void _showApiKeyDialog() {
    final keyController = TextEditingController(text: _geminiApiKey ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.bgCard,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              const Icon(Icons.auto_awesome, color: Color(0xFF8E54E9)),
              const SizedBox(width: 10),
              Text("Gemini API Settings", style: TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Is Gemini API free? YES! Google AI Studio offers a 100% FREE Tier (1,500 requests/day free).",
                style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: keyController,
                style: TextStyle(color: AppColors.textPrimary),
                decoration: InputDecoration(
                  labelText: "Google Gemini API Key",
                  hintText: "AIzaSy...",
                  prefixIcon: Icon(Icons.key, color: AppColors.accent),
                ),
              ),
              const SizedBox(height: 10),
              InkWell(
                onTap: () async {
                  final uri = Uri.parse("https://aistudio.google.com/app/apikey");
                  try {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  } catch (_) {}
                },
                child: Text(
                  "👉 Click here to get a FREE Gemini API Key",
                  style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold, fontSize: 13, decoration: TextDecoration.underline),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel", style: TextStyle(color: AppColors.textMuted)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () async {
                await _assistantService.setApiKey(keyController.text);
                _geminiApiKey = await _assistantService.getApiKey();
                if (context.mounted) {
                  Navigator.pop(context);
                  setState(() {});
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Gemini API Key updated successfully!")),
                  );
                }
              },
              child: const Text("Save Key", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      height: screenHeight * 0.85,
      margin: EdgeInsets.only(bottom: bottomInset),
      decoration: BoxDecoration(
        color: AppColors.bgMain,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        children: [
          // Drag Handle
          const SizedBox(height: 10),
          Center(
            child: Container(
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                color: AppColors.borderCard,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),

          // Header - Overflow-free & clean layout
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            child: Row(
              children: [
                // AK Animated Avatar Icon
                Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.primary, AppColors.primaryLight],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryLight.withValues(alpha: 0.4),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: const Text(
                    "AK",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              "AK Assistant",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.green.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              "ONLINE",
                              style: TextStyle(color: Colors.green, fontSize: 8, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        "Powered by Gemini AI ✨",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 11, color: AppColors.textMuted),
                      ),
                    ],
                  ),
                ),

                // Dark / White Theme Toggle Button
                IconButton(
                  tooltip: "Dark / White Mode",
                  padding: const EdgeInsets.all(6),
                  constraints: const BoxConstraints(minWidth: 34, minHeight: 34),
                  onPressed: () {
                    _handleSendMessage("Toggle Dark Mode");
                  },
                  icon: Icon(
                    AppColors.isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                    color: AppColors.isDark ? AppColors.accent : AppColors.textPrimary,
                    size: 20,
                  ),
                ),

                // Gemini API key settings button
                IconButton(
                  tooltip: "Gemini API Key",
                  padding: const EdgeInsets.all(6),
                  constraints: const BoxConstraints(minWidth: 34, minHeight: 34),
                  onPressed: _showApiKeyDialog,
                  icon: Icon(
                    _geminiApiKey != null ? Icons.key_rounded : Icons.key_off_rounded,
                    color: _geminiApiKey != null ? AppColors.accent : AppColors.textMuted,
                    size: 20,
                  ),
                ),

                // Clear Chat
                IconButton(
                  tooltip: "Clear Chat",
                  padding: const EdgeInsets.all(6),
                  constraints: const BoxConstraints(minWidth: 34, minHeight: 34),
                  onPressed: () async {
                    await _assistantService.clearChatHistory();
                    setState(() {
                      _messages.clear();
                    });
                    _loadInitialState();
                  },
                  icon: Icon(Icons.delete_outline_rounded, color: AppColors.textMuted, size: 20),
                ),

                // Close button
                IconButton(
                  padding: const EdgeInsets.all(6),
                  constraints: const BoxConstraints(minWidth: 34, minHeight: 34),
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.close_rounded, color: AppColors.textPrimary, size: 20),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Message List
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: _messages.length + (_isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length && _isLoading) {
                  return _buildLoadingBubble();
                }
                return _buildMessageBubble(_messages[index]);
              },
            ),
          ),

          // Voice Listening Bar
          if (_isListening) _buildVoiceListeningBanner(),

          // Quick Action Suggestion Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                _buildChip("📚 Open Notes & Videos", "Open notes"),
                _buildChip("🎥 Video Lectures", "Open video lectures"),
                _buildChip("🌙 Dark / ☀️ White Theme", "Toggle Dark Mode"),
                _buildChip("👤 Go to Profile", "Go to Profile"),
                _buildChip("⚙️ Open Settings", "Open Settings"),
                _buildChip("📘 What is K-Scheme?", "What is K-Scheme?"),
                _buildChip("💻 Java Notes", "Search Java notes"),
                _buildChip("🔄 Latest Updates", "Open Updates"),
              ],
            ),
          ),

          // Bottom Input Bar
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Voice Mic Button
                ScaleTransition(
                  scale: _isListening ? Tween(begin: 1.0, end: 1.15).animate(_pulseController) : const AlwaysStoppedAnimation(1.0),
                  child: GestureDetector(
                    onTap: _toggleVoiceListening,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: _isListening
                              ? [Colors.redAccent, Colors.orangeAccent]
                              : [AppColors.primary, AppColors.primaryLight],
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: (_isListening ? Colors.redAccent : AppColors.primaryLight).withValues(alpha: 0.4),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Icon(
                        _isListening ? Icons.mic_rounded : Icons.mic_none_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),

                // Text Input
                Expanded(
                  child: TextField(
                    controller: _textController,
                    style: TextStyle(color: AppColors.textPrimary, fontSize: 15),
                    textInputAction: TextInputAction.send,
                    onSubmitted: (val) => _handleSendMessage(),
                    decoration: InputDecoration(
                      hintText: _isListening ? "Listening..." : "How can I help you?",
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(24)),
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // Send Button
                GestureDetector(
                  onTap: () => _handleSendMessage(),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChip(String label, String command) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: ActionChip(
        label: Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
        backgroundColor: AppColors.bgCard,
        side: BorderSide(color: AppColors.borderCard),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        onPressed: () => _handleSendMessage(command),
      ),
    );
  }

  Widget _buildVoiceListeningBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.redAccent.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.redAccent.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          const Icon(Icons.graphic_eq_rounded, color: Colors.redAccent),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _voiceInputText.isEmpty ? "Listening for voice..." : "\"$_voiceInputText\"",
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.redAccent),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  "Auto-sending in $_countdownSeconds s...",
                  style: TextStyle(fontSize: 11, color: AppColors.textMuted),
                ),
              ],
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              if (_voiceInputText.isNotEmpty) {
                _handleSendMessage(_voiceInputText);
              }
            },
            child: const Text("Send Now", style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingBubble() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12, right: 60),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primaryLight),
            ),
            const SizedBox(width: 10),
            Text("AK is thinking...", style: TextStyle(color: AppColors.textMuted, fontSize: 13)),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(AKMessage msg) {
    final isUser = msg.isUser;
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(
          bottom: 12,
          left: isUser ? 50 : 0,
          right: isUser ? 0 : 40,
        ),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: isUser
              ? LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryLight],
                )
              : null,
          color: isUser ? null : AppColors.bgCard,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: Radius.circular(isUser ? 18 : 4),
            bottomRight: Radius.circular(isUser ? 4 : 18),
          ),
          border: isUser ? null : Border.all(color: AppColors.borderCard),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isUser)
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  children: [
                    Icon(Icons.auto_awesome, size: 14, color: AppColors.primaryLight),
                    const SizedBox(width: 4),
                    Text(
                      "AK Assistant",
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primaryLight),
                    ),
                  ],
                ),
              ),

            Text(
              msg.text,
              style: TextStyle(
                color: isUser ? Colors.white : AppColors.textPrimary,
                fontSize: 14.5,
                height: 1.4,
              ),
            ),

            if (msg.action != null) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.primaryLight.withValues(alpha: 0.4)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.bolt, size: 14, color: AppColors.accent),
                    const SizedBox(width: 4),
                    Text(
                      "Action Executed: ${msg.action!.description}",
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.accent),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
