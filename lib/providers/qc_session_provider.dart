import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/qc_session.dart';
import 'service_providers.dart';

final qcSessionNotifierProvider = StateNotifierProvider<QcSessionNotifier, List<QcSession>>((ref) {
  return QcSessionNotifier(ref);
});

class QcSessionNotifier extends StateNotifier<List<QcSession>> {
  final Ref ref;

  QcSessionNotifier(this.ref) : super([]) {
    loadSessions();
  }

  void loadSessions() {
    final localDb = ref.read(localDbServiceProvider);
    state = localDb.getAllQcSessions();
  }

  Future<void> saveSession(QcSession session) async {
    final localDb = ref.read(localDbServiceProvider);
    await localDb.saveQcSession(session);
    loadSessions();
  }

  Future<void> deleteSession(String id) async {
    final localDb = ref.read(localDbServiceProvider);
    await localDb.deleteQcSession(id);
    loadSessions();
  }
}

final pendingSyncSessionsProvider = Provider<List<QcSession>>((ref) {
  final sessions = ref.watch(qcSessionNotifierProvider);
  return sessions.where((s) => s.status == 'PENDING_SYNC').toList();
});

final todaySessionsProvider = Provider<List<QcSession>>((ref) {
  final sessions = ref.watch(qcSessionNotifierProvider);
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  return sessions.where((s) {
    final sessionDate = DateTime(s.checkedAt.year, s.checkedAt.month, s.checkedAt.day);
    return sessionDate.isAtSameMomentAs(today);
  }).toList();
});

class QcSummary {
  final int total;
  final int fresh;
  final int warning;
  final int rejected;

  QcSummary({this.total = 0, this.fresh = 0, this.warning = 0, this.rejected = 0});
}

final qcSummaryProvider = Provider<QcSummary>((ref) {
  final todaySessions = ref.watch(todaySessionsProvider);
  int fresh = 0, warning = 0, rejected = 0;

  for (final s in todaySessions) {
    if (s.freshnessStatus == 'FRESH') fresh++;
    else if (s.freshnessStatus == 'WARNING') warning++;
    else if (s.freshnessStatus == 'CRITICAL') rejected++;
  }

  return QcSummary(
    total: todaySessions.length,
    fresh: fresh,
    warning: warning,
    rejected: rejected,
  );
});
