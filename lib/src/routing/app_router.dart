// ABOUTME: GoRouter configuration with home and dataset detail routes.
// ABOUTME: Uses AppRoutes for paths; ShellRoute provides shared scaffold and app bar.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../data/models/filter_options.dart';
import '../data/providers/dataset_providers.dart';
import 'app_routes.dart';

/// Configures GoRouter with home (/) and dataset detail (/dataset/:id) routes.
GoRouter createAppRouter() {
  return GoRouter(
    initialLocation: AppRoutes.home,
    routes: [
      ShellRoute(
        builder: (context, state, child) => Scaffold(
          appBar: AppBar(title: const Text('Otvoreni podaci Srbije')),
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
              return _PlaceholderDetailScreen(id: id);
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
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              labelText: 'Pretraži skupove podataka',
              hintText: 'Unesite pojam za pretragu',
              border: OutlineInputBorder(),
            ),
            textInputAction: TextInputAction.search,
            onSubmitted: _onSearchSubmitted,
          ),
          const SizedBox(height: 12),
          _FilterSection(
            params: params,
            paramsNotifier: paramsNotifier,
            licensesAsync: licensesAsync,
            frequenciesAsync: frequenciesAsync,
            organizationsAsync: organizationsAsync,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Katalog'),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () =>
                        context.push(AppRoutes.datasetDetailPath('sample-id')),
                    child: const Text('Otvori primer skup podataka'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Filter dropdowns for organization, license, frequency, format.
class _FilterSection extends StatelessWidget {
  const _FilterSection({
    required this.params,
    required this.paramsNotifier,
    required this.licensesAsync,
    required this.frequenciesAsync,
    required this.organizationsAsync,
  });

  final DatasetSearchParams params;
  final DatasetSearchParamsNotifier paramsNotifier;
  final AsyncValue<List<LicenseOption>> licensesAsync;
  final AsyncValue<List<FrequencyOption>> frequenciesAsync;
  final AsyncValue<List<OrganizationOption>> organizationsAsync;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
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
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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

class _PlaceholderDetailScreen extends StatelessWidget {
  const _PlaceholderDetailScreen({required this.id});

  final String id;

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Skup podataka: $id'));
  }
}
