import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  final String? initialQuery;
  final String? initialCategory;

  const SearchPage({Key? key, this.initialQuery, this.initialCategory}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late TextEditingController _controller;
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialQuery ?? '');
    _selectedCategory = widget.initialCategory ?? 'Movie';
    // TODO: trigger search if initialQuery is not null
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Поиск'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      labelText: 'Поиск',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (value) {
                      // TODO: trigger search
                    },
                  ),
                ),
                const SizedBox(width: 8),
                DropdownButton<String>(
                  value: _selectedCategory,
                  items: const [
                    DropdownMenuItem(value: 'Movie', child: Text('Movie')),
                    DropdownMenuItem(value: 'Tv', child: Text('Tv')),
                    DropdownMenuItem(value: 'Person', child: Text('Person')),
                    DropdownMenuItem(value: 'Collection', child: Text('Collection')),
                    DropdownMenuItem(value: 'Company', child: Text('Company')),
                    DropdownMenuItem(value: 'Keyword', child: Text('Keyword')),
                    DropdownMenuItem(value: 'Multi', child: Text('Multi')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            // TODO: Search results, infinite scroll, filters, etc.
            Expanded(
              child: Center(
                child: Text('Здесь будут результаты поиска'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
