// ABOUTME: GoRouter configuration with home and dataset detail routes.
// ABOUTME: Uses AppRoutes for paths; ShellRoute provides shared scaffold and app bar.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../data/models/dataset.dart';
import '../data/models/filter_options.dart';
import '../data/providers/dataset_providers.dart';
import '../presentation/dataset_detail_screen.dart';
import 'app_routes.dart';

/// Configures GoRouter with home (/) and dataset detail (/dataset/:id) routes.
GoRouter createAppRouter() {
  return GoRouter(
    initialLocation: AppRoutes.home,
    routes: [
      ShellRoute(
        builder: (context, state, child) => Scaffold(
          appBar: AppBar(
            title: const Text('Otvoreni podaci Srbije'),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1),
              child: Container(
                height: 1,
                color: Theme.of(context).colorScheme.outlineVariant,
              ),
            ),
          ),
          body: child,
        ),
        routes: [
          GoRoute(
            path: AppRoutes.home,
            builder: (context, state) => const _HomeScreen(),
          ),
          GoRoute(
            path: AppRoutes.datasetDetail,
            builder: (context, state) {
              final id = state.pathParameters['id'] ?? '';
              return DatasetDetailScreen(id: id);
            },
          ),
        ],
      ),
    ],
  );
}

class _HomeScreen extends ConsumerStatefulWidget {
  const _HomeScreen();

  @override
  ConsumerState<_HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<_HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchSubmitted(String value) {
    ref.read(datasetSearchParamsProvider.notifier).setQuery(value.trim());
  }

  @override
  Widget build(BuildContext context) {
    final params = ref.watch(datasetSearchParamsProvider);
    final paramsNotifier = ref.read(datasetSearchParamsProvider.notifier);
    final licensesAsync = ref.watch(licensesProvider);
    final frequenciesAsync = ref.watch(frequenciesProvider);
    final organizationsAsync = ref.watch(organizationsProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Pretraži skupove podataka',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        paramsNotifier.setQuery('');
                      },
                    )
                  : null,
            ),
            textInputAction: TextInputAction.search,
            onSubmitted: _onSearchSubmitted,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 12),
          _FilterSection(
            params: params,
            paramsNotifier: paramsNotifier,
            licensesAsync: licensesAsync,
            frequenciesAsync: frequenciesAsync,
            organizationsAsync: organizationsAsync,
            onReset: () {
              _searchController.clear();
              paramsNotifier.resetFilters();
            },
          ),
          const SizedBox(height: 16),
          Expanded(child: _DatasetListView()),
        ],
      ),
    );
  }
}

/// Collapsible filter section: organization, license, frequency, format.
class _FilterSection extends StatelessWidget {
  const _FilterSection({
    required this.params,
    required this.paramsNotifier,
    required this.licensesAsync,
    required this.frequenciesAsync,
    required this.organizationsAsync,
    required this.onReset,
  });

  final DatasetSearchParams params;
  final DatasetSearchParamsNotifier paramsNotifier;
  final AsyncValue<List<LicenseOption>> licensesAsync;
  final AsyncValue<List<FrequencyOption>> frequenciesAsync;
  final AsyncValue<List<OrganizationOption>> organizationsAsync;
  final VoidCallback onReset;

  static bool _hasActiveFilters(DatasetSearchParams p) {
    return (p.organization != null && p.organization!.isNotEmpty) ||
        (p.license != null && p.license!.isNotEmpty) ||
        (p.frequency != null && p.frequency!.isNotEmpty) ||
        (p.format != null && p.format!.isNotEmpty);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasFilters = _hasActiveFilters(params);

    return Material(
      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
      borderRadius: BorderRadius.circular(12),
      child: ExpansionTile(
        leading: Icon(
          Icons.tune,
          size: 22,
          color: hasFilters
              ? theme.colorScheme.primary
              : theme.colorScheme.onSurfaceVariant,
        ),
        title: Text(
          'Filteri',
          style: theme.textTheme.titleSmall?.copyWith(
            color: theme.colorScheme.onSurface,
          ),
        ),
        trailing: hasFilters
            ? TextButton(onPressed: onReset, child: const Text('Reset'))
            : null,
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        children: [
          _FilterDropdown<String>(
            label: 'Organizacija',
            value: params.organization,
            allLabel: 'Sve organizacije',
            options: organizationsAsync.valueOrNull
                ?.map((o) => (o.id, o.name))
                .toList(),
            onChanged: paramsNotifier.setOrganization,
          ),
          const SizedBox(height: 8),
          _FilterDropdown<String>(
            label: 'Licenca',
            value: params.license,
            allLabel: 'Sve licence',
            options: licensesAsync.valueOrNull
                ?.map((l) => (l.id, l.title))
                .toList(),
            onChanged: paramsNotifier.setLicense,
          ),
          const SizedBox(height: 8),
          _FilterDropdown<String>(
            label: 'Učestalost',
            value: params.frequency,
            allLabel: 'Sve učestalosti',
            options: frequenciesAsync.valueOrNull
                ?.map((f) => (f.id, f.label))
                .toList(),
            onChanged: paramsNotifier.setFrequency,
          ),
          const SizedBox(height: 8),
          _FilterDropdown<String>(
            label: 'Format',
            value: params.format,
            allLabel: 'Svi formati',
            options: formatFilterOptions,
            onChanged: paramsNotifier.setFormat,
          ),
        ],
      ),
    );
  }
}

class _FilterDropdown<T> extends StatelessWidget {
  const _FilterDropdown({
    required this.label,
    required this.value,
    required this.allLabel,
    required this.options,
    required this.onChanged,
  });

