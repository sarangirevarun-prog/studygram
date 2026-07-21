import 'package:flutter/material.dart';
import 'package:study_gram/theme/colors.dart';

class MockStatusBar extends StatelessWidget {
  const MockStatusBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 12, bottom: 4),
      color: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "09:41",
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 12,
              letterSpacing: 0.1,
            ),
          ),
          Row(
            children: [
              Icon(Icons.signal_cellular_alt, color: AppColors.textPrimary, size: 14),
              const SizedBox(width: 6),
              Icon(Icons.wifi, color: AppColors.textPrimary, size: 14),
              const SizedBox(width: 6),
              Container(
                width: 20,
                height: 10,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.textPrimary.withValues(alpha: 0.9), width: 1),
                  borderRadius: BorderRadius.circular(2.5),
                ),
                padding: const EdgeInsets.all(0.8),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.textPrimary,
                          borderRadius: BorderRadius.circular(1),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
