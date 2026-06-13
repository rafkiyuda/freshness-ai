import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/app_bottom_nav.dart';
import '../screens/home/home_screen.dart';
import '../screens/new_qc/new_qc_form_screen.dart';
import '../screens/new_qc/camera_check_screen.dart';
import '../screens/new_qc/qc_decision_screen.dart';
import '../screens/history/history_screen.dart';
import '../screens/history/qc_detail_screen.dart';
import '../screens/sync/pending_sync_screen.dart';
import '../screens/webview/rfid_webview_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/profile/settings_screen.dart';
import '../screens/profile/help_center_screen.dart';
import '../screens/notifications/notifications_screen.dart';
import '../providers/auth_provider.dart';
import '../providers/settings_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');

// We need a provider for the router so it can watch AuthState
final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    redirect: (context, state) {
      final isLoggingIn = state.uri.path == '/login';
      final isLoggedIn = authState.isLoggedIn;

      if (!isLoggedIn && !isLoggingIn) return '/login';
      
      if (isLoggedIn && isLoggingIn) {
        return '/';
      }
      
      return null;
    },
    routes: [
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return ScaffoldWithBottomNav(child: child);
      },
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/new-qc',
          builder: (context, state) => const NewQcFormScreen(),
        ),
        GoRoute(
          path: '/history',
          builder: (context, state) => const HistoryScreen(),
        ),
        GoRoute(
          path: '/rfid-web',
          builder: (context, state) => const RfidWebviewScreen(),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const ProfileScreen(),
        ),
      ],
    ),
    GoRoute(
      path: '/camera-check',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final extras = state.extra as Map<String, dynamic>? ?? {};
        return CameraCheckScreen(
          skuId: extras['skuId'] ?? '',
          skuName: extras['skuName'] ?? '',
          supplierId: extras['supplierId'] ?? '',
          supplierName: extras['supplierName'] ?? '',
          notes: extras['notes'] ?? '',
        );
      },
    ),
    GoRoute(
      path: '/qc-decision',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final extras = state.extra as Map<String, dynamic>? ?? {};
        return QcDecisionScreen(
          skuId: extras['skuId'] ?? '',
          skuName: extras['skuName'] ?? '',
          supplierId: extras['supplierId'] ?? '',
          supplierName: extras['supplierName'] ?? '',
          notes: extras['notes'] ?? '',
          freshnessScore: extras['freshnessScore'] ?? 0,
          freshnessStatus: extras['freshnessStatus'] ?? 'CRITICAL',
          confidenceScore: extras['confidenceScore'] ?? 0,
          aiRecommendation: extras['aiRecommendation'] ?? '',
        );
      },
    ),
    GoRoute(
      path: '/qc-detail/:id',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return QcDetailScreen(qcSessionId: id);
      },
    ),
    GoRoute(
      path: '/pending-sync',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const PendingSyncScreen(),
    ),
    GoRoute(
      path: '/notifications',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const NotificationsScreen(),
    ),
    GoRoute(
      path: '/settings',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: '/help',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const HelpCenterScreen(),
    ),
    GoRoute(
      path: '/login',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const LoginScreen(),
    ),
  ],
);
});
