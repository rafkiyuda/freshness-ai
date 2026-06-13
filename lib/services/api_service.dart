import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/qc_session.dart';

class ApiService {
  late final Dio _dio;

  ApiService() {
    final baseUrl = dotenv.env['API_BASE_URL'] ?? 'http://localhost:3000/api';
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );

    // Logging interceptor for debugging
    _dio.interceptors.add(LogInterceptor(responseBody: true, requestBody: true));
  }

  /// Syncs a single QC session to the backend.
  /// Returns true if successful, false if it failed.
  Future<bool> postQcSession(QcSession session) async {
    try {
      final response = await _dio.post(
        '/qc-sessions',
        data: session.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }
      return false;
    } on DioException catch (e) {
      // If the API returns a conflict (already exists), treat it as success to clear local queue
      if (e.response?.statusCode == 409) {
        return true; 
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Fetches approved QC sessions (mock implementation for completeness)
  Future<List<dynamic>> getApprovedQcSessions() async {
    try {
      final response = await _dio.get('/qc-sessions', queryParameters: {
        'status': 'APPROVED_FOR_RECEIVING',
      });
      return response.data['data'] ?? [];
    } catch (e) {
      return [];
    }
  }
}
