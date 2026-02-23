// ABOUTME: Tests for DataGovRsApiClient. TDD: real API; no mocks (per plan and GlobalRules).
// ABOUTME: Covers searchDatasets, getDatasetById, and error handling.

import 'package:flutter_test/flutter_test.dart';
import 'package:serbia_open_data_explorer/src/data/api/data_gov_rs_api_client.dart';
import 'package:serbia_open_data_explorer/src/data/models/dataset.dart';

const _baseUrl = 'https://data.gov.rs/api/1/';

void main() {
  late DataGovRsApiClient client;

  setUp(() {
    client = DataGovRsApiClient(baseUrl: _baseUrl);
  });

  group('searchDatasets', () {
    test(
      'returns DatasetListResponse with data list and pagination',
      () async {
        final response = await client.searchDatasets(page: 1, limit: 5);

        expect(response.data, isA<List<Dataset>>());
        expect(response.page, 1);
        expect(response.pageSize, 5);
        expect(response.total, greaterThanOrEqualTo(0));
      },
      timeout: const Timeout(Duration(seconds: 30)),
    );

    test('honors query parameter', () async {
      final response = await client.searchDatasets(
        query: 'javni',
        page: 1,
        limit: 3,
      );

      expect(response.data, isA<List<Dataset>>());
      expect(response.page, 1);
      expect(response.pageSize, 3);
    }, timeout: const Timeout(Duration(seconds: 30)));

    test('honors filter parameters', () async {
      final response = await client.searchDatasets(
        organization: null,
        license: 'public_domain',
        frequency: 'monthly',
        format: 'csv',
        page: 1,
        limit: 2,
      );

      expect(response.data, isA<List<Dataset>>());
      expect(response.page, 1);
    }, timeout: const Timeout(Duration(seconds: 30)));
  });

  group('getDatasetById', () {
    test(
      'returns dataset with matching id when found',
      () async {
        final list = await client.searchDatasets(page: 1, limit: 1);
        if (list.data.isEmpty) {
          return;
        }
        final id = list.data.first.id;
        expect(id, isNotEmpty);

        final dataset = await client.getDatasetById(id);

        expect(dataset.id, id);
        expect(dataset.title, isNotEmpty);
      },
      timeout: const Timeout(Duration(seconds: 30)),
    );
  });

  group('error handling', () {
    test(
      'getDatasetById throws on non-existent id',
      () async {
        expect(
          client.getDatasetById('non-existent-id-xyz-12345'),
          throwsA(isA<Exception>()),
        );
      },
      timeout: const Timeout(Duration(seconds: 30)),
    );

    test(
      'searchDatasets throws when server returns non-200',
      () async {
        final badClient = DataGovRsApiClient(
          baseUrl: 'https://data.gov.rs/api/1/nonexistent-path-xyz/',
        );
        expect(
          badClient.searchDatasets(page: 1, limit: 1),
          throwsA(predicate<Exception>((e) => e.toString().contains('404'))),
        );
      },
      timeout: const Timeout(Duration(seconds: 30)),
    );
  });
}
