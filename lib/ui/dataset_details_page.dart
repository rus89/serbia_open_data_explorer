import 'package:flutter/material.dart';
import 'package:serbia_open_data_explorer/models/dataset_entry.dart';
import 'package:url_launcher/url_launcher.dart';

//---------------------------------------------------------
class DatasetDetailsPage extends StatelessWidget {
  final DatasetEntry datasetEntry;
  const DatasetDetailsPage({super.key, required this.datasetEntry});

  //---------------------------------------------------------
  Future<void> _openUrl(String url) async {
    if (url.isEmpty) return;
    final uri = Uri.tryParse(url);
    if (uri == null) {
      debugPrint('Invalid URL: $url');
      return;
    }

    final canLaunch = await canLaunchUrl(uri);
    debugPrint('canLaunchUrl($uri) = $canLaunch');

    if (!canLaunch) return;

    final launched = await launchUrl(
      uri,
      mode: LaunchMode.platformDefault, // or omit mode parameter entirely
    );
    debugPrint('launchUrl($uri) = $launched');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(datasetEntry.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Text(datasetEntry.description),
            Card(
              child: ListTile(
                leading: const Icon(Icons.link),
                title: const Text('Organizacija'),
                subtitle: Text(datasetEntry.organization),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.description),
                title: const Text('Licenca'),
                subtitle: Text(datasetEntry.license),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.tag),
                title: const Text('Oznake'),
                subtitle: Text(datasetEntry.tags),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.update),
                title: const Text('Frekvencija ažuriranja'),
                subtitle: Text(datasetEntry.updateFrequency),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.format_list_bulleted),
                title: const Text('Formati'),
                subtitle: Text(datasetEntry.resourceFormats.join(', ')),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openUrl(datasetEntry.url),
        child: const Icon(Icons.open_in_new),
      ),
    );
  }
}
