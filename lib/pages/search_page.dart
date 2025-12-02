import 'package:flutter/material.dart';
import 'package:kinopoisk/l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/subjects.dart';
import 'bloc/search_bloc.dart';
import 'package:kinopoisk/data/models/search_category.dart';
import 'package:kinopoisk/data/models/genre.dart';
import 'package:kinopoisk/data/models/sort_option.dart';
import 'bloc/search_event.dart';
import 'bloc/search_state.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'package:kinopoisk/data/models/filter_options.dart';
import 'filter_page.dart';
import 'package:kinopoisk/data/network/tmdb_api_service.dart';



class SearchPage extends StatefulWidget {
  final String? initialQuery;
  final String? initialCategory;

  const SearchPage({Key? key, this.initialQuery, this.initialCategory}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  FilterOptions _filterOptions = FilterOptions();
  List<Genre> _genres = [];
  List<String> _countries = [];
  List<String> _languages = [];
  List<SortOption> _sortOptions = [];
  bool _filtersLoading = true;
  late TextEditingController _controller;
  SearchCategory _selectedCategory = SearchCategory.movie;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialQuery ?? '');
    _selectedCategory = SearchCategory.movie;
    _scrollController = ScrollController();
    _loadFilterData();
  }

  Future<void> _loadFilterData() async {
    setState(() => _filtersLoading = true);
    final api = Modular.get<TmdbApiService>();
    _genres = await api.getGenres();
    _countries = await api.getCountries();
    _languages = await api.getLanguages();
    _sortOptions = api.getSortOptions();
    setState(() => _filtersLoading = false);
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SearchBloc(),
      child: Builder(
        builder: (context) {
          final bloc = BlocProvider.of<SearchBloc>(context);
          return Scaffold(
            appBar: AppBar(
              title: const Text('Search'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.filter_list),
                  onPressed: _filtersLoading
                      ? null
                      : () async {
                          final result = await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => FilterPage(
                                initialOptions: _filterOptions,
                                genres: _genres,
                                countries: _countries,
                                languages: _languages,
                                sortOptions: _sortOptions,
                                onApply: (options) {
                                  Navigator.of(context).pop(options);
                                },
                              ),
                            ),
                          );
                          if (result is FilterOptions) {
                            setState(() {
                              _filterOptions = result;
                            });
                            bloc.add(SearchFilterChanged(_filterOptions));
                            if (_controller.text.length > 1) {
                              bloc.add(SearchQueryChanged(_controller.text, _selectedCategory));
                            }
                          }
                        },
                ),
              ],
            ),
            body: _filtersLoading
                ? const Center(child: CircularProgressIndicator())
                : Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        SearchInputBar(
                          controller: _controller,
                          selectedCategory: _selectedCategory,
                          onCategoryChanged: (cat) {
                            setState(() => _selectedCategory = cat);
                            if (_controller.text.length > 1) {
                              bloc.add(SearchQueryChanged(_controller.text, cat));
                            }
                          },
                          onQueryChanged: (query) {
                            if (query.length > 1) {
                              bloc.add(SearchQueryChanged(query, _selectedCategory));
                            }
                          },
                        ),
                        const SizedBox(height: 16),
                        Expanded(
                          child: SearchResultsList(
                            scrollController: _scrollController,
                            bloc: bloc,
                          ),
                        ),
                      ],
                    ),
                  ),
          );
        },
      ),
    );
  }
}

class SearchInputBar extends StatelessWidget {
  final TextEditingController controller;
  final SearchCategory selectedCategory;
  final ValueChanged<SearchCategory> onCategoryChanged;
  final ValueChanged<String> onQueryChanged;

  const SearchInputBar({
    Key? key,
    required this.controller,
    required this.selectedCategory,
    required this.onCategoryChanged,
    required this.onQueryChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.search,
              border: const OutlineInputBorder(),
            ),
            onChanged: onQueryChanged,
            onSubmitted: onQueryChanged,
          ),
        ),
        const SizedBox(width: 8),
        DropdownButton<SearchCategory>(
          value: selectedCategory,
          items: SearchCategory.values
              .map((cat) => DropdownMenuItem(
                    value: cat,
                    child: Text(cat.name), // TODO: localize category names if needed
                  ))
              .toList(),
          onChanged: (value) {
            if (value != null) onCategoryChanged(value);
          },
        ),
      ],
    );
  }
}

class SearchResultsList extends StatelessWidget {
  final ScrollController scrollController;
  final SearchBloc bloc;

  const SearchResultsList({
    Key? key,
    required this.scrollController,
    required this.bloc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        if (state is SearchInitial) {
          return Center(child: Text(AppLocalizations.of(context)!.search + ': Enter a search query'));
        } else if (state is SearchLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is SearchLoaded) {
          if (state.results.isEmpty) {
            return Center(child: Text(AppLocalizations.of(context)!.search + ': No results found'));
          }
          return NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (notification is ScrollEndNotification &&
                  scrollController.position.extentAfter < 300 &&
                  state.hasMore) {
                bloc.add(SearchLoadMore());
              }
              return false;
            },
            child: ListView.builder(
              controller: scrollController,
              itemCount: state.results.length,
              itemBuilder: (context, index) {
                final item = state.results[index];
                if (item.runtimeType.toString() == 'Movie') {
                  return ListTile(
                    leading: item.posterPath != null
                        ? Image.network(
                            'https://image.tmdb.org/t/p/w92${item.posterPath}',
                            width: 50,
                            fit: BoxFit.cover,
                          )
                        : const Icon(Icons.movie),
                    title: Text(item.title),
                    subtitle: Text(AppLocalizations.of(context)!.catalog + ': ${item.voteAverage.toStringAsFixed(1)}'),
                    onTap: () {
                      // ...existing code for details...
                    },
                  );
                } else if (item.runtimeType.toString() == 'TVShow') {
                  return ListTile(
                    leading: item.posterPath != null
                        ? Image.network(
                            'https://image.tmdb.org/t/p/w92${item.posterPath}',
                            width: 50,
                            fit: BoxFit.cover,
                          )
                        : const Icon(Icons.tv),
                    title: Text(item.name),
                    subtitle: Text(AppLocalizations.of(context)!.catalog + ': ${item.voteAverage.toStringAsFixed(1)}'),
                  );
                } else if (item.runtimeType.toString() == 'Keyword') {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    child: ActionChip(
                      label: Text(item.name),
                      onPressed: () {
                        bloc.add(SearchQueryChanged(item.name, SearchCategory.movie));
                      },
                    ),
                  );
                } else {
                  return ListTile(title: Text(item.toString()));
                }
              },
            ),
          );
        } else if (state is SearchError) {
          return Center(child: Text('Error: ${state.message}'));
        }
        return const SizedBox();
      },
    );
  }
}
