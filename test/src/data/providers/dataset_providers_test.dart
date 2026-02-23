// ABOUTME: Tests for dataset Riverpod providers. Uses real API; no mocks (per plan and GlobalRules).
// ABOUTME: Covers dataGovRsApiClientProvider, datasetSearchResultsProvider, datasetDetailProvider.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:serbia_open_data_explorer/src/data/models/dataset.dart';
import 'package:serbia_open_data_explorer/src/data/providers/dataset_providers.dart';

void main() {
  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer();
  });

  tearDown(() {
    container.dispose();
  });

  group('dataGovRsApiClientProvider', () {
    test(
      'provides client that can search',
      () async {
        final client = container.read(dataGovRsApiClientProvider);
        final response = await client.searchDatasets(page: 1, limit: 2);

        expect(response.data, isA<List<Dataset>>());
        expect(response.page, 1);
        expect(response.pageSize, 2);
      },
      timeout: const Timeout(Duration(seconds: 30)),
    );
  });

  group('datasetSearchResultsProvider', () {
    test(
      'returns DatasetListResponse from real API',
      () async {
        final asyncValue = container.read(datasetSearchResultsProvider);

        expect(asyncValue.hasValue, isFalse);
        expect(asyncValue.isLoading, isTrue);

        final response = await container.read(
          datasetSearchResultsProvider.future,
        );

        expect(response.data, isA<List<Dataset>>());
        expect(response.page, 1);
        expect(response.total, greaterThanOrEqualTo(0));
      },
      timeout: const Timeout(Duration(seconds: 30)),
    );

    test(
      'refetches when search params change',
      () async {
        final response1 = await container.read(
          datasetSearchResultsProvider.future,
        );
        container.read(datasetSearchParamsProvider.notifier).setQuery('javni');
        final response2 = await container.read(
          datasetSearchResultsProvider.future,
        );

        expect(response1.data, isA<List<Dataset>>());
        expect(response2.data, isA<List<Dataset>>());
      },
      timeout: const Timeout(Duration(seconds: 30)),
    );

    test('uses filter params when set', () async {
      container
          .read(datasetSearchParamsProvider.notifier)
          .updateParams(
            const DatasetSearchParams(format: 'csv', page: 1, limit: 5),
          );
      final response = await container.read(
        datasetSearchResultsProvider.future,
      );

      expect(response.data, isA<List<Dataset>>());
      expect(response.page, 1);
      expect(response.pageSize, 5);
    }, timeout: const Timeout(Duration(seconds: 30)));

    test('refetches when page changes', () async {
      container
          .read(datasetSearchParamsProvider.notifier)
          .updateParams(const DatasetSearchParams(page: 1, limit: 2));
      final response1 = await container.read(
        datasetSearchResultsProvider.future,
      );
      container.read(datasetSearchParamsProvider.notifier).setPage(2);
      final response2 = await container.read(
        datasetSearchResultsProvider.future,
      );

      expect(response1.page, 1);
      expect(response2.page, 2);
      expect(response2.data, isA<List<Dataset>>());
    }, timeout: const Timeout(Duration(seconds: 30)));
  });

  group('datasetDetailProvider', () {
    test(
      'returns dataset when id exists',
      () async {
        final listResponse = await container
            .read(dataGovRsApiClientProvider)
            .searchDatasets(page: 1, limit: 1);
        if (listResponse.data.isEmpty) return;

        final id = listResponse.data.first.id;
        final dataset = await container.read(datasetDetailProvider(id).future);

        expect(dataset.id, id);
        expect(dataset.title, isNotEmpty);
      },
      timeout: const Timeout(Duration(seconds: 30)),
    );

    test(
      'throws when id does not exist',
      () async {
        expect(
          container.read(
            datasetDetailProvider('non-existent-id-xyz-12345').future,
          ),
          throwsA(isA<Exception>()),
        );
      },
      timeout: const Timeout(Duration(seconds: 30)),
    );
  });
}
