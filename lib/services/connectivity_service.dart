import 'package:connectivity_plus/connectivity_plus.dart';


class ConnectivityService {
  final Connectivity _connectivity = Connectivity();

  Stream<List<ConnectivityResult>> get onConnectivityChanged => _connectivity.onConnectivityChanged;

  Future<bool> isOnline() async {
    final result = await _connectivity.checkConnectivity();
    return _isOnlineResult(result);
  }

  bool _isOnlineResult(List<ConnectivityResult> results) {
    if (results.isEmpty) return false;
    // Consider online if there is Wifi, Mobile, or Ethernet
    return results.any((r) => r == ConnectivityResult.wifi || r == ConnectivityResult.mobile || r == ConnectivityResult.ethernet);
  }
}
