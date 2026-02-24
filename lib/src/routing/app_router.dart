// ABOUTME: GoRouter configuration with home, about, and dataset detail routes.
// ABOUTME: Uses AppRoutes for paths; ShellRoute has app bar and bottom nav (Početna, O Aplikaciji).

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../presentation/about_screen.dart';
import '../presentation/dataset_detail_screen.dart';
import '../presentation/home_screen.dart';
import 'app_routes.dart';

/// Configures GoRouter with home (/), about (/about), and dataset detail (/dataset/:id) routes.
GoRouter createAppRouter() {
  return GoRouter(
    initialLocation: AppRoutes.home,
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          final location = state.matchedLocation;
          final isAboutBranch = location == AppRoutes.about ||
              location.startsWith('${AppRoutes.about}/');
          final currentIndex = isAboutBranch ? 1 : 0;
          return Scaffold(
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
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: currentIndex,
              onTap: (index) {
                if (index == 0) {
                  context.go(AppRoutes.home);
                } else {
                  context.go(AppRoutes.about);
                }
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  activeIcon: Icon(Icons.home),
                  label: 'Početna',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.info_outline),
                  activeIcon: Icon(Icons.info),
                  label: 'O Aplikaciji',
                ),
              ],
            ),
          );
        },
        routes: [
          GoRoute(
            path: AppRoutes.home,
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: AppRoutes.about,
            builder: (context, state) => const AboutScreen(),
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
