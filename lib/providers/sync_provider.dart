import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'service_providers.dart';
import 'qc_session_provider.dart';

final syncProvider = StateNotifierProvider<SyncNotifier, bool>((ref) {
  return SyncNotifier(ref);
});

class SyncNotifier extends StateNotifier<bool> {
  final Ref ref;

  SyncNotifier(this.ref) : super(false);

  Future<void> syncNow() async {
    if (state) return; // already syncing
    state = true;
    try {
      final syncService = ref.read(syncServiceProvider);
      await syncService.syncPendingSessions();
      
      // Reload sessions after sync to update UI
      ref.read(qcSessionNotifierProvider.notifier).loadSessions();
    } finally {
      state = false;
    }
  }
}
