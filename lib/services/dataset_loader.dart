import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:serbia_open_data_explorer/models/dataset_entry.dart';

class DatasetLoader extends ChangeNotifier {
  bool isLoading = false;
  List<DatasetEntry> datasetEntries = [];

  //---------------------------------------------------------
  Future<void> loadDatasets() async {
    isLoading = true;
    notifyListeners();
    final String datasetString = await rootBundle.loadString(
      'assets/data/datasets/datasets.csv',
    );
    final List<List<dynamic>> csvResult = CsvToListConverter(
      fieldDelimiter: ';',
    ).convert(datasetString);
    datasetEntries = csvResult
        .skip(1)
        .where((line) => line.isNotEmpty)
        .map((line) => DatasetEntry.fromCSV(line))
        .toList();
    isLoading = false;
    notifyListeners();
  }

  //---------------------------------------------------------
  Set<String> get allOrganizations => datasetEntries
      .map((entry) => entry.organization)
      .where((organization) => organization.isNotEmpty)
      .toSet();
  //---------------------------------------------------------
  Set<String> get allResourceFormats => datasetEntries
      .expand((entry) => entry.resourceFormats)
      .where((format) => format.isNotEmpty)
      .toSet();
  //---------------------------------------------------------
  Set<String> get allTags => datasetEntries
      .expand((entry) => entry.tags.split(','))
      .map((tag) => tag.trim())
      .where((tag) => tag.isNotEmpty)
      .toSet();
  //---------------------------------------------------------
  Set<String> get allUpdateFrequencies => datasetEntries
      .map((entry) => entry.updateFrequency)
      .where((frequency) => frequency.isNotEmpty)
      .toSet();
}
