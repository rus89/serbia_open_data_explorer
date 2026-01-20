import 'dart:async';

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
  Widget build(BuildContext context) {
    return MaterialApp(home: HomePage());
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
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final datasetLoader = Provider.of<DatasetLoader>(context);
    final allEntries = datasetLoader.datasetEntries;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              labelText: 'Pretraga po nazivu ili opisu',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: DropdownButtonFormField<String>(
            initialValue: datasetLoader.allOrganizations.first,
            isExpanded: true,
            decoration: const InputDecoration(
              labelText: 'Organizacija',
              border: OutlineInputBorder(),
            ),
            items: datasetLoader.allOrganizations
                .map(
                  (organization) => DropdownMenuItem<String>(
                    value: organization,
                    child: Text(organization),
                  ),
                )
                .toList(),
            onChanged: (value) {
              setState(() {
                _selectedOrganization = value;
              });
            },
          ),
        ),
        Expanded(child: _searchResultsList(allEntries)),
      ],
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

      return matchesQuery && matchesOrganization;
    }).toList();

    if (filteredEntries.isEmpty) {
      return const Center(child: Text('Nema rezultata.'));
    }

    return ListView.builder(
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
          subtitle: RichText(
            text: TextSpan(
              style: const TextStyle(color: Colors.black, fontSize: 14),
              children: _highlightMatches(entry.description, query),
            ),
          ),
        );
      },
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
