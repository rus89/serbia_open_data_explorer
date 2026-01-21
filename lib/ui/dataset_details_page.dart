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

  //---------------------------------------------------------
  Widget _buildChipSection(IconData icon, String label, List<String> chips) {
    if (chips.isEmpty) return const SizedBox.shrink();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(icon),
                const SizedBox(width: 8.0),
                Text(
                  label,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Wrap(
              spacing: 6.0,
              runSpacing: 6.0,
              children: chips.map((chip) => Chip(label: Text(chip))).toList(),
            ),
          ],
        ),
      ),
    );
  }

  //---------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    // Use Theme.of(context).textTheme for consistent text styles
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: Text(datasetEntry.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Text(datasetEntry.description, style: textTheme.bodyMedium),
            _buildChipSection(
              Icons.tag,
              'Oznake',
              datasetEntry.tags
                  .split(',')
                  .map((tag) => tag.trim())
                  .where((tag) => tag.isNotEmpty)
                  .toList(),
            ),
            _buildChipSection(
              Icons.format_list_bulleted,
              'Formati',
              datasetEntry.resourceFormats.toList(),
            ),
            const SizedBox(height: 16.0),
            Card(
              child: ListTile(
                leading: const Icon(Icons.account_balance),
                title: Text('Organizacija', style: textTheme.bodyMedium),
                subtitle: Text(
                  datasetEntry.organization,
                  style: textTheme.bodyMedium,
                ),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.description),
                title: Text('Licenca', style: textTheme.bodyMedium),
                subtitle: Text(
                  datasetEntry.license,
                  style: textTheme.bodyMedium,
                ),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.update),
                title: Text(
                  'Frekvencija ažuriranja',
                  style: textTheme.bodyMedium,
                ),
                subtitle: Text(
                  datasetEntry.updateFrequency,
                  style: textTheme.bodyMedium,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openUrl(datasetEntry.url),
        icon: const Icon(Icons.open_in_new),
        label: const Text('Otvori'),
      ),
    );
  }
}
