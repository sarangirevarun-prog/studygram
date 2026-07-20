import 'dart:async';
import 'package:flutter/material.dart';
import 'package:study_gram/theme/colors.dart';


class MaterialsHubView extends StatefulWidget {
  final String subject;
  final bool isBookmarked;
  final VoidCallback onBookmarkToggle;
  final VoidCallback onBack;
  final VoidCallback onStartQuiz;

  const MaterialsHubView({
    super.key,
    required this.subject,
    required this.isBookmarked,
    required this.onBookmarkToggle,
    required this.onBack,
    required this.onStartQuiz,
  });

  @override
  State<MaterialsHubView> createState() => _MaterialsHubViewState();
}

class _MaterialsHubViewState extends State<MaterialsHubView> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final Map<String, double> _downloadProgress = {};
  final Map<String, bool> _isDownloaded = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _simulateDownload(String noteTitle) {
    if (_isDownloaded[noteTitle] == true || _downloadProgress[noteTitle] != null) return;

    setState(() {
      _downloadProgress[noteTitle] = 0.0;
    });

    Timer.periodic(const Duration(milliseconds: 150), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        double current = _downloadProgress[noteTitle] ?? 0.0;
        if (current >= 1.0) {
          timer.cancel();
          _downloadProgress.remove(noteTitle);
          _isDownloaded[noteTitle] = true;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Successfully downloaded $noteTitle!"),
              backgroundColor: AppColors.primary,
              duration: const Duration(seconds: 1),
            ),
          );
        } else {
          _downloadProgress[noteTitle] = current + 0.1;
        }
      });
    });
  }

  void _playVideo(String title) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: AppColors.bgMain,
          insetPadding: const EdgeInsets.symmetric(horizontal: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 220,
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  image: const DecorationImage(
                    image: NetworkImage("https://images.unsplash.com/photo-1517694712202-14dd9538aa97?w=500&auto=format&fit=crop"),
                    fit: BoxFit.cover,
                    opacity: 0.4,
                  ),
                ),
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.play_circle_outline_rounded, size: 64, color: AppColors.primaryLight),
                      SizedBox(height: 10),
                      Text(
                        "Streaming Lecture HD...",
                        style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Topic details cover variables, loops, memory architecture, stack and heap spaces.",
                      style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Close Player", style: TextStyle(color: AppColors.redDanger)),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // App bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: widget.onBack,
                      icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      widget.subject,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: widget.onBookmarkToggle,
                  icon: Icon(
                    widget.isBookmarked ? Icons.bookmark_added_rounded : Icons.bookmark_add_outlined,
                    color: widget.isBookmarked ? AppColors.primaryLight : Colors.white,
                  ),
                )
              ],
            ),
          ),
          // Custom TabBar
          TabBar(
            controller: _tabController,
            labelColor: AppColors.primaryLight,
            unselectedLabelColor: AppColors.textSecondary,
            indicatorColor: AppColors.primaryLight,
            tabs: const [
              Tab(text: "Notes"),
              Tab(text: "Videos"),
              Tab(text: "Quiz"),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildNotesTab(),
                _buildVideosTab(),
                _buildQuizTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotesTab() {
    final list = [
      "Unit 1: Fundamentals of JAVA & OOPs",
      "Unit 2: Inheritance & Interfaces",
      "Unit 3: Exception Handling & Multithreading",
      "Unit 4: I/O Streams and Applets",
      "Unit 5: Event Handling & AWT Screens",
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final title = list[index];
        final progress = _downloadProgress[title];
        final downloaded = _isDownloaded[title] == true;

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.bgCard,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.borderCard),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primaryPale,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.picture_as_pdf_outlined, color: AppColors.primaryLight, size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 4),
                    if (progress != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: progress,
                          backgroundColor: AppColors.bgMain,
                          valueColor: const AlwaysStoppedAnimation(AppColors.primaryLight),
                        ),
                      )
                    else
                      Text(
                        downloaded ? "PDF Downloaded" : "PDF File Size: 4.8 MB",
                        style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              if (progress != null)
                const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation(AppColors.primaryLight)),
                )
              else
                IconButton(
                  onPressed: () => _simulateDownload(title),
                  icon: Icon(
                    downloaded ? Icons.check_circle_rounded : Icons.download_for_offline_outlined,
                    color: downloaded ? AppColors.primaryLight : AppColors.textSecondary,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildVideosTab() {
    final list = [
      "Introduction to Java Virtual Machine (JVM)",
      "Understanding Classes, Objects & Methods",
      "Garbage Collection Mechanics",
      "Abstract Class vs Interfaces",
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final title = list[index];

        return Container(
          margin: const EdgeInsets.only(bottom: 14),
          decoration: BoxDecoration(
            color: AppColors.bgCard,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.borderCard),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Video Mock Thumbnail cover
              GestureDetector(
                onTap: () => _playVideo(title),
                child: Container(
                  height: 130,
                  decoration: BoxDecoration(
                    color: AppColors.bgMain,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    image: const DecorationImage(
                      image: NetworkImage("https://images.unsplash.com/photo-1542831371-29b0f74f9713?w=500&auto=format&fit=crop"),
                      fit: BoxFit.cover,
                      opacity: 0.3,
                    ),
                  ),
                  child: const Center(
                    child: CircleAvatar(
                      backgroundColor: AppColors.primaryLight,
                      child: Icon(Icons.play_arrow_rounded, color: AppColors.textPrimary),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 4),
                    const Row(
                      children: [
                        Icon(Icons.video_library_outlined, color: AppColors.textMuted, size: 12),
                        SizedBox(width: 4),
                        Text("18 mins video lecture", style: TextStyle(color: AppColors.textMuted, fontSize: 10)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildQuizTab() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.accent.withValues(alpha: 0.08),
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.accent.withValues(alpha: 0.2)),
              ),
              child: const Icon(Icons.bolt_rounded, color: AppColors.accent, size: 50),
            ),
            const SizedBox(height: 20),
            const Text(
              "Practice Practice Quiz",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 8),
            const Text(
              "Answer 5 conceptual JAVA multiple-choice questions under time pressure. Earn 100 points for each correct answer!",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.4),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: widget.onStartQuiz,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: AppColors.bgMain,
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text(
                  "Start test ⚡",
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}





