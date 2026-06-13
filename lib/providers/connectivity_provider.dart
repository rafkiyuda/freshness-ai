import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'service_providers.dart';

final connectivityStreamProvider = StreamProvider<List<ConnectivityResult>>((ref) {
  final service = ref.watch(connectivityServiceProvider);
  return service.onConnectivityChanged;
});

final isOnlineProvider = FutureProvider<bool>((ref) async {
  // Watch the stream to rebuild when connection changes
  final result = ref.watch(connectivityStreamProvider);
  
  if (result.hasValue && result.value!.isNotEmpty) {
    return result.value!.any((r) => r == ConnectivityResult.wifi || r == ConnectivityResult.mobile || r == ConnectivityResult.ethernet);
  }
  
  final service = ref.read(connectivityServiceProvider);
  return service.isOnline();
});
