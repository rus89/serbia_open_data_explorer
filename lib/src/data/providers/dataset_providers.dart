// ABOUTME: Riverpod providers for data.gov.rs API client and dataset search/detail.
// ABOUTME: Exposes dataGovRsApiClientProvider, datasetSearchResultsProvider, datasetSearchStateProvider, datasetDetailProvider.

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

  void resetFilters() {
    state = const DatasetSearchParams();
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

/// Accumulated list state for infinite scroll: items loaded so far, total count, pagination flags.
class DatasetSearchState {
  const DatasetSearchState({
    this.items = const [],
    this.total = 0,
    this.currentPage = 0,
    this.hasMore = false,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.error,
  });

  final List<Dataset> items;
  final int total;
  final int currentPage;
  final bool hasMore;
  final bool isLoading;
  final bool isLoadingMore;
  final Object? error;

  DatasetSearchState copyWith({
    List<Dataset>? items,
    int? total,
    int? currentPage,
    bool? hasMore,
    bool? isLoading,
    bool? isLoadingMore,
    Object? error,
  }) {
    return DatasetSearchState(
      items: items ?? this.items,
      total: total ?? this.total,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      error: error,
    );
  }
}

/// Holds accumulated dataset list for catalog; supports loadFirst (reset + page 1) and loadMore (append next page).
class DatasetSearchStateNotifier extends Notifier<DatasetSearchState> {
  @override
  DatasetSearchState build() => const DatasetSearchState();

  /// Loads first page with current search params and replaces list. Call when query/filters change or retry.
  Future<void> loadFirst() async {
    state = state.copyWith(
      isLoading: true,
      error: null,
      items: [],
      total: 0,
      currentPage: 0,
      hasMore: false,
    );
    final client = ref.read(dataGovRsApiClientProvider);
    final params = ref.read(datasetSearchParamsProvider);
    try {
      final response = await client.searchDatasets(
        query: params.query.isEmpty ? null : params.query,
        organization: params.organization,
        license: params.license,
        frequency: params.frequency,
        format: params.format,
        page: 1,
        limit: params.limit,
      );
      state = state.copyWith(
        items: response.data,
        total: response.total,
        currentPage: 1,
        hasMore: response.nextPage != null && response.nextPage!.isNotEmpty,
        isLoading: false,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e);
    }
  }

  /// Appends next page to list. No-op if no more pages or already loading more.
  Future<void> loadMore() async {
    if (!state.hasMore || state.isLoadingMore) return;
    state = state.copyWith(isLoadingMore: true, error: null);
    final client = ref.read(dataGovRsApiClientProvider);
    final params = ref.read(datasetSearchParamsProvider);
    final nextPage = state.currentPage + 1;
    try {
      final response = await client.searchDatasets(
        query: params.query.isEmpty ? null : params.query,
        organization: params.organization,
        license: params.license,
        frequency: params.frequency,
        format: params.format,
        page: nextPage,
        limit: params.limit,
      );
      final newItems = [...state.items, ...response.data];
      state = state.copyWith(
        items: newItems,
        currentPage: nextPage,
        hasMore: response.nextPage != null && response.nextPage!.isNotEmpty,
        isLoadingMore: false,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(isLoadingMore: false, error: e);
    }
  }
}

final datasetSearchStateProvider =
    NotifierProvider<DatasetSearchStateNotifier, DatasetSearchState>(
      DatasetSearchStateNotifier.new,
    );

final datasetDetailProvider = FutureProvider.family<Dataset, String>((ref, id) {
  final client = ref.watch(dataGovRsApiClientProvider);
  return client.getDatasetById(id);
});
