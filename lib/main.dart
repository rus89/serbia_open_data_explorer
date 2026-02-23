// ABOUTME: App entry point. Wraps the app in ProviderScope and uses GoRouter for navigation.
// ABOUTME: Router is configured in src/routing/app_router.dart.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'src/presentation/theme/app_theme.dart';
import 'src/routing/app_router.dart';

void main() {
  runApp(const ProviderScope(child: SerbiaOpenDataExplorerApp()));
}

class SerbiaOpenDataExplorerApp extends StatelessWidget {
  const SerbiaOpenDataExplorerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Otvoreni podaci Srbije',
      theme: AppTheme.light,
      routerConfig: createAppRouter(),
    );
  }
}
