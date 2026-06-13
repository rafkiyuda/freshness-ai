import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/app_colors.dart';
import '../../providers/qc_session_provider.dart';
import '../../providers/sync_provider.dart';
import '../../providers/connectivity_provider.dart';
import '../../widgets/qc_session_card.dart';

class PendingSyncScreen extends ConsumerWidget {
  const PendingSyncScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pendingSessions = ref.watch(pendingSyncSessionsProvider);
    final isSyncing = ref.watch(syncProvider);
    final isOnlineAsync = ref.watch(isOnlineProvider);
    final isOnline = isOnlineAsync.value ?? false;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Menunggu Sinkronisasi'),
      ),
      body: Column(
        children: [
          // Connection Status Banner
          Container(
            padding: const EdgeInsets.all(12),
            color: isOnline ? AppColors.statusSuccess.withOpacity(0.1) : AppColors.statusError.withOpacity(0.1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isOnline ? Icons.wifi : Icons.wifi_off,
                  color: isOnline ? AppColors.statusSuccess : AppColors.statusError,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  isOnline ? 'Terhubung ke Jaringan' : 'Offline - Tidak ada Jaringan',
                  style: TextStyle(
                    color: isOnline ? AppColors.statusSuccess : AppColors.statusError,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          
          Expanded(
            child: pendingSessions.isEmpty
              ? const Center(child: Text('Semua data sudah tersinkronisasi'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: pendingSessions.length,
                  itemBuilder: (context, index) {
                    final session = pendingSessions[index];
                    return QcSessionCard(
                      session: session,
                      onTap: () {}, // No drill down for pending list usually, or go to detail
                    );
                  },
                ),
          ),

          // Sync All Button
          if (pendingSessions.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: (!isOnline || isSyncing) 
                    ? null 
                    : () => ref.read(syncProvider.notifier).syncNow(),
                  icon: isSyncing 
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Icon(Icons.sync),
                  label: Text(isSyncing ? 'Menyinkronkan...' : 'Sinkronkan Semua'),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
