// ABOUTME: Dataset detail screen: shows description, publisher, frequency, and resource download links.
// ABOUTME: Reads id from route; uses datasetDetailProvider(id). All UI text in Serbian.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/models/dataset.dart';
import '../data/providers/dataset_providers.dart';

/// Detail screen for a single dataset. Displays full description, publisher,
/// update frequency, and list of resources with download links.
class DatasetDetailScreen extends ConsumerWidget {
  const DatasetDetailScreen({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(datasetDetailProvider(id));

    return detailAsync.when(
      loading: () => const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Učitavanje...'),
          ],
        ),
      ),
      error: (err, stack) => Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.grey),
                const SizedBox(height: 16),
                Text(
                  'Nije moguće učitati skup podataka.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  err.toString(),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: () => ref.invalidate(datasetDetailProvider(id)),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Pokušaj ponovo'),
                ),
              ],
            ),
          ),
        ),
      ),
      data: (dataset) => _DatasetDetailContent(dataset: dataset),
    );
  }
}

class _DatasetDetailContent extends StatelessWidget {
  const _DatasetDetailContent({required this.dataset});

  final Dataset dataset;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(dataset.title, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 16),
          if (dataset.description != null &&
              dataset.description!.trim().isNotEmpty) ...[
            Text(
              dataset.description!.trim(),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
          ],
          if (dataset.publisherName != null) ...[
            _DetailRow(label: 'Izdavač', value: dataset.publisherName!),
            const SizedBox(height: 8),
          ],
          if (dataset.frequency != null && dataset.frequency!.isNotEmpty) ...[
            _DetailRow(
              label: 'Učestalost ažuriranja',
              value: dataset.frequency!,
            ),
            const SizedBox(height: 16),
          ],
          if (dataset.resources.isNotEmpty) ...[
            Text(
              'Resursi za preuzimanje',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            ...dataset.resources.map(
              (r) =>
                  _ResourceTile(title: r.title, format: r.format, url: r.url),
            ),
          ],
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 140,
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        Expanded(child: Text(value)),
      ],
    );
  }
}

class _ResourceTile extends StatelessWidget {
  const _ResourceTile({required this.title, required this.url, this.format});

  final String title;
  final String url;
  final String? format;

  Future<void> _openUrl(BuildContext context) async {
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (context.mounted && !launched) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nije moguće otvoriti link.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(title),
        subtitle: format != null && format!.isNotEmpty
            ? Text(format!.toUpperCase())
            : null,
        trailing: const Icon(Icons.download),
        onTap: () => _openUrl(context),
      ),
    );
  }
}
