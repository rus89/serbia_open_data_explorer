// ABOUTME: Widget tests for DatasetDetailScreen. Uses ProviderScope with overridden datasetDetailProvider.
// ABOUTME: Verifies loading, error, and success states and that description, publisher, frequency, resources are shown.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:serbia_open_data_explorer/src/data/models/dataset.dart';
import 'package:serbia_open_data_explorer/src/data/models/resource.dart';
import 'package:serbia_open_data_explorer/src/data/providers/dataset_providers.dart';
import 'package:serbia_open_data_explorer/src/presentation/dataset_detail_screen.dart';

void main() {
  const testId = 'test-dataset-id';
  final fakeDataset = Dataset(
    id: testId,
    title: 'Test dataset title',
    description: 'Test description for the dataset.',
    organization: DatasetOrganization(id: 'org-1', name: 'Test Publisher'),
    frequency: 'mesečno',
    resources: [
      DatasetResource(
        id: 'res-1',
        title: 'Preuzmi CSV',
        url: 'https://data.gov.rs/resource/1.csv',
        format: 'CSV',
      ),
    ],
  );

  testWidgets('shows loading indicator while detail is loading', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          datasetDetailProvider(
            testId,
          ).overrideWith((ref) => Completer<Dataset>().future),
        ],
        child: MaterialApp(home: DatasetDetailScreen(id: testId)),
      ),
    );
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('shows error message when detail fails', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          datasetDetailProvider(testId).overrideWith(
            (ref) => Future<Dataset>.error(
              Exception('Load failed'),
              StackTrace.current,
            ),
          ),
        ],
        child: MaterialApp(home: DatasetDetailScreen(id: testId)),
      ),
    );
    await tester.pumpAndSettle();
    expect(
      find.textContaining('Nije moguće učitati skup podataka'),
      findsOneWidget,
    );
  });

  testWidgets(
    'shows title description publisher frequency and resources when loaded',
    (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            datasetDetailProvider(
              testId,
            ).overrideWith((ref) => Future<Dataset>.value(fakeDataset)),
          ],
          child: MaterialApp(home: DatasetDetailScreen(id: testId)),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Test dataset title'), findsOneWidget);
      expect(
        find.textContaining('Test description for the dataset.'),
        findsOneWidget,
      );
      expect(find.textContaining('Test Publisher'), findsOneWidget);
      expect(find.textContaining('mesečno'), findsOneWidget);
      expect(find.text('Preuzmi CSV'), findsOneWidget);
      expect(find.text('CSV'), findsOneWidget);
    },
  );
}
