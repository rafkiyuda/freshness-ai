import 'dart:async';
import 'local_db_service.dart';
import 'api_service.dart';

class SyncService {
  final LocalDbService _localDb;
  final ApiService _api;
  bool _isSyncing = false;

  SyncService(this._localDb, this._api);

  /// Iterates through all PENDING_SYNC sessions and tries to sync them.
  /// Returns the number of successfully synced sessions.
  Future<int> syncPendingSessions() async {
    if (_isSyncing) return 0;
    _isSyncing = true;
    int successCount = 0;

    try {
      final pendingSessions = _localDb.getPendingSyncSessions();
      
      for (final session in pendingSessions) {
        final success = await _api.postQcSession(session);
        
        if (success) {
          session.syncedAt = DateTime.now();
          // Status depends on the original staff decision
          if (session.staffDecision == 'ACCEPT' || session.staffDecision == 'PARTIAL_ACCEPT') {
            session.status = 'APPROVED_FOR_RECEIVING';
          } else if (session.staffDecision == 'REJECT') {
            session.status = 'REJECTED';
          } else {
            session.status = 'NEED_SORTING';
          }
          
          await _localDb.saveQcSession(session);
          successCount++;
        }
      }
    } finally {
      _isSyncing = false;
    }

    return successCount;
  }
}
