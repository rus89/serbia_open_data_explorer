// ABOUTME: GoRouter configuration with home and dataset detail routes.
// ABOUTME: Uses AppRoutes for paths; ShellRoute provides shared scaffold and app bar.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../presentation/dataset_detail_screen.dart';
import '../presentation/home_screen.dart';
import 'app_routes.dart';

/// Configures GoRouter with home (/) and dataset detail (/dataset/:id) routes.
GoRouter createAppRouter() {
  return GoRouter(
    initialLocation: AppRoutes.home,
    routes: [
      ShellRoute(
        builder: (context, state, child) => Scaffold(
          appBar: AppBar(
            title: const Text('Otvoreni podaci Srbije'),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1),
              child: Container(
                height: 1,
                color: Theme.of(context).colorScheme.outlineVariant,
              ),
            ),
          ),
          body: child,
        ),
        routes: [
          GoRoute(
            path: AppRoutes.home,
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: AppRoutes.datasetDetail,
            builder: (context, state) {
              final id = state.pathParameters['id'] ?? '';
              return DatasetDetailScreen(id: id);
            },
          ),
        ],
      ),
    ],
  );
}
