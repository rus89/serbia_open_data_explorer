import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serbia_open_data_explorer/models/dataset_entry.dart';
import 'package:serbia_open_data_explorer/services/dataset_loader.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => DatasetLoader()..loadDatasets(),
      child: const OpenDataApp(),
    ),
  );
}

//---------------------------------------------------------
class OpenDataApp extends StatefulWidget {
  const OpenDataApp({super.key});

  @override
  State<OpenDataApp> createState() => _OpenDataAppState();
}

//---------------------------------------------------------
class _OpenDataAppState extends State<OpenDataApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final datasetLoader = Provider.of<DatasetLoader>(context);
    return MaterialApp(
      home: Scaffold(
        body: datasetLoader.isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: datasetLoader.datasetEntries.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(datasetLoader.datasetEntries[index].name),
                    subtitle: Text(
                      datasetLoader.datasetEntries[index].description,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DatasetDetailPage(
                            dataset: datasetLoader.datasetEntries[index],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
      ),
    );
  }
}

class DatasetDetailPage extends StatelessWidget {
  final DatasetEntry dataset;
  const DatasetDetailPage({super.key, required this.dataset});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text(dataset.name)));
  }
}
