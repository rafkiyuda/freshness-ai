import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/app_colors.dart';
import '../../providers/service_providers.dart';
import '../../models/qc_session.dart';
import '../../utils/date_formatter.dart';
import '../../widgets/freshness_gauge.dart';
import '../../widgets/status_badge.dart';

class QcDetailScreen extends ConsumerStatefulWidget {
  final String qcSessionId;

  const QcDetailScreen({Key? key, required this.qcSessionId}) : super(key: key);

  @override
  ConsumerState<QcDetailScreen> createState() => _QcDetailScreenState();
}

class _QcDetailScreenState extends ConsumerState<QcDetailScreen> {
  QcSession? session;

  @override
  void initState() {
    super.initState();
    _loadSession();
  }

  void _loadSession() {
    final s = ref.read(localDbServiceProvider).getQcSessionById(widget.qcSessionId);
    setState(() {
      session = s;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (session == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Detail QC Session')),
        body: const Center(child: Text('Sesi tidak ditemukan')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail QC Session'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Header
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      session!.qcSessionId,
                      style: const TextStyle(fontSize: 18, fontFamily: 'monospace', fontWeight: FontWeight.bold),
                    ),
                    StatusBadge(status: session!.status),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Product Info
            Card(
              child: ListTile(
                title: Text(session!.skuName, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('Supplier: ${session!.supplierName}'),
              ),
            ),
            const SizedBox(height: 16),

            // AI Result
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Text('Hasil AI', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        FreshnessGauge(score: session!.freshnessScore, radius: 45, fontSize: 24),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            StatusBadge(status: session!.freshnessStatus),
                            const SizedBox(height: 8),
                            Text('Confidence: ${session!.confidenceScore}%', style: const TextStyle(color: AppColors.textMuted)),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.bgTertiary,
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                      ),
                      child: Text(session!.aiRecommendation, style: const TextStyle(color: AppColors.textSecondary)),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Staff Decision
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Keputusan Staff', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    StatusBadge(status: session!.staffDecision),
                    if (session!.notes != null && session!.notes!.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      const Text('Catatan:', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                      Text(session!.notes!),
                    ]
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Metadata
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _MetaRow(label: 'Diperiksa pada', value: DateFormatter.formatIndonesian(session!.checkedAt)),
                    const Divider(),
                    _MetaRow(label: 'Diperiksa oleh', value: session!.checkedBy),
                    const Divider(),
                    _MetaRow(
                      label: 'Disinkronkan pada', 
                      value: session!.syncedAt != null ? DateFormatter.formatIndonesian(session!.syncedAt!) : 'Belum sinkron',
                      valueColor: session!.syncedAt != null ? AppColors.statusSuccess : AppColors.statusWarning,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _MetaRow({required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: AppColors.textSecondary)),
        Text(value, style: TextStyle(fontWeight: FontWeight.w600, color: valueColor ?? AppColors.textPrimary)),
      ],
    );
  }
}
