// ABOUTME: Widget test for app → list → detail flow. Pumps full app with overridden API client.
// ABOUTME: Verifies opening app, list showing one dataset, tap navigates to detail with expected content.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:serbia_open_data_explorer/main.dart';
import 'package:serbia_open_data_explorer/src/data/api/data_gov_rs_api_client.dart';
import 'package:serbia_open_data_explorer/src/data/models/dataset.dart';
import 'package:serbia_open_data_explorer/src/data/models/filter_options.dart';
import 'package:serbia_open_data_explorer/src/data/models/resource.dart';
import 'package:serbia_open_data_explorer/src/data/providers/dataset_providers.dart';

const String _flowTestId = 'flow-test-dataset-id';
const String _flowTestTitle = 'Flow test dataset title';

final Dataset _flowTestDataset = Dataset(
  id: _flowTestId,
  title: _flowTestTitle,
  description: 'Description for flow test.',
  organization: DatasetOrganization(id: 'org-1', name: 'Test org'),
  frequency: 'godišnje',
  resources: [
    DatasetResource(
      id: 'res-1',
      title: 'Preuzmi CSV',
      url: 'https://data.gov.rs/resource/1.csv',
      format: 'CSV',
    ),
  ],
);

final DatasetListResponse _flowTestListResponse = DatasetListResponse(
  data: [_flowTestDataset],
  page: 1,
  pageSize: 20,
  total: 1,
);

class _FakeDataGovRsApiClient implements DataGovRsApiClient {
  _FakeDataGovRsApiClient({required this.baseUrl});

  @override
  final String baseUrl;

  @override
  Future<DatasetListResponse> searchDatasets({
    String? query,
    String? organization,
    String? license,
    String? frequency,
    String? format,
    int? page,
    int? limit,
  }) async => _flowTestListResponse;

  @override
  Future<Dataset> getDatasetById(String id) async {
    if (id == _flowTestId) return _flowTestDataset;
    throw Exception('Not found: $id');
  }

  @override
  Future<List<LicenseOption>> getLicenses() async => [];

  @override
  Future<List<FrequencyOption>> getFrequencies() async => [];

  @override
  Future<List<OrganizationOption>> getOrganizations({
    int pageSize = 200,
  }) async => [];
}

void main() {
  testWidgets(
    'open app → list shows dataset → tap → detail shows title and resources',
    (WidgetTester tester) async {
      final fakeClient = _FakeDataGovRsApiClient(
        baseUrl: 'https://data.gov.rs/api/1/',
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [dataGovRsApiClientProvider.overrideWithValue(fakeClient)],
          child: const SerbiaOpenDataExplorerApp(),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text(_flowTestTitle), findsOneWidget);

      await tester.tap(find.text(_flowTestTitle));
      await tester.pumpAndSettle();

      expect(find.text(_flowTestTitle), findsOneWidget);
      expect(
        find.byWidgetPredicate(
          (Widget w) =>
              w is Text && (w.data ?? '').startsWith('Resursi za preuzimanje'),
        ),
        findsOneWidget,
      );
      expect(find.text('Preuzmi CSV'), findsOneWidget);
    },
  );
}
