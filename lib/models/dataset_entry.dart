class DatasetEntry {
  final String id;
  final String name;
  final String description;
  final String url;
  final String format;

  //---------------------------------------------------------
  DatasetEntry({
    required this.id,
    required this.name,
    required this.description,
    required this.url,
    required this.format,
  });

  //---------------------------------------------------------
  factory DatasetEntry.fromCSV(List<dynamic> csvLine) {
    return DatasetEntry(
      id: csvLine[0]?.toString() ?? '',
      name: csvLine[1]?.toString() ?? '',
      description: csvLine[9]?.toString() ?? '',
      url: csvLine[4]?.toString() ?? '',
      format: csvLine[23]?.toString() ?? '',
    );
  }

  //---------------------------------------------------------
  Map<String, dynamic> toCSV() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'url': url,
      'format': format,
    };
  }

  //---------------------------------------------------------
  @override
  String toString() {
    return 'DatasetEntry(id: $id, name: $name, description: $description, url: $url, format: $format)';
  }
}