  final String label;
  final T? value;
  final String allLabel;
  final List<(T, String)>? options;
  final void Function(T?) onChanged;

  @override
  Widget build(BuildContext context) {
    final effectiveOptions = options ?? [];
    final valueInOptions =
        value != null && effectiveOptions.any((o) => o.$1 == value);
    final items = <DropdownMenuItem<T>>[
      DropdownMenuItem<T>(value: null, child: Text(allLabel)),
      for (final opt in effectiveOptions)
        DropdownMenuItem<T>(value: opt.$1, child: Text(opt.$2)),
      if (value != null && !valueInOptions)
        DropdownMenuItem<T>(value: value, child: Text(value.toString())),
    ];
    return InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isExpanded: true,
          items: items,
          onChanged: (v) => onChanged(v),
        ),
      ),
    );
  }
}

String _totalCountLabel(int total) {
  if (total == 1) return 'Ukupno: 1 skup podataka';
  if (total >= 2 && total <= 4) return 'Ukupno: $total skupa podataka';
  return 'Ukupno: $total skupova podataka';
}

/// List view for search results: loading, error, empty, and success states.
class _DatasetListView extends ConsumerWidget {
  const _DatasetListView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue<DatasetListResponse>>(datasetSearchResultsProvider, (
      prev,
      next,
    ) {
      next.whenOrNull(
        error: (err, stack) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text(
                  'Nije moguće učitati skupove podataka. Pokušajte ponovo.',
                ),
                action: SnackBarAction(
                  label: 'Ponovo',
                  onPressed: () => ref.invalidate(datasetSearchResultsProvider),
                ),
              ),
            );
          }
        },
      );
    });

    final resultsAsync = ref.watch(datasetSearchResultsProvider);

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return resultsAsync.when(
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
                Icon(
                  Icons.cloud_off_outlined,
                  size: 56,
                  color: colorScheme.outline,
                ),
                const SizedBox(height: 20),
                Text(
                  'Nije moguće učitati skupove podataka.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleMedium?.copyWith(
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
                  onPressed: () => ref.invalidate(datasetSearchResultsProvider),
                  icon: const Icon(Icons.refresh, size: 20),
                  label: const Text('Pokušaj ponovo'),
                ),
              ],
            ),
          ),
        ),
      ),
      data: (response) {
        final totalLabel = _totalCountLabel(response.total);
        final content = response.data.isEmpty
            ? Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.search_off,
                        size: 56,
                        color: colorScheme.outline,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Nema pronađenih skupova podataka.',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: colorScheme.onSurface,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Promenite pretragu ili filtere.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.only(bottom: 24),
                itemCount: response.data.length,
                itemBuilder: (context, index) {
                  final dataset = response.data[index];
                  return _DatasetListTile(
                    dataset: dataset,
                    onTap: () =>
                        context.push(AppRoutes.datasetDetailPath(dataset.id)),
                  );
                },
              );
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                totalLabel,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            Expanded(child: content),
          ],
        );
      },
    );
  }
}

/// Resolves organization logo URL: relative paths get data.gov.rs origin.
String? _resolveLogoUrl(String? url) {
  if (url == null || url.trim().isEmpty) return null;
  final t = url.trim();
  if (t.startsWith('http://') || t.startsWith('https://')) return t;
  if (t.startsWith('/')) return 'https://data.gov.rs$t';
  return 'https://data.gov.rs/$t';
}

/// Single dataset row: title, description snippet, organization and format chips.
class _DatasetListTile extends StatelessWidget {
  const _DatasetListTile({required this.dataset, required this.onTap});

  final Dataset dataset;
  final VoidCallback onTap;

  static const int _descriptionMaxLines = 2;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final formats = dataset.resources
        .map((r) => r.format)
        .whereType<String>()
        .where((s) => s.isNotEmpty)
        .toSet()
        .take(5)
        .toList();
    final logoUrl = _resolveLogoUrl(
      dataset.organization?.logoThumbnail ?? dataset.organization?.logo,
    );

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _DatasetListTileIcon(logoUrl: logoUrl, colorScheme: colorScheme),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      dataset.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    if (dataset.description != null &&
                        dataset.description!.trim().isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        dataset.description!.trim(),
                        maxLines: _descriptionMaxLines,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          height: 1.35,
                        ),
                      ),
                    ],
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        if (dataset.organization != null)
                          _SmallChip(
                            label: dataset.organization!.name,
                            colorScheme: colorScheme,
                          ),
                        for (final format in formats)
                          _SmallChip(
                            label: format.toUpperCase(),
                            colorScheme: colorScheme,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: colorScheme.onSurfaceVariant,
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Shows organization logo from API when [logoUrl] is set; otherwise placeholder icon.
class _DatasetListTileIcon extends StatelessWidget {
  const _DatasetListTileIcon({
    required this.logoUrl,
    required this.colorScheme,
  });

  final String? logoUrl;
  final ColorScheme colorScheme;

  static const double _size = 44;

  Widget _placeholder() => Center(
    child: Icon(
      Icons.dataset_outlined,
      color: colorScheme.onPrimaryContainer,
      size: 24,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _size,
      height: _size,
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(10),
      ),
      clipBehavior: Clip.antiAlias,
      child: logoUrl != null
          ? Image.network(
              logoUrl!,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => _placeholder(),
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return _placeholder();
              },
            )
          : _placeholder(),
    );
  }
}

class _SmallChip extends StatelessWidget {
  const _SmallChip({required this.label, required this.colorScheme});

  final String label;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: colorScheme.outlineVariant, width: 1),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
