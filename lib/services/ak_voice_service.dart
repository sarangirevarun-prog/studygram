import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:speech_to_text/speech_to_text.dart';

class AKVoiceService {
  static final AKVoiceService _instance = AKVoiceService._internal();
  factory AKVoiceService() => _instance;
  AKVoiceService._internal();

  final SpeechToText _speech = SpeechToText();
  bool _isInitialized = false;
  bool _isListening = false;
  String _lastRecognizedWords = "";

  Timer? _silenceTimer;
  Timer? _countdownTimer;
  int _secondsRemaining = 5;

  bool get isListening => _isListening;
  bool get isInitialized => _isInitialized;
  String get lastWords => _lastRecognizedWords;
  int get secondsRemaining => _secondsRemaining;

  Future<bool> initSpeech() async {
    if (_isInitialized) return true;
    try {
      _isInitialized = await _speech.initialize(
        onError: (error) {
          debugPrint("Speech recognition error: ${error.errorMsg}");
          _isListening = false;
        },
        onStatus: (status) {
          debugPrint("Speech recognition status: $status");
          if (status == 'done' || status == 'notListening') {
            _isListening = false;
          }
        },
      );
    } catch (e) {
      debugPrint("Failed to initialize SpeechToText: $e");
      _isInitialized = false;
    }
    return _isInitialized;
  }

  /// Start listening to voice input with fast 2-second silence auto-send timer
  Future<void> startListening({
    required Function(String words, bool isFinal) onResult,
    required Function(String words) onAutoSend,
    Function(String wakeWord)? onWakeWordDetected,
    Function(int remainingSeconds)? onTimerTick,
  }) async {
    if (!_isInitialized) {
      bool available = await initSpeech();
      if (!available) return;
    }

    _lastRecognizedWords = "";
    _isListening = true;
    _cancelTimers();

    await _speech.listen(
      onResult: (result) {
        final words = result.recognizedWords;
        _lastRecognizedWords = words;
        onResult(words, result.finalResult);

        // Check for Wake Words ("Hey AK", "OK AK", "Hello AK")
        final lower = words.toLowerCase();
        if (wakeWordDetected(lower) && onWakeWordDetected != null) {
          onWakeWordDetected(words);
        }

        // Fast auto-send on final speech result
        if (result.finalResult && words.trim().isNotEmpty) {
          _cancelTimers();
          stopListening();
          onAutoSend(words.trim());
          return;
        }

        // Reset 2-second silence timer whenever user speaks new words
        _resetSilenceTimer(words, onAutoSend, onTimerTick);
      },
      listenOptions: SpeechListenOptions(
        listenMode: ListenMode.search,
        cancelOnError: false,
        partialResults: true,
      ),
    );
  }

  bool wakeWordDetected(String textLower) {
    return textLower.contains("hey ak") ||
        textLower.contains("ok ak") ||
        textLower.contains("hello ak") ||
        textLower.contains("hi ak") ||
        textLower.contains("wake ak") ||
        textLower.contains("awake ak") ||
        textLower.contains("a k") ||
        textLower.contains("hey a k") ||
        textLower.contains("ok a k") ||
        textLower.contains("awake a k") ||
        textLower.contains("wake a k") ||
        textLower.contains("open ak");
  }

  /// Background listener to trigger AK Assistant whenever user says "Hey AK", "OK AK", "Awake AK", etc.
  Future<void> startWakeWordListener({required Function() onWakeTriggered}) async {
    if (!_isInitialized) {
      bool available = await initSpeech();
      if (!available) return;
    }
    if (_isListening) return;

    _isListening = true;
    try {
      await _speech.listen(
        onResult: (result) {
          final words = result.recognizedWords.toLowerCase();
          if (wakeWordDetected(words)) {
            stopListening();
            onWakeTriggered();
          }
        },
        listenOptions: SpeechListenOptions(
          listenMode: ListenMode.deviceDefault,
          cancelOnError: false,
          partialResults: true,
        ),
      );
    } catch (e) {
      debugPrint("Background wake word listener error: $e");
      _isListening = false;
    }
  }

  void _resetSilenceTimer(
    String currentWords,
    Function(String words) onAutoSend,
    Function(int seconds)? onTimerTick,
  ) {
    _cancelTimers();

    if (currentWords.trim().isEmpty) return;

    _secondsRemaining = 2;
    if (onTimerTick != null) onTimerTick(_secondsRemaining);

    // Countdown tick timer every 1 second
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _secondsRemaining--;
      if (onTimerTick != null) onTimerTick(_secondsRemaining);
      if (_secondsRemaining <= 0) {
        timer.cancel();
      }
    });

    // 2-second silence trigger timer for ultra fast response!
    _silenceTimer = Timer(const Duration(seconds: 2), () async {
      _cancelTimers();
      await stopListening();
      if (currentWords.trim().isNotEmpty) {
        onAutoSend(currentWords.trim());
      }
    });
  }

  Future<void> stopListening() async {
    _cancelTimers();
    _isListening = false;
    if (_speech.isListening) {
      await _speech.stop();
    }
  }

  void _cancelTimers() {
    _silenceTimer?.cancel();
    _silenceTimer = null;
    _countdownTimer?.cancel();
    _countdownTimer = null;
    _secondsRemaining = 5;
  }
}
