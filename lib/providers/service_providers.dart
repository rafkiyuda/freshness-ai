import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/api_service.dart';
import '../services/local_db_service.dart';
import '../services/connectivity_service.dart';
import '../services/sync_service.dart';
import '../services/freshness_ai_service.dart';

final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService();
});

final localDbServiceProvider = Provider<LocalDbService>((ref) {
  return LocalDbService();
});

final connectivityServiceProvider = Provider<ConnectivityService>((ref) {
  return ConnectivityService();
});

final syncServiceProvider = Provider<SyncService>((ref) {
  return SyncService(
    ref.read(localDbServiceProvider),
    ref.read(apiServiceProvider),
  );
});

final freshnessAiServiceProvider = Provider<FreshnessAiService>((ref) {
  return FreshnessAiService();
});
