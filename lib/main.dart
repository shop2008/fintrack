import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fintrack/screens/home_screen.dart';
import 'package:fintrack/screens/login_screen.dart';
import 'package:fintrack/services/auth_service.dart';
import 'package:fintrack/theme/app_theme.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authServiceProvider);

    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'FinTrack',
      theme: AppTheme.lightTheme,
      home: authState.isAuthenticated ? HomeScreen() : LoginScreen(),
    );
  }
}
