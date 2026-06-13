import 'package:flutter/material.dart';
import '../models/qc_session.dart';
import '../config/app_colors.dart';
import '../utils/date_formatter.dart';
import 'status_badge.dart';

class QcSessionCard extends StatelessWidget {
  final QcSession session;
  final VoidCallback onTap;

  const QcSessionCard({
    Key? key,
    required this.session,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.card),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Score Circle
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _getScoreColor(session.freshnessScore).withOpacity(0.15),
                ),
                child: Center(
                  child: Text(
                    session.freshnessScore.toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: _getScoreColor(session.freshnessScore),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      session.qcSessionId,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textMuted,
                        fontFamily: 'monospace',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      session.skuName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormatter.formatIndonesian(session.checkedAt),
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              // Status
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  StatusBadge(status: session.status),
                  const SizedBox(height: 8),
                  if (session.status == 'PENDING_SYNC')
                    const Icon(Icons.cloud_upload_outlined, size: 16, color: AppColors.statusWarning)
                  else if (session.syncedAt != null)
                    const Icon(Icons.cloud_done_outlined, size: 16, color: AppColors.statusSuccess),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getScoreColor(int score) {
    if (score >= 80) return AppColors.freshGreen;
    if (score >= 60) return AppColors.freshYellow;
    return AppColors.freshRed;
  }
}
