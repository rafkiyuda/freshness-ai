import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/local_db_service.dart';
import 'service_providers.dart';

class SettingsState {
  final bool darkMode;
  final bool notifLowStock;
  final bool notifExpiry;
  final bool notifAudit;
  final bool biometricAuth;

  SettingsState({
    this.darkMode = false,
    this.notifLowStock = true,
    this.notifExpiry = true,
    this.notifAudit = false,
    this.biometricAuth = false,
  });

  SettingsState copyWith({
    bool? darkMode,
    bool? notifLowStock,
    bool? notifExpiry,
    bool? notifAudit,
    bool? biometricAuth,
  }) {
    return SettingsState(
      darkMode: darkMode ?? this.darkMode,
      notifLowStock: notifLowStock ?? this.notifLowStock,
      notifExpiry: notifExpiry ?? this.notifExpiry,
      notifAudit: notifAudit ?? this.notifAudit,
      biometricAuth: biometricAuth ?? this.biometricAuth,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'darkMode': darkMode,
      'notifLowStock': notifLowStock,
      'notifExpiry': notifExpiry,
      'notifAudit': notifAudit,
      'biometricAuth': biometricAuth,
    };
  }

  factory SettingsState.fromMap(Map<String, dynamic> map) {
    return SettingsState(
      darkMode: map['darkMode'] ?? false,
      notifLowStock: map['notifLowStock'] ?? true,
      notifExpiry: map['notifExpiry'] ?? true,
      notifAudit: map['notifAudit'] ?? false,
      biometricAuth: map['biometricAuth'] ?? false,
    );
  }
}

class SettingsNotifier extends StateNotifier<SettingsState> {
  final LocalDbService _localDb;

  SettingsNotifier(this._localDb) : super(SettingsState()) {
    _loadSettings();
  }

  void _loadSettings() {
    final data = _localDb.getSettings();
    if (data != null) {
      state = SettingsState.fromMap(data);
    }
  }

  Future<void> updateSettings({
    bool? darkMode,
    bool? notifLowStock,
    bool? notifExpiry,
    bool? notifAudit,
    bool? biometricAuth,
  }) async {
    final newState = state.copyWith(
      darkMode: darkMode,
      notifLowStock: notifLowStock,
      notifExpiry: notifExpiry,
      notifAudit: notifAudit,
      biometricAuth: biometricAuth,
    );
    state = newState;
    await _localDb.saveSettings(newState.toMap());
  }
}

final settingsProvider = StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  final localDb = ref.watch(localDbServiceProvider);
  return SettingsNotifier(localDb);
});
