import 'package:flutter/material.dart';
import '../config/app_colors.dart';

class StatusBadge extends StatelessWidget {
  final String status;
  
  const StatusBadge({Key? key, required this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor;
    String text;

    switch (status.toUpperCase()) {
      case 'FRESH':
        bgColor = AppColors.freshGreen.withOpacity(0.15);
        textColor = AppColors.freshGreen;
        text = 'FRESH';
        break;
      case 'WARNING':
        bgColor = AppColors.freshYellow.withOpacity(0.15);
        textColor = AppColors.freshYellow;
        text = 'WARNING';
        break;
      case 'CRITICAL':
        bgColor = AppColors.freshRed.withOpacity(0.15);
        textColor = AppColors.freshRed;
        text = 'CRITICAL';
        break;
      case 'APPROVED_FOR_RECEIVING':
        bgColor = AppColors.statusSuccess.withOpacity(0.15);
        textColor = AppColors.statusSuccess;
        text = 'APPROVED';
        break;
      case 'REJECTED':
        bgColor = AppColors.statusError.withOpacity(0.15);
        textColor = AppColors.statusError;
        text = 'REJECTED';
        break;
      case 'NEED_SORTING':
        bgColor = AppColors.textSecondary.withOpacity(0.15);
        textColor = AppColors.textSecondary;
        text = 'NEED SORTING';
        break;
      case 'PENDING_SYNC':
        bgColor = AppColors.statusWarning.withOpacity(0.15);
        textColor = AppColors.statusWarning;
        text = 'PENDING SYNC';
        break;
      default:
        bgColor = AppColors.borderColor;
        textColor = AppColors.textSecondary;
        text = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppRadius.chip),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
