class DatasetEntry {
  final String id;
  final String name;
  final String description;
  final String url;
  final String tags;
  final String organization;
  final String license;
  final String updateFrequency;
  final Set<String> resourceFormats;

  //---------------------------------------------------------
  DatasetEntry({
    required this.id,
    required this.name,
    required this.description,
    required this.url,
    required this.tags,
    required this.organization,
    required this.license,
    required this.updateFrequency,
    required this.resourceFormats,
  });

  //---------------------------------------------------------
  factory DatasetEntry.fromCSV(List<dynamic> csvLine) {
    return DatasetEntry(
      id: csvLine[0]?.toString() ?? '',
      name: csvLine[1]?.toString() ?? '',
      url: csvLine[4]?.toString() ?? '',
      organization: csvLine[5]?.toString() ?? '',
      description: csvLine[9]?.toString() ?? '',
      updateFrequency: csvLine[10]?.toString() ?? '',
      license: csvLine[11]?.toString() ?? '',
      tags: csvLine[19]?.toString() ?? '',
      resourceFormats: (csvLine[23]?.toString().isNotEmpty ?? false)
          ? csvLine[23]
                .toString()
                .split(',')
                .map((e) => e.trim())
                .where((e) => e.isNotEmpty)
                .map((e) => e.toUpperCase())
                .toSet()
          : <String>{},
    );
  }

  //---------------------------------------------------------
  Map<String, dynamic> toCSV() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'url': url,
      'tags': tags,
      'organization': organization,
      'license': license,
      'updateFrequency': updateFrequency,
      'resourceFormats': resourceFormats.join(','),
    };
  }
}
