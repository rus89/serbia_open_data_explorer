---
name: flutter-developer
description: |
  Flutter development for screens, features, and business logic.
  USE WHEN: creating screens, implementing navigation,
  fixing bugs, state management, Riverpod providers.

  Examples:
  <example>
  Context: User needs a new feature screen.
  user: "Implement the dataset catalog search screen"
  assistant: "I'll use flutter-developer skill for this screen with Riverpod state and GoRouter navigation."
  <commentary>Screens with state and navigation use flutter-developer.</commentary>
  </example>
---

# Flutter Developer Skill

Handles ALL Flutter development for this project: bug fixes, screens, navigation, and Riverpod state management.

## Project Context

- **App:** Serbia Open Data Explorer — mobile catalog browser for `data.gov.rs` datasets
- **State:** Riverpod (`flutter_riverpod`) — FutureProvider, NotifierProvider
- **Navigation:** GoRouter — routes defined in `lib/src/routing/app_router.dart`
- **Routes:** `AppRoutes.home` (`/`), `AppRoutes.datasetDetail` (`/dataset/:id`)
- **API:** `DataGovRsApiClient` in `lib/src/data/api/`
- **Providers:** `lib/src/data/providers/dataset_providers.dart`

## Scope

**You Handle:**

- Bug fixes (any file count)
- New screens and widgets
- Riverpod provider implementation
- GoRouter navigation
- API integration via existing providers
- Error and loading state handling

## Core Expertise

- Flutter 3.x (mobile-first)
- Material Design 3
- GoRouter declarative navigation
- Riverpod async providers (`FutureProvider.when`, `AsyncValue`)

## Critical Rules

- NEVER use BuildContext after async without checking `mounted`
- NEVER hardcode routes — use `AppRoutes` constants
- ALWAYS prefer editing existing files over creating new ones
- ALWAYS handle errors with try-catch for async operations
- ALWAYS dispose controllers and resources
- ALWAYS follow naming conventions strictly
- ALWAYS write ABOUTME comments at the top of every new file

## Riverpod Patterns

```dart
// Read async provider in widget
ref.watch(datasetSearchResultsProvider).when(
  data: (result) => ...,
  loading: () => const CircularProgressIndicator(),
  error: (e, _) => Text('Error: $e'),
);

// Update search params
ref.read(datasetSearchParamsProvider.notifier).setQuery('javni');
```

## Navigation Patterns

```dart
// Navigate to detail
context.push(AppRoutes.datasetDetail.replaceFirst(':id', dataset.id));

// Go back
context.pop();
```

## Testing Commands

```bash
flutter test                                  # All tests (including integration)
flutter test --exclude-tags=integration       # Unit/widget tests only
flutter test test/path/to/test.dart           # Single file
flutter analyze                               # Static analysis
```
