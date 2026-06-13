import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'auth_provider.dart';

class NotificationModel {
  final String id;
  final String title;
  final String message;
  final String type;
  final bool isRead;
  final DateTime createdAt;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.isRead,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      title: json['title'],
      message: json['message'],
      type: json['type'],
      isRead: json['isRead'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

class NotificationNotifier extends StateNotifier<List<NotificationModel>> {
  final Ref ref;
  final Dio _dio = Dio();

  NotificationNotifier(this.ref) : super([]) {
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    final authState = ref.read(authProvider);
    if (!authState.isLoggedIn || authState.userData == null) return;

    final userId = authState.userData!['id'];
    final baseUrl = dotenv.env['API_BASE_URL'] ?? 'http://localhost:3000/api';

    try {
      final response = await _dio.get(
        '$baseUrl/notifications',
        options: Options(
          headers: {'x-user-id': userId},
        ),
      );

      if (response.statusCode == 200) {
        final List data = response.data;
        state = data.map((e) => NotificationModel.fromJson(e)).toList();
      }
    } catch (e) {
      // Handle error quietly for now
    }
  }

  int get unreadCount => state.where((n) => !n.isRead).length;

  Future<void> markAsRead(String id) async {
    final baseUrl = dotenv.env['API_BASE_URL'] ?? 'http://localhost:3000/api';
    try {
      await _dio.patch(
        '$baseUrl/notifications',
        data: {'id': id, 'action': 'read'},
      );
      state = [
        for (final notif in state)
          if (notif.id == id)
            NotificationModel(
              id: notif.id,
              title: notif.title,
              message: notif.message,
              type: notif.type,
              isRead: true,
              createdAt: notif.createdAt,
            )
          else
            notif
      ];
    } catch (e) {
      // ignore
    }
  }
}

final notificationProvider = StateNotifierProvider<NotificationNotifier, List<NotificationModel>>((ref) {
  return NotificationNotifier(ref);
});
