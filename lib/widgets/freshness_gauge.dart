import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../config/app_colors.dart';

class FreshnessGauge extends StatelessWidget {
  final int score;
  final double radius;
  final double lineWidth;
  final double fontSize;

  const FreshnessGauge({
    Key? key,
    required this.score,
    this.radius = 60.0,
    this.lineWidth = 12.0,
    this.fontSize = 32.0,
  }) : super(key: key);

  Color _getColor(int s) {
    if (s >= 80) return AppColors.freshGreen;
    if (s >= 60) return AppColors.freshYellow;
    return AppColors.freshRed;
  }

  @override
  Widget build(BuildContext context) {
    return CircularPercentIndicator(
      radius: radius,
      lineWidth: lineWidth,
      animation: true,
      animateFromLastPercent: true,
      percent: (score.clamp(0, 100)) / 100,
      center: Text(
        score.toString(),
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: fontSize,
          color: AppColors.textPrimary,
        ),
      ),
      circularStrokeCap: CircularStrokeCap.round,
      progressColor: _getColor(score),
      backgroundColor: AppColors.borderColor,
    );
  }
}
