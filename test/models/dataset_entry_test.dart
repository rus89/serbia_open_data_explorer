import 'package:flutter_test/flutter_test.dart';
import 'package:serbia_open_data_explorer/models/dataset_entry.dart';

void main() {
  group('DatasetEntry.fromCSV', () {
    test('parses a valid CSV row correctly', () {
      final csvRow = [
        '123',
        'Test Dataset',
        '',
        '',
        'http://example.com/dataset',
        'Test Organization',
        '',
        '',
        '',
        'This is a test dataset.',
        'Monthly',
        'MIT License',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        'tag1, tag2, tag3',
        '',
        '',
        '',
        'CSV, JSON',
      ];

      final datasetEntry = DatasetEntry.fromCSV(csvRow);

      expect(datasetEntry.id, '123');
      expect(datasetEntry.name, 'Test Dataset');
      expect(datasetEntry.url, 'http://example.com/dataset');
      expect(datasetEntry.organization, 'Test Organization');
      expect(datasetEntry.description, 'This is a test dataset.');
      expect(datasetEntry.updateFrequency, 'Monthly');
      expect(datasetEntry.license, 'MIT License');
      expect(datasetEntry.tags, 'tag1, tag2, tag3');
      expect(datasetEntry.resourceFormats, {'CSV', 'JSON'});
    });

    test('handles missing optional fields gracefully', () {
      final csvRow = ['', '', '', '', ''];
      final datasetEntry = DatasetEntry.fromCSV(csvRow);

      expect(datasetEntry.id, '');
      expect(datasetEntry.name, '');
      expect(datasetEntry.url, '');
      expect(datasetEntry.organization, '');
      expect(datasetEntry.description, '');
      expect(datasetEntry.updateFrequency, '');
      expect(datasetEntry.license, '');
      expect(datasetEntry.tags, '');
      expect(datasetEntry.resourceFormats, <String>{});
    });
  });
}
