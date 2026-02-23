// ABOUTME: Data models for data.gov.rs datasets (list item and detail). Matches API_DISCOVERY.md.
// ABOUTME: Parses from GET /api/1/datasets/ and GET /api/1/datasets/{id}/ responses.

import 'resource.dart';

/// Publisher/organization of a dataset (nested in dataset.organization).
class DatasetOrganization {
  const DatasetOrganization({
    required this.id,
    required this.name,
    this.slug,
    this.acronym,
    this.logo,
    this.logoThumbnail,
    this.page,
    this.uri,
  });

  final String id;
  final String name;
  final String? slug;
  final String? acronym;
  final String? logo;
  final String? logoThumbnail;
  final String? page;
  final String? uri;

  static DatasetOrganization? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;
    return DatasetOrganization(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      slug: json['slug'] as String?,
      acronym: json['acronym'] as String?,
      logo: json['logo'] as String?,
      logoThumbnail: json['logo_thumbnail'] as String?,
      page: json['page'] as String?,
      uri: json['uri'] as String?,
    );
  }
}

/// Optional temporal coverage (start/end dates) of a dataset.
class TemporalCoverage {
  const TemporalCoverage({this.start, this.end});

  final String? start;
  final String? end;

  static TemporalCoverage? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;
    return TemporalCoverage(
      start: json['start'] as String?,
      end: json['end'] as String?,
    );
  }
}

/// A dataset from data.gov.rs (list item and detail use the same shape).
class Dataset {
  const Dataset({
    required this.id,
    required this.title,
    this.description,
    this.slug,
    this.uri,
    this.page,
    this.organization,
    this.license,
    this.frequency,
    this.frequencyDate,
    this.lastModified,
    this.lastUpdate,
    this.resources = const [],
    this.temporalCoverage,
    this.tags = const [],
    this.private,
  });

  final String id;
  final String title;
  final String? description;
  final String? slug;
  final String? uri;
  final String? page;
  final DatasetOrganization? organization;
  final String? license;
  final String? frequency;
  final String? frequencyDate;
  final String? lastModified;
  final String? lastUpdate;
  final List<DatasetResource> resources;
  final TemporalCoverage? temporalCoverage;
  final List<String> tags;
  final bool? private;

  /// Publisher display name (from organization.name).
  String? get publisherName => organization?.name;

  static Dataset fromJson(Map<String, dynamic> json) {
    final resourcesJson = json['resources'] as List<dynamic>?;
    final tagsJson = json['tags'] as List<dynamic>?;
    return Dataset(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String?,
      slug: json['slug'] as String?,
      uri: json['uri'] as String?,
      page: json['page'] as String?,
      organization: DatasetOrganization.fromJson(
        json['organization'] as Map<String, dynamic>?,
      ),
      license: json['license'] as String?,
      frequency: json['frequency'] as String?,
      frequencyDate: json['frequency_date'] as String?,
      lastModified: json['last_modified'] as String?,
      lastUpdate: json['last_update'] as String?,
      resources:
          resourcesJson
              ?.map((e) => DatasetResource.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      temporalCoverage: TemporalCoverage.fromJson(
        json['temporal_coverage'] as Map<String, dynamic>?,
      ),
      tags: tagsJson?.map((e) => e as String).toList() ?? [],
      private: json['private'] as bool?,
    );
  }
}

/// Alias for dataset when used as full detail (same shape as list item).
typedef DatasetDetail = Dataset;

/// Paginated list response from GET /api/1/datasets/.
class DatasetListResponse {
  const DatasetListResponse({
    required this.data,
    required this.page,
    required this.pageSize,
    required this.total,
    this.nextPage,
    this.previousPage,
  });

  final List<Dataset> data;
  final int page;
  final int pageSize;
  final int total;
  final String? nextPage;
  final String? previousPage;

  static DatasetListResponse fromJson(Map<String, dynamic> json) {
    final dataJson = json['data'] as List<dynamic>?;
    return DatasetListResponse(
      data:
          dataJson
              ?.map((e) => Dataset.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      page: json['page'] as int? ?? 1,
      pageSize: json['page_size'] as int? ?? 20,
      total: json['total'] as int? ?? 0,
      nextPage: json['next_page'] as String?,
      previousPage: json['previous_page'] as String?,
    );
  }
}
