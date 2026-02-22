// ABOUTME: GoRouter configuration with home and dataset detail routes.
// ABOUTME: Uses AppRoutes for paths; ShellRoute provides shared scaffold and app bar.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'app_routes.dart';

/// Configures GoRouter with home (/) and dataset detail (/dataset/:id) routes.
GoRouter createAppRouter() {
  return GoRouter(
    initialLocation: AppRoutes.home,
    routes: [
      ShellRoute(
        builder: (context, state, child) => Scaffold(
          appBar: AppBar(title: const Text('Serbia Open Data')),
          body: child,
        ),
        routes: [
          GoRoute(
            path: AppRoutes.home,
            builder: (context, state) => const _PlaceholderHomeScreen(),
          ),
          GoRoute(
            path: AppRoutes.datasetDetail,
            builder: (context, state) {
              final id = state.pathParameters['id'] ?? '';
              return _PlaceholderDetailScreen(id: id);
            },
          ),
        ],
      ),
    ],
  );
}

class _PlaceholderHomeScreen extends StatelessWidget {
  const _PlaceholderHomeScreen();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Catalog (home)'),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () => context.push(AppRoutes.datasetDetailPath('sample-id')),
            child: const Text('Open sample dataset'),
          ),
        ],
      ),
    );
  }
}

class _PlaceholderDetailScreen extends StatelessWidget {
  const _PlaceholderDetailScreen({required this.id});

  final String id;

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Dataset: $id'));
  }
}
