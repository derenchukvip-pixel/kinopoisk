import 'package:flutter/material.dart';
import 'package:kinopoisk/l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(16),
            ),
            child: TextField(
              controller: controller,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.search,
                hintStyle: const TextStyle(color: Colors.white54),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              ),
              onChanged: onQueryChanged,
              onSubmitted: onQueryChanged,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Theme(
            data: Theme.of(context).copyWith(
              canvasColor: Colors.grey[900],
              cardColor: Colors.grey[900],
              dialogBackgroundColor: Colors.grey[900],
            ),
            child: DropdownButton<SearchCategory>(
              dropdownColor: Colors.grey[900],
              value: selectedCategory,
              style: const TextStyle(color: Colors.white),
              underline: const SizedBox(),
              borderRadius: BorderRadius.circular(16),
              items: SearchCategory.values
                  .map((cat) => DropdownMenuItem(
                        value: cat,
                        child: Text(cat.name),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value != null) onCategoryChanged(value);
              },
            ),
          ),
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
                  return Card(
                    color: Colors.grey[900],
                    margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      leading: item.posterPath != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                'https://image.tmdb.org/t/p/w92${item.posterPath}',
                                width: 56,
                                height: 84,
                                fit: BoxFit.cover,
                              ),
                            )
                          : const Icon(Icons.movie, color: Colors.white, size: 56),
                      title: Text(item.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      subtitle: Text(
                        AppLocalizations.of(context)!.catalog + ': ${item.voteAverage.toStringAsFixed(1)}',
                        style: const TextStyle(color: Colors.white70),
                      ),
                      onTap: () {
                        Modular.to.pushNamed('/details', arguments: item.id);
                      },
                    ),
                  );
                } else if (item.runtimeType.toString() == 'TVShow') {
                  return Card(
                    color: Colors.grey[900],
                    margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      leading: item.posterPath != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                'https://image.tmdb.org/t/p/w92${item.posterPath}',
                                width: 56,
                                height: 84,
                                fit: BoxFit.cover,
                              ),
                            )
                          : const Icon(Icons.tv, color: Colors.white, size: 56),
                      title: Text(item.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      subtitle: Text(
                        AppLocalizations.of(context)!.catalog + ': ${item.voteAverage.toStringAsFixed(1)}',
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ),
                  );
                } else if (item.runtimeType.toString() == 'Keyword') {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    child: ActionChip(
                      label: Text(item.name),
                      backgroundColor: Colors.grey[900],
                      labelStyle: const TextStyle(color: Colors.white),
                      onPressed: () {
                        bloc.add(SearchQueryChanged(item.name, SearchCategory.movie));
                      },
                    ),
                  );
                } else {
                  return ListTile(title: Text(item.toString(), style: const TextStyle(color: Colors.white)));
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
