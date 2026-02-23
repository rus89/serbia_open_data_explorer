---
name: testing
description: |
  Testing for Serbia Open Data Explorer. Writes and validates tests
  for API clients, Riverpod providers, and Flutter widgets.
  USE WHEN: writing new tests, verifying test coverage, running the test suite.
---

# Testing Skill — Serbia Open Data Explorer

## Project Testing Rules

- **No mocks.** Tests use the real `data.gov.rs` API. Do not use mockito or any mock framework.
- **Real API tests** are tagged `@Tags(['integration'])` so they can be run separately.
- **Widget tests** use `ProviderScope` with real or overridden providers.
- All test files MUST start with ABOUTME comments (two lines, each starting with `// ABOUTME: `).

## Test Commands

```bash
flutter test                                  # All tests (integration + unit)
flutter test --exclude-tags=integration       # Widget/unit tests only (fast, no network)
flutter test --tags=integration               # Integration tests only (requires network)
flutter test test/path/to/test.dart           # Single file
flutter analyze                               # Static analysis (must be clean before commit)
```

## Integration Test Pattern (Real API)

```dart
// ABOUTME: Tests for DataGovRsApiClient against the live data.gov.rs API.
// ABOUTME: Requires network access. Tagged 'integration'.

import 'package:flutter_test/flutter_test.dart';
import 'package:serbia_open_data_explorer/src/data/api/data_gov_rs_api_client.dart';

@Tags(['integration'])
void main() {
  late DataGovRsApiClient client;

  setUp(() {
    client = DataGovRsApiClient(baseUrl: 'https://data.gov.rs/api/1/');
  });

  test('searchDatasets returns list', () async {
    final response = await client.searchDatasets(page: 1, limit: 5);
    expect(response.data, isA<List>());
  }, timeout: const Timeout(Duration(seconds: 30)));
}
```

## Widget Test Pattern (ProviderScope)

```dart
// ABOUTME: Widget tests for DatasetListScreen.
// ABOUTME: Uses ProviderScope with provider overrides for fast, isolated tests.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows loading indicator while fetching', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(home: DatasetListScreen()),
      ),
    );
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
```

## Provider Test Pattern

```dart
// ABOUTME: Tests for Riverpod dataset providers.
// ABOUTME: Verifies provider state transitions with real API.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:serbia_open_data_explorer/src/data/providers/dataset_providers.dart';

@Tags(['integration'])
void main() {
  test('datasetSearchResultsProvider returns data', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final result = await container.read(datasetSearchResultsProvider.future);
    expect(result.data, isNotEmpty);
  }, timeout: const Timeout(Duration(seconds: 30)));
}
```

## Test File Locations

| What | Where |
|------|-------|
| API client tests | `test/src/data/api/` |
| Provider tests | `test/src/data/providers/` |
| Widget tests | `test/src/presentation/` |

## Coverage

Target: 80%+ for all non-generated code. Run `flutter test --coverage` to check.
Excluded from coverage: `main.dart`, generated files.
