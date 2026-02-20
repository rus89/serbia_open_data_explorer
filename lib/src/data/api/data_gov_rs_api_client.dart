// ABOUTME: HTTP client for data.gov.rs API. Implements search and get-by-id per API_DISCOVERY.md.
// ABOUTME: Used by dataset providers; base URL from config or constant.

import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/dataset.dart';

/// Client for data.gov.rs API (GET /api/1/datasets/ and GET /api/1/datasets/{id}/).
class DataGovRsApiClient {
  DataGovRsApiClient({required this.baseUrl});

  final String baseUrl;

  String get _base => baseUrl.endsWith('/') ? baseUrl : '$baseUrl/';

  /// Search/list datasets with optional query and filters. Pagination via [page] and [limit].
  Future<DatasetListResponse> searchDatasets({
    String? query,
    String? organization,
    String? license,
    String? frequency,
    String? format,
    int? page,
    int? limit,
  }) async {
    final params = <String, String>{};
    if (query != null && query.isNotEmpty) params['q'] = query;
    if (organization != null && organization.isNotEmpty) params['organization'] = organization;
    if (license != null && license.isNotEmpty) params['license'] = license;
    if (frequency != null && frequency.isNotEmpty) params['frequency'] = frequency;
    if (format != null && format.isNotEmpty) params['format'] = format;
    if (page != null) params['page'] = page.toString();
    if (limit != null) params['page_size'] = limit.toString();

    final uri = Uri.parse('${_base}datasets/').replace(queryParameters: params.isEmpty ? null : params);
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

  Exception _apiException(int statusCode, String body) {
    return Exception('API error $statusCode: ${body.length > 200 ? body.substring(0, 200) : body}');
  }
}
