// ABOUTME: Represents a single downloadable resource (file/link) of a dataset from data.gov.rs API.
// ABOUTME: Used in dataset.resources; provides url for url_launcher and format/title for display.

/// A resource (file or link) belonging to a dataset.
class DatasetResource {
  const DatasetResource({
    required this.id,
    required this.title,
    required this.url,
    this.format,
    this.mime,
    this.filetype,
    this.filesize,
    this.type,
    this.description,
    this.latest,
  });

  final String id;
  final String title;
  final String url;
  final String? format;
  final String? mime;
  final String? filetype;
  final int? filesize;
  final String? type;
  final String? description;
  final String? latest;

  static DatasetResource fromJson(Map<String, dynamic> json) {
    return DatasetResource(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      url: json['url'] as String? ?? '',
      format: json['format'] as String?,
      mime: json['mime'] as String?,
      filetype: json['filetype'] as String?,
      filesize: json['filesize'] as int?,
      type: json['type'] as String?,
      description: json['description'] as String?,
      latest: json['latest'] as String?,
    );
  }
}
