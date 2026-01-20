import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:serbia_open_data_explorer/models/dataset_entry.dart';

void main() {
  runApp(const OpenDataApp());
}

//---------------------------------------------------------
class OpenDataApp extends StatefulWidget {
  const OpenDataApp({super.key});

  @override
  State<OpenDataApp> createState() => _OpenDataAppState();
}

//---------------------------------------------------------
class _OpenDataAppState extends State<OpenDataApp> {
  bool isLoading = true;
  List<DatasetEntry> datasetEntries = [];

  @override
  void initState() {
    super.initState();
    _loadDatasets();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _loadDatasets() async {
    final String datasetString = await rootBundle.loadString(
      'assets/data/datasets/datasets.csv',
    );
    final List<List<dynamic>> csvResult = CsvToListConverter().convert(
      datasetString,
    );
    datasetEntries = csvResult
        .map((line) => DatasetEntry.fromCSV(line))
        .toList();
    setState(() {
      datasetEntries = datasetEntries;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(body: Center(child: Text('Serbia Open Data Explorer'))),
    );
  }
}
