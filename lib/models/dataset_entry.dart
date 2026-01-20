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
      id: csvLine[0],
      name: csvLine[1],
      description: csvLine[2],
      url: csvLine[3],
      format: csvLine[4],
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
