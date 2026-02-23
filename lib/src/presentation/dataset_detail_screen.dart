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

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return detailAsync.when(
      loading: () => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Učitavanje...',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
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
                Icon(Icons.error_outline, size: 56, color: colorScheme.error),
                const SizedBox(height: 20),
                Text(
                  'Nije moguće učitati skup podataka.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  err.toString(),
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: () => ref.invalidate(datasetDetailProvider(id)),
                  icon: const Icon(Icons.refresh, size: 20),
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
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            dataset.title,
            style: textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
            ),
          ),
          if (dataset.lastUpdate != null || dataset.lastModified != null) ...[
            const SizedBox(height: 6),
            Text(
              _formatLastUpdate(dataset.lastUpdate ?? dataset.lastModified),
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
          const SizedBox(height: 24),
          if (dataset.publisherName != null) ...[
            _DetailSection(
              title: 'Izdavač',
              child: Text(
                dataset.publisherName!,
                style: textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurface,
                ),
              ),
            ),
          ],
          if (dataset.description != null &&
              dataset.description!.trim().isNotEmpty) ...[
            _DetailSection(
              title: 'Opis',
              child: Text(
                dataset.description!.trim(),
                style: textTheme.bodyLarge?.copyWith(
                  height: 1.55,
                  color: colorScheme.onSurface,
                ),
              ),
            ),
          ],
          if (dataset.frequency != null && dataset.frequency!.isNotEmpty) ...[
            _DetailSection(
              title: 'Učestalost ažuriranja',
              child: Text(
                dataset.frequency!,
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
          if (dataset.resources.isNotEmpty) ...[
            Text(
              'Resursi za preuzimanje (${dataset.resources.length})',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            ...dataset.resources.map(
              (r) =>
                  _ResourceTile(title: r.title, format: r.format, url: r.url),
            ),
          ],
        ],
      ),
    );
  }

  static String _formatLastUpdate(String? raw) {
    if (raw == null || raw.isEmpty) return '';
    final parsed = DateTime.tryParse(raw);
    if (parsed == null) return 'Ažurirano: $raw';
    const months = [
      'januar',
      'februar',
      'mart',
      'april',
      'maj',
      'jun',
      'jul',
      'avgust',
      'septembar',
      'oktobar',
      'novembar',
      'decembar',
    ];
    final month = parsed.month >= 1 && parsed.month <= 12
        ? months[parsed.month - 1]
        : '${parsed.month}.';
    return 'Ažurirano ${parsed.day}. $month ${parsed.year}.';
  }
}

class _DetailSection extends StatelessWidget {
  const _DetailSection({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: 6),
          child,
        ],
      ),
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
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: () => _openUrl(context),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Icon(
                Icons.insert_drive_file_outlined,
                size: 28,
                color: colorScheme.primary,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    if (format != null && format!.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        format!.toUpperCase(),
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Icon(Icons.download, color: colorScheme.primary, size: 22),
            ],
          ),
        ),
      ),
    );
  }
}
