// ABOUTME: GoRouter configuration with home and dataset detail routes.
// ABOUTME: Uses AppRoutes for paths; ShellRoute provides shared scaffold and app bar.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../data/providers/dataset_providers.dart';
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
            builder: (context, state) => const _HomeScreen(),
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

class _HomeScreen extends ConsumerStatefulWidget {
  const _HomeScreen();

  @override
  ConsumerState<_HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<_HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchSubmitted(String value) {
    ref.read(datasetSearchParamsProvider.notifier).setQuery(value.trim());
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              labelText: 'Search datasets',
              hintText: 'Enter search term',
              border: OutlineInputBorder(),
            ),
            textInputAction: TextInputAction.search,
            onSubmitted: _onSearchSubmitted,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Catalog (home)'),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () =>
                        context.push(AppRoutes.datasetDetailPath('sample-id')),
                    child: const Text('Open sample dataset'),
                  ),
                ],
              ),
            ),
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
