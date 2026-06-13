import 'package:hive_flutter/hive_flutter.dart';
import '../models/qc_session.dart';
import '../config/constants.dart';

class LocalDbService {
  late Box<QcSession> _qcBox;
  late Box _authBox;
  late Box _settingsBox;

  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(QcSessionAdapter());
    _qcBox = await Hive.openBox<QcSession>(Constants.hiveBoxQcSessions);
    _authBox = await Hive.openBox('authBox');
    _settingsBox = await Hive.openBox('settingsBox');
  }

  // === Auth Methods ===
  Future<void> saveAuthData(Map<String, dynamic> data) async {
    await _authBox.putAll(data);
  }

  Map<String, dynamic>? getAuthData() {
    if (_authBox.isEmpty) return null;
    return Map<String, dynamic>.from(_authBox.toMap());
  }

  Future<void> clearAuthData() async {
    await _authBox.clear();
  }

  // === Settings Methods ===
  Future<void> saveSettings(Map<String, dynamic> data) async {
    await _settingsBox.putAll(data);
  }

  Map<String, dynamic>? getSettings() {
    if (_settingsBox.isEmpty) return null;
    return Map<String, dynamic>.from(_settingsBox.toMap());
  }

  // === QC Methods ===

  Future<void> saveQcSession(QcSession session) async {
    await _qcBox.put(session.qcSessionId, session);
  }

  List<QcSession> getAllQcSessions() {
    return _qcBox.values.toList()..sort((a, b) => b.checkedAt.compareTo(a.checkedAt));
  }

  List<QcSession> getPendingSyncSessions() {
    return _qcBox.values.where((s) => s.status == 'PENDING_SYNC').toList();
  }

  List<QcSession> getTodaySessions() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return _qcBox.values.where((s) {
      final sessionDate = DateTime(s.checkedAt.year, s.checkedAt.month, s.checkedAt.day);
      return sessionDate.isAtSameMomentAs(today);
    }).toList();
  }

  QcSession? getQcSessionById(String id) {
    return _qcBox.get(id);
  }

  Future<void> deleteQcSession(String id) async {
    await _qcBox.delete(id);
  }

  Future<void> clearAll() async {
    await _qcBox.clear();
  }
}
