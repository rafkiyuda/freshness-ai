import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../config/app_colors.dart';
import '../../models/qc_session.dart';
import '../../providers/qc_session_provider.dart';
import '../../providers/sync_provider.dart';
import '../../providers/service_providers.dart';
import '../../utils/id_generator.dart';
import '../../widgets/decision_button.dart';
import '../../widgets/freshness_gauge.dart';
import '../../widgets/status_badge.dart';

class QcDecisionScreen extends ConsumerStatefulWidget {
  final String skuId;
  final String skuName;
  final String supplierId;
  final String supplierName;
  final String notes;
  final int freshnessScore;
  final String freshnessStatus;
  final int confidenceScore;
  final String aiRecommendation;

  const QcDecisionScreen({
    Key? key,
    required this.skuId,
    required this.skuName,
    required this.supplierId,
    required this.supplierName,
    required this.notes,
    required this.freshnessScore,
    required this.freshnessStatus,
    required this.confidenceScore,
    required this.aiRecommendation,
  }) : super(key: key);

  @override
  ConsumerState<QcDecisionScreen> createState() => _QcDecisionScreenState();
}

class _QcDecisionScreenState extends ConsumerState<QcDecisionScreen> {
  final TextEditingController _finalNotesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _finalNotesController.text = widget.notes;
  }

  @override
  void dispose() {
    _finalNotesController.dispose();
    super.dispose();
  }

  Future<void> _handleDecision(String decision) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Keputusan'),
        content: Text('Yakin ingin memilih keputusan:\n$decision?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Batal')),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Save QC Result')),
        ],
      ),
    );

    if (confirm != true) return;

    // Generate ID
    final qcId = await IdGenerator.generateQcSessionId();

    final session = QcSession(
      qcSessionId: qcId,
      skuId: widget.skuId,
      skuName: widget.skuName,
      supplierId: widget.supplierId,
      supplierName: widget.supplierName,
      freshnessScore: widget.freshnessScore,
      freshnessStatus: widget.freshnessStatus,
      confidenceScore: widget.confidenceScore,
      aiRecommendation: widget.aiRecommendation,
      staffDecision: decision,
      status: 'PENDING_SYNC', // Default offline
      notes: _finalNotesController.text,
      checkedAt: DateTime.now(),
      checkedBy: 'staff_001', // Hardcoded staff id
    );

    // Save local
    await ref.read(qcSessionNotifierProvider.notifier).saveSession(session);

    // Check online and sync
    final isOnline = await ref.read(connectivityServiceProvider).isOnline();
    if (isOnline) {
      // Trigger background sync
      ref.read(syncProvider.notifier).syncNow();
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Disimpan offline, akan disinkronkan otomatis saat online')),
        );
      }
    }

    if (mounted) {
      context.go('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Staff Decision'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Summary Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      widget.skuName,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                    ),
                    Text(
                      widget.supplierName,
                      style: const TextStyle(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 24),
                    FreshnessGauge(score: widget.freshnessScore, radius: 50),
                    const SizedBox(height: 16),
                    StatusBadge(status: widget.freshnessStatus),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.bgTertiary,
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.auto_awesome, size: 16, color: AppColors.accentPrimary),
                              SizedBox(width: 8),
                              Text('Rekomendasi AI', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(widget.aiRecommendation, style: const TextStyle(color: AppColors.textSecondary)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            TextField(
              controller: _finalNotesController,
              maxLines: 2,
              decoration: const InputDecoration(
                hintText: 'Tambahkan catatan keputusan...',
                labelText: 'Catatan Akhir',
              ),
            ),
            
            const SizedBox(height: 24),

            DecisionButton(
              label: 'ACCEPT',
              icon: Icons.check_circle,
              color: AppColors.statusSuccess,
              onPressed: () => _handleDecision('ACCEPT'),
            ),
            DecisionButton(
              label: 'PARTIAL_ACCEPT',
              icon: Icons.warning_rounded,
              color: AppColors.statusWarning,
              onPressed: () => _handleDecision('PARTIAL_ACCEPT'),
            ),
            DecisionButton(
              label: 'NEED_SORTING',
              icon: Icons.sync,
              color: AppColors.textMuted,
              onPressed: () => _handleDecision('NEED_SORTING'),
            ),
            DecisionButton(
              label: 'REJECT',
              icon: Icons.cancel,
              color: AppColors.statusError,
              onPressed: () => _handleDecision('REJECT'),
            ),
          ],
        ),
      ),
    );
  }
}
