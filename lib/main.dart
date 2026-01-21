import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serbia_open_data_explorer/models/dataset_entry.dart';
import 'package:serbia_open_data_explorer/services/dataset_loader.dart';
import 'package:serbia_open_data_explorer/ui/dataset_details_page.dart';

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
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.greenAccent),
        useMaterial3: true,
      ),
      home: HomePage(),
    );
  }
}

//---------------------------------------------------------
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

//---------------------------------------------------------
class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final datasetLoader = Provider.of<DatasetLoader>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Serbia Open Data Explorer')),
      body: datasetLoader.isLoading
          ? const Center(child: CircularProgressIndicator())
          : const SearchWidget(),
    );
  }
}

//---------------------------------------------------------
class SearchWidget extends StatefulWidget {
  const SearchWidget({super.key});

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

//---------------------------------------------------------
class _SearchWidgetState extends State<SearchWidget> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  String? _selectedOrganization;
  String? _selectedFormat;
  String? _selectedTag;
  String? _selectedUpdateFrequency;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_debounceSearch);
  }

  @override
  void dispose() {
    _searchController.removeListener(_debounceSearch);
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _debounceSearch() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final datasetLoader = Provider.of<DatasetLoader>(context);
    final allEntries = datasetLoader.datasetEntries;
    final allOrganizations = datasetLoader.allOrganizations;
    final allResourceFormats = datasetLoader.allResourceFormats;
    final allTags = datasetLoader.allTags;
    final allUpdateFrequencies = datasetLoader.allUpdateFrequencies;

    return Column(
      children: [
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
            side: BorderSide(
              color: Theme.of(context).colorScheme.outlineVariant,
              width: 1.0,
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Filteri i pretraga',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.clear_all),
                    tooltip: 'Očisti filtere',
                    onPressed: () {
                      setState(() {
                        _selectedOrganization = null;
                        _selectedFormat = null;
                        _selectedTag = null;
                        _selectedUpdateFrequency = null;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: _searchController,
                          decoration: const InputDecoration(
                            icon: Icon(Icons.search_outlined),
                            labelText: 'Pretraga po nazivu ili opisu',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      _buildFilterDropdown(
                        label: 'Organizacija',
                        selectedValue: _selectedOrganization,
                        options: allOrganizations,
                        onChanged: (value) {
                          _selectedOrganization = value;
                        },
                      ),
                      _buildFilterDropdown(
                        label: 'Format resursa',
                        selectedValue: _selectedFormat,
                        options: allResourceFormats,
                        onChanged: (value) {
                          _selectedFormat = value;
                        },
                      ),
                      _buildFilterDropdown(
                        label: 'Oznaka (tag)',
                        selectedValue: _selectedTag,
                        options: allTags,
                        onChanged: (value) {
                          _selectedTag = value;
                        },
                      ),
                      _buildFilterDropdown(
                        label: 'Frekvencija ažuriranja',
                        selectedValue: _selectedUpdateFrequency,
                        options: allUpdateFrequencies,
                        onChanged: (value) {
                          _selectedUpdateFrequency = value;
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(child: _searchResultsList(allEntries)),
      ],
    );
  }

  //---------------------------------------------------------
  Widget _buildFilterDropdown({
    required String label,
    required String? selectedValue,
    required Set<String> options,
    required ValueChanged<String?> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButtonFormField<String>(
        initialValue: selectedValue,
        isExpanded: true,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        items: options
            .map(
              (option) =>
                  DropdownMenuItem<String>(value: option, child: Text(option)),
            )
            .toList(),
        onChanged: (value) {
          setState(() {
            onChanged(value);
          });
        },
      ),
    );
  }

  //---------------------------------------------------------
  Widget _searchResultsList(List<DatasetEntry> allEntries) {
    final query = _searchController.text.toLowerCase();
    final filteredEntries = allEntries.where((entry) {
      // search condition
      final matchesQuery = query.isEmpty
          ? true
          : entry.name.toLowerCase().contains(query) ||
                entry.description.toLowerCase().contains(query);

      // organization filter condition
      final matchesOrganization =
          _selectedOrganization == null ||
          _selectedOrganization!.isEmpty ||
          entry.organization == _selectedOrganization;

      // format filter condition
      final matchesFormat =
          _selectedFormat == null ||
          _selectedFormat!.isEmpty ||
          entry.resourceFormats.any(
            (format) => format.trim() == _selectedFormat!.trim(),
          );

      // tag filter condition
      final matchesTag =
          _selectedTag == null ||
          _selectedTag!.isEmpty ||
          entry.tags
              .split(',')
              .any((tag) => tag.trim() == _selectedTag!.trim());

      // update frequency filter condition
      final matchesUpdateFrequency =
          _selectedUpdateFrequency == null ||
          _selectedUpdateFrequency!.isEmpty ||
          entry.updateFrequency == _selectedUpdateFrequency;

      return matchesQuery &&
          matchesOrganization &&
          matchesFormat &&
          matchesTag &&
          matchesUpdateFrequency;
    }).toList();

    if (filteredEntries.isEmpty) {
      return const Center(child: Text('Nema rezultata.'));
    }

    return Column(
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Pronađeno rezultata: ${filteredEntries.length} / ${allEntries.length}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
        Expanded(
          child: ListView.builder(
            itemCount: filteredEntries.length,
            itemBuilder: (context, index) {
              final entry = filteredEntries[index];
              return ListTile(
                title: RichText(
                  text: TextSpan(
                    style: const TextStyle(color: Colors.black, fontSize: 18),
                    children: _highlightMatches(entry.name, query),
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          DatasetDetailsPage(datasetEntry: entry),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  //---------------------------------------------------------
  List<TextSpan> _highlightMatches(String source, String query) {
    if (query.isEmpty) {
      return [TextSpan(text: source)];
    }
    final matches = <TextSpan>[];
    final queryLower = query.toLowerCase();
    final sourceLower = source.toLowerCase();
    int start = 0;
    int index;
    while ((index = sourceLower.indexOf(queryLower, start)) != -1) {
      if (index > start) {
        matches.add(TextSpan(text: source.substring(start, index)));
      }
      matches.add(
        TextSpan(
          text: source.substring(index, index + query.length),
          style: const TextStyle(backgroundColor: Colors.yellow),
        ),
      );
      start = index + query.length;
    }
    if (start < source.length) {
      matches.add(TextSpan(text: source.substring(start)));
    }
    return matches;
  }
}
