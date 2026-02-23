// ABOUTME: Riverpod providers for data.gov.rs API client and dataset search/detail.
// ABOUTME: Exposes dataGovRsApiClientProvider, datasetSearchResultsProvider, datasetDetailProvider.

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/data_gov_rs_api_client.dart';
import '../models/dataset.dart';
import '../models/filter_options.dart';

const _defaultBaseUrl = 'https://data.gov.rs/api/1/';

/// Search parameters for dataset list (query, filters, pagination).
class DatasetSearchParams {
  const DatasetSearchParams({
    this.query = '',
    this.organization,
    this.license,
    this.frequency,
    this.format,
    this.page = 1,
    this.limit = 20,
  });

  final String query;
  final String? organization;
  final String? license;
  final String? frequency;
  final String? format;
  final int page;
  final int limit;

  DatasetSearchParams copyWith({
    String? query,
    String? organization,
    String? license,
    String? frequency,
    String? format,
    int? page,
    int? limit,
  }) {
    return DatasetSearchParams(
      query: query ?? this.query,
      organization: organization ?? this.organization,
      license: license ?? this.license,
      frequency: frequency ?? this.frequency,
      format: format ?? this.format,
      page: page ?? this.page,
      limit: limit ?? this.limit,
    );
  }
}

/// Holds current search params so [datasetSearchResultsProvider] can depend on them.
class DatasetSearchParamsNotifier extends Notifier<DatasetSearchParams> {
  @override
  DatasetSearchParams build() => const DatasetSearchParams();

  void updateParams(DatasetSearchParams params) {
    state = params;
  }

  void setQuery(String q) {
    state = state.copyWith(query: q, page: 1);
  }

  void setOrganization(String? id) {
    state = DatasetSearchParams(
      query: state.query,
      organization: id,
      license: state.license,
      frequency: state.frequency,
      format: state.format,
      page: 1,
      limit: state.limit,
    );
  }

  void setLicense(String? id) {
    state = DatasetSearchParams(
      query: state.query,
      organization: state.organization,
      license: id,
      frequency: state.frequency,
      format: state.format,
      page: 1,
      limit: state.limit,
    );
  }

  void setFrequency(String? id) {
    state = DatasetSearchParams(
      query: state.query,
      organization: state.organization,
      license: state.license,
      frequency: id,
      format: state.format,
      page: 1,
      limit: state.limit,
    );
  }

  void setFormat(String? value) {
    state = DatasetSearchParams(
      query: state.query,
      organization: state.organization,
      license: state.license,
      frequency: state.frequency,
      format: value,
      page: 1,
      limit: state.limit,
    );
  }

  void setPage(int page) {
    state = state.copyWith(page: page);
  }
}

final datasetSearchParamsProvider =
    NotifierProvider<DatasetSearchParamsNotifier, DatasetSearchParams>(
      DatasetSearchParamsNotifier.new,
    );

final dataGovRsApiClientProvider = Provider<DataGovRsApiClient>((ref) {
  return DataGovRsApiClient(baseUrl: _defaultBaseUrl);
});

final licensesProvider = FutureProvider<List<LicenseOption>>((ref) async {
  final client = ref.watch(dataGovRsApiClientProvider);
  return client.getLicenses();
});

final frequenciesProvider = FutureProvider<List<FrequencyOption>>((ref) async {
  final client = ref.watch(dataGovRsApiClientProvider);
  return client.getFrequencies();
});

final organizationsProvider = FutureProvider<List<OrganizationOption>>((
  ref,
) async {
  final client = ref.watch(dataGovRsApiClientProvider);
  return client.getOrganizations();
});

/// Format options for resource format filter (no API; fixed list per API_DISCOVERY.md).
const formatFilterOptions = [
  ('csv', 'CSV'),
  ('json', 'JSON'),
  ('xls', 'XLS'),
  ('xlsx', 'XLSX'),
  ('xml', 'XML'),
  ('pdf', 'PDF'),
];

final datasetSearchResultsProvider = FutureProvider<DatasetListResponse>((
  ref,
) async {
  final client = ref.watch(dataGovRsApiClientProvider);
  final params = ref.watch(datasetSearchParamsProvider);
  return client.searchDatasets(
    query: params.query.isEmpty ? null : params.query,
    organization: params.organization,
    license: params.license,
    frequency: params.frequency,
    format: params.format,
    page: params.page,
    limit: params.limit,
  );
});

final datasetDetailProvider = FutureProvider.family<Dataset, String>((ref, id) {
  final client = ref.watch(dataGovRsApiClientProvider);
  return client.getDatasetById(id);
});
