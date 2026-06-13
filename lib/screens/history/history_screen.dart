import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/qc_session_provider.dart';
import '../../widgets/qc_session_card.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allSessions = ref.watch(qcSessionNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat QC'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.read(qcSessionNotifierProvider.notifier).loadSessions();
        },
        child: allSessions.isEmpty
            ? const Center(child: Text('Belum ada riwayat QC'))
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: allSessions.length,
                itemBuilder: (context, index) {
                  final session = allSessions[index];
                  return QcSessionCard(
                    session: session,
                    onTap: () => context.push('/qc-detail/${session.qcSessionId}'),
                  );
                },
              ),
      ),
    );
  }
}
