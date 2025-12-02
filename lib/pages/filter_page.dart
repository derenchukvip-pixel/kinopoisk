import 'package:flutter/material.dart';
import 'package:kinopoisk/l10n/app_localizations.dart';
import '../data/models/filter_options.dart';
import '../data/models/genre.dart';
import '../data/models/sort_option.dart';

class FilterPage extends StatefulWidget {
  final FilterOptions initialOptions;
  final List<Genre> genres;
  final List<String> countries;
  final List<String> languages;
  final List<SortOption> sortOptions;
  final void Function(FilterOptions) onApply;

  const FilterPage({
    Key? key,
    required this.initialOptions,
    required this.genres,
    required this.countries,
    required this.languages,
    required this.sortOptions,
    required this.onApply,
  }) : super(key: key);

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  static const Map<String, String> sortLabels = {
    'popularity.desc': 'Popular first',
    'popularity.asc': 'Unpopular first',
    'release_date.desc': 'New first',
    'release_date.asc': 'Old first',
    'vote_average.desc': 'High rating',
    'vote_average.asc': 'Low rating',
  };
  late FilterOptions _options;
  late TextEditingController _yearController;

  @override
  void initState() {
    super.initState();
    _options = widget.initialOptions;
    _yearController = TextEditingController(text: _options.year?.toString() ?? '');
  }

  @override
  void dispose() {
    _yearController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
  title: Text(AppLocalizations.of(context)!.filters),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _options = FilterOptions();
                _yearController.clear();
              });
              widget.onApply(_options);
            },
            child: Text(AppLocalizations.of(context)!.clearAll, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(AppLocalizations.of(context)!.genres, style: Theme.of(context).textTheme.titleMedium),
              if (_options.genreIds.isNotEmpty)
                TextButton(
                  onPressed: () {
                    setState(() {
                      _options = _options.copyWith(genreIds: []);
                    });
                  },
                  child: Text(AppLocalizations.of(context)!.clear, style: const TextStyle(fontSize: 12)),
                ),
            ],
          ),
          Wrap(
            spacing: 8,
            children: widget.genres.map((genre) {
              final selected = _options.genreIds.contains(genre.id);
              return FilterChip(
                label: Text(genre.name),
                selected: selected,
                onSelected: (val) {
                  setState(() {
                    final ids = List<int>.from(_options.genreIds);
                    if (val) {
                      ids.add(genre.id);
                    } else {
                      ids.remove(genre.id);
                    }
                    _options = _options.copyWith(genreIds: ids);
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(AppLocalizations.of(context)!.year, style: Theme.of(context).textTheme.titleMedium),
              if (_options.year != null)
                TextButton(
                  onPressed: () {
                    setState(() {
                      _options = _options.copyWith(year: null);
                      _yearController.clear();
                    });
                  },
                  child: Text(AppLocalizations.of(context)!.clear, style: const TextStyle(fontSize: 12)),
                ),
            ],
          ),
          TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(hintText: AppLocalizations.of(context)!.year),
            controller: _yearController,
            maxLength: 4,
            onChanged: (val) {
              final onlyDigits = val.replaceAll(RegExp(r'[^0-9]'), '');
              if (val != onlyDigits) {
                _yearController.text = onlyDigits;
                _yearController.selection = TextSelection.fromPosition(TextPosition(offset: onlyDigits.length));
              }
              setState(() {
                _options = _options.copyWith(year: int.tryParse(onlyDigits));
              });
            },
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(AppLocalizations.of(context)!.rating, style: Theme.of(context).textTheme.titleMedium),
              if ((_options.minRating != null && _options.minRating != 0) || (_options.maxRating != null && _options.maxRating != 10))
                TextButton(
                  onPressed: () {
                    setState(() {
                      _options = _options.copyWith(minRating: 0, maxRating: 10);
                    });
                  },
                  child: Text(AppLocalizations.of(context)!.clear, style: const TextStyle(fontSize: 12)),
                ),
            ],
          ),
          RangeSlider(
            min: 0,
            max: 10,
            divisions: 20,
            values: RangeValues(_options.minRating ?? 0, _options.maxRating ?? 10),
            onChanged: (values) {
              setState(() {
                _options = _options.copyWith(minRating: values.start, maxRating: values.end);
              });
            },
            labels: RangeLabels(
              (_options.minRating ?? 0).toStringAsFixed(1),
              (_options.maxRating ?? 10).toStringAsFixed(1),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(AppLocalizations.of(context)!.country, style: Theme.of(context).textTheme.titleMedium),
              if (_options.country != null)
                TextButton(
                  onPressed: () {
                    setState(() {
                      _options = _options.copyWith(country: null);
                    });
                  },
                  child: Text(AppLocalizations.of(context)!.clear, style: const TextStyle(fontSize: 12)),
                ),
            ],
          ),
          DropdownButton<String?>(
            value: _options.country,
            isExpanded: true,
            items: [
              DropdownMenuItem<String?>(
                value: null,
                child: Text(AppLocalizations.of(context)!.notChosen, style: const TextStyle(color: Colors.grey)),
              ),
              ...widget.countries.map((c) => DropdownMenuItem<String?>(value: c, child: Text(c)))
            ],
            onChanged: (val) {
              setState(() {
                _options = _options.copyWith(country: val);
              });
            },
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(AppLocalizations.of(context)!.language, style: Theme.of(context).textTheme.titleMedium),
              if (_options.language != null)
                TextButton(
                  onPressed: () {
                    setState(() {
                      _options = _options.copyWith(language: null);
                    });
                  },
                  child: Text(AppLocalizations.of(context)!.clear, style: const TextStyle(fontSize: 12)),
                ),
            ],
          ),
          DropdownButton<String?>(
            value: _options.language,
            isExpanded: true,
            items: [
              DropdownMenuItem<String?>(
                value: null,
                child: Text(AppLocalizations.of(context)!.notChosen, style: const TextStyle(color: Colors.grey)),
              ),
              ...widget.languages.map((l) => DropdownMenuItem<String?>(value: l, child: Text(l)))
            ],
            onChanged: (val) {
              setState(() {
                _options = _options.copyWith(language: val);
              });
            },
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(AppLocalizations.of(context)!.sortBy, style: Theme.of(context).textTheme.titleMedium),
              if (_options.sortBy != null)
                TextButton(
                  onPressed: () {
                    setState(() {
                      _options = _options.copyWith(sortBy: null);
                    });
                  },
                  child: Text(AppLocalizations.of(context)!.clear, style: const TextStyle(fontSize: 12)),
                ),
            ],
          ),
          DropdownButton<String?>(
            value: _options.sortBy,
            isExpanded: true,
            items: [
              DropdownMenuItem<String?>(
                value: null,
                child: Text(AppLocalizations.of(context)!.notChosen, style: const TextStyle(color: Colors.grey)),
              ),
              ...widget.sortOptions
                  .map((s) => DropdownMenuItem<String?>(
                        value: s.apiValue,
                        child: Text(s.apiValue),
                      ))
            ],
            onChanged: (val) {
              setState(() {
                _options = _options.copyWith(sortBy: val);
              });
            },
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => widget.onApply(_options),
            child: Text(AppLocalizations.of(context)!.apply),
          ),
        ],
      ),
    );
  }
}
