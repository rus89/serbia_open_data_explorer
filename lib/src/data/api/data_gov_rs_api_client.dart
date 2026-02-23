// ABOUTME: HTTP client for data.gov.rs API. Implements dataset search, get-by-id, and filter-option endpoints (licenses, frequencies, organizations) per API_DISCOVERY.md.
// ABOUTME: Used by dataset providers; base URL from config or constant.

import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/dataset.dart';
import '../models/filter_options.dart';

/// Client for data.gov.rs API (GET /api/1/datasets/ and GET /api/1/datasets/{id}/).
class DataGovRsApiClient {
  DataGovRsApiClient({required this.baseUrl});

  final String baseUrl;

  String get _base => baseUrl.endsWith('/') ? baseUrl : '$baseUrl/';

  /// Sort value matching the portal default (datasets by last update, newest first).
  static const String defaultSort = '-last_update';

  /// Search/list datasets with optional query and filters. Pagination via [page] and [limit].
  /// Uses [defaultSort] so order matches https://data.gov.rs/sr/datasets/.
  Future<DatasetListResponse> searchDatasets({
    String? query,
    String? organization,
    String? license,
    String? frequency,
    String? format,
    int? page,
    int? limit,
  }) async {
    final params = <String, String>{'sort': defaultSort};
    if (query != null && query.isNotEmpty) params['q'] = query;
    if (organization != null && organization.isNotEmpty) {
      params['organization'] = organization;
    }
    if (license != null && license.isNotEmpty) params['license'] = license;
    if (frequency != null && frequency.isNotEmpty) {
      params['frequency'] = frequency;
    }
    if (format != null && format.isNotEmpty) params['format'] = format;
    if (page != null) params['page'] = page.toString();
    if (limit != null) params['page_size'] = limit.toString();

    final uri = Uri.parse(
      '${_base}datasets/',
    ).replace(queryParameters: params.isEmpty ? null : params);
    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw _apiException(response.statusCode, response.body);
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return DatasetListResponse.fromJson(json);
  }

  /// Fetch a single dataset by id (or slug). Throws on HTTP error or not found.
  Future<Dataset> getDatasetById(String id) async {
    final uri = Uri.parse('${_base}datasets/$id/');
    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw _apiException(response.statusCode, response.body);
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return Dataset.fromJson(json);
  }

  /// Fetches license options for filter dropdown (GET /api/1/datasets/licenses/).
  Future<List<LicenseOption>> getLicenses() async {
    final uri = Uri.parse('${_base}datasets/licenses/');
    final response = await http.get(uri);
    if (response.statusCode != 200) {
      throw _apiException(response.statusCode, response.body);
    }
    final list = jsonDecode(response.body) as List<dynamic>;
    return list
        .map((e) => LicenseOption.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Fetches frequency options for filter dropdown (GET /api/1/datasets/frequencies/).
  Future<List<FrequencyOption>> getFrequencies() async {
    final uri = Uri.parse('${_base}datasets/frequencies/');
    final response = await http.get(uri);
    if (response.statusCode != 200) {
      throw _apiException(response.statusCode, response.body);
    }
    final list = jsonDecode(response.body) as List<dynamic>;
    return list
        .map((e) => FrequencyOption.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Fetches all organization options for filter dropdown (GET /api/1/organizations/).
  /// Paginates through all pages so the dropdown is never truncated when total > pageSize.
  Future<List<OrganizationOption>> getOrganizations({
    int pageSize = 200,
  }) async {
    final result = <OrganizationOption>[];
    int page = 1;
    int? total;

    do {
      final uri = Uri.parse('${_base}organizations/').replace(
        queryParameters: {
          'page': page.toString(),
          'page_size': pageSize.toString(),
        },
      );
      final response = await http.get(uri);
      if (response.statusCode != 200) {
        throw _apiException(response.statusCode, response.body);
      }
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      total ??= json['total'] as int?;
      final data = json['data'] as List<dynamic>?;
      if (data == null || data.isEmpty) break;
      for (final e in data) {
        result.add(OrganizationOption.fromJson(e as Map<String, dynamic>));
      }
      page++;
    } while (total != null && result.length < total);

    return result;
  }

  Exception _apiException(int statusCode, String body) {
    return Exception(
      'API error $statusCode: ${body.length > 200 ? body.substring(0, 200) : body}',
    );
  }
}
