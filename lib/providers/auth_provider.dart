import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../services/local_db_service.dart';
import 'service_providers.dart';

class AuthState {
  final bool isLoggedIn;
  final Map<String, dynamic>? userData;
  final bool isLoading;
  final String? error;

  AuthState({
    this.isLoggedIn = false,
    this.userData,
    this.isLoading = false,
    this.error,
  });

  AuthState copyWith({
    bool? isLoggedIn,
    Map<String, dynamic>? userData,
    bool? isLoading,
    String? error,
  }) {
    return AuthState(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      userData: userData ?? this.userData,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final LocalDbService _localDb;
  final Dio _dio = Dio();

  AuthNotifier(this._localDb) : super(AuthState()) {
    _loadUser();
  }

  void _loadUser() {
    final data = _localDb.getAuthData();
    if (data != null && data.containsKey('email')) {
      state = state.copyWith(isLoggedIn: true, userData: data);
    }
  }

  Future<bool> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _dio.post(
        'https://kongsi-logi.vercel.app/api/auth/login',
        data: {'email': email, 'password': password},
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        final userData = response.data['user'] as Map<String, dynamic>;
        // Save password locally for WebView SSO injection
        userData['password'] = password;
        
        await _localDb.saveAuthData(userData);
        state = state.copyWith(isLoggedIn: true, userData: userData, isLoading: false);
        return true;
      } else {
        state = state.copyWith(isLoading: false, error: 'Login gagal');
        return false;
      }
    } on DioException catch (e) {
      String errorMessage = 'Terjadi kesalahan jaringan';
      if (e.response != null && e.response?.data != null) {
        if (e.response?.data is Map && e.response?.data['error'] != null) {
           errorMessage = e.response?.data['error'];
        }
      }
      state = state.copyWith(isLoading: false, error: errorMessage);
      return false;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Terjadi kesalahan: \$e');
      return false;
    }
  }

  Future<void> logout() async {
    await _localDb.clearAuthData();
    state = AuthState();
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final localDb = ref.watch(localDbServiceProvider);
  return AuthNotifier(localDb);
});
