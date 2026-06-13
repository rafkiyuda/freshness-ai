import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'app.dart';
import 'services/local_db_service.dart';
import 'providers/service_providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load environment variables
  await dotenv.load(fileName: ".env");

  // Initialize local DB
  final localDb = LocalDbService();
  await localDb.init();

  runApp(
    ProviderScope(
      overrides: [
        localDbServiceProvider.overrideWithValue(localDb),
      ],
      child: const FreshnessApp(),
    ),
  );
}
