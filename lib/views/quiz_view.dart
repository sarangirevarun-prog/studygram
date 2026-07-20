import 'dart:async';
import 'package:flutter/material.dart';
import 'package:study_gram/theme/colors.dart';
import 'package:study_gram/models/quiz_question.dart';

class QuizView extends StatefulWidget {
  final Function(int) onQuizFinished;
  const QuizView({super.key, required this.onQuizFinished});

  @override
  State<QuizView> createState() => _QuizViewState();
}

class _QuizViewState extends State<QuizView> {
  int _currentQuestionIndex = 0;
  int _score = 0;
  int? _selectedOptionIndex;
  bool _isAnswerRevealed = false;

  // Countdown timer parameters
  double _timeFraction = 1.0;
  int _secondsRemaining = 15;
  Timer? _countdownTimer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _secondsRemaining = 15;
    _timeFraction = 1.0;

    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        if (_secondsRemaining > 0) {
          // Increment fractions
          int ms = _secondsRemaining * 1000 - 100;
          if (ms <= 0) {
            _secondsRemaining = 0;
            _timeFraction = 0.0;
            timer.cancel();
            _revealAnswer(null); // Time out
          } else {
            _secondsRemaining = (ms / 1000).ceil();
            _timeFraction = ms / 15000.0;
          }
        }
      });
    });
  }

  void _revealAnswer(int? selectedOption) {
    if (_isAnswerRevealed) return;

    _countdownTimer?.cancel();
    setState(() {
      _selectedOptionIndex = selectedOption;
      _isAnswerRevealed = true;

      final correctIndex = javaQuizQuestions[_currentQuestionIndex].answerIndex;
      if (selectedOption == correctIndex) {
        _score++;
      }
    });

    // Advance to next question or screen after a 1.2 second delay
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted) return;
      if (_currentQuestionIndex < javaQuizQuestions.length - 1) {
        setState(() {
          _currentQuestionIndex++;
          _selectedOptionIndex = null;
          _isAnswerRevealed = false;
        });
        _startTimer();
      } else {
        _countdownTimer?.cancel();
        // Finished - Show result page within same view or callback
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isFinished = _currentQuestionIndex >= javaQuizQuestions.length - 1 && _isAnswerRevealed;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
        child: isFinished ? _buildResultScreen() : _buildQuizQuestionScreen(),
      ),
    );
  }

  Widget _buildQuizQuestionScreen() {
    final questionObj = javaQuizQuestions[_currentQuestionIndex];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Question tracking
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "QUESTION ${_currentQuestionIndex + 1}/${javaQuizQuestions.length}",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.textSecondary),
            ),
            Row(
              children: [
                const Icon(Icons.timer_outlined, color: AppColors.accent, size: 14),
                const SizedBox(width: 4),
                Text(
                  "$_secondsRemaining s",
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.accent),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 10),
        // Linear Progress bar representing timer
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: _timeFraction,
            minHeight: 6,
            backgroundColor: AppColors.bgCard,
            valueColor: AlwaysStoppedAnimation(
              _secondsRemaining > 5 ? AppColors.primaryLight : AppColors.redDanger,
            ),
          ),
        ),
        const SizedBox(height: 30),
        // Question card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.bgCard,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.borderCard),
          ),
          child: Text(
            questionObj.question,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary, height: 1.4),
          ),
        ),
        const SizedBox(height: 24),
        // Options List
        Expanded(
          child: ListView.builder(
            itemCount: questionObj.options.length,
            itemBuilder: (context, index) {
              final optionText = questionObj.options[index];
              final isCorrectOption = index == questionObj.answerIndex;
              final isSelectedOption = index == _selectedOptionIndex;

              Color borderCol = AppColors.borderCard;
              Color bgCol = AppColors.bgCard;
              Widget? trailingIcon;

              if (_isAnswerRevealed) {
                if (isCorrectOption) {
                  borderCol = AppColors.primaryLight;
                  bgCol = AppColors.primaryPale;
                  trailingIcon = const Icon(Icons.check_circle_rounded, color: AppColors.primaryLight);
                } else if (isSelectedOption) {
                  borderCol = AppColors.redDanger;
                  bgCol = AppColors.redPale;
                  trailingIcon = const Icon(Icons.cancel_rounded, color: AppColors.redDanger);
                }
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: InkWell(
                  onTap: _isAnswerRevealed ? null : () => _revealAnswer(index),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    decoration: BoxDecoration(
                      color: bgCol,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: borderCol, width: _isAnswerRevealed && (isCorrectOption || isSelectedOption) ? 2 : 1),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            optionText,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: isSelectedOption ? FontWeight.bold : FontWeight.normal,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        ?trailingIcon,
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildResultScreen() {
    final earnedPoints = _score * 100;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.primaryLight.withValues(alpha: 0.08),
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primaryPale),
            ),
            child: const Icon(Icons.emoji_events_rounded, color: AppColors.primaryLight, size: 56),
          ),
          const SizedBox(height: 24),
          const Text(
            "Quiz Completed!",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 10),
          Text(
            "You got $_score out of ${javaQuizQuestions.length} answers correct.",
            style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 30),
          // Scores Box
          Container(
            width: 250,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.bgCard,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.borderCard),
            ),
            child: Column(
              children: [
                const Text("QUIZ POINTS", style: TextStyle(color: AppColors.textMuted, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                const SizedBox(height: 6),
                Text(
                  "+$earnedPoints pts",
                  style: const TextStyle(color: AppColors.accent, fontSize: 28, fontWeight: FontWeight.w800, fontFamily: 'Outfit'),
                ),
                const Divider(height: 20, color: Color(0xFFE2E8F0)),
                Text("Total Accuracy: ${(_score / javaQuizQuestions.length * 100).toInt()}%", style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
              ],
            ),
          ),
          const SizedBox(height: 40),
          // Back Button
          SizedBox(
            width: 200,
            height: 48,
            child: ElevatedButton(
              onPressed: () => widget.onQuizFinished(_score),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              ),
              child: const Text("Back to Materials", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}





