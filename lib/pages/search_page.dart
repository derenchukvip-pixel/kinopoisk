import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/subjects.dart';
import 'bloc/search_bloc.dart';
import 'bloc/search_event.dart';
import 'bloc/search_state.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:kinopoisk/domain/usecases/get_movie_details_usecase.dart';
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

// ...existing code...
 enum SearchCategory { 
  
  
  movie(value: "Movie"), tv(value: "TV");
  final String value; 

    const SearchCategory({required this.value});
   }
// TODO: реализовать SearchBloc корректно. Заглушка для сборки:
class SearchBloc {
  SearchBloc();
}

// TODO: реализовать SearchItem корректно. Заглушка для сборки:
class SearchItem {
  final dynamic item;
  SearchItem(this.item);
}


// TODO: реализовать SeachItemWidget корректно. Заглушка для сборки:
class SeachItemWidget extends StatelessWidget {
  const SeachItemWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}


class _SearchPageState extends State<SearchPage> {
  FilterOptions _filterOptions = FilterOptions();
  List<Map<String, dynamic>> _genres = [];
  List<String> _countries = [];
  List<String> _languages = [];
  List<String> _sortOptions = [];
  bool _filtersLoading = true;
  late TextEditingController _controller;
  SearchCategory? _selectedCategory;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialQuery ?? '');
  _selectedCategory = SearchCategory.movie;
    _scrollController = ScrollController();
    // TODO: trigger search if initialQuery is not null

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

    // Удалён некорректный StreamBuilder

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
                            // Отправляем событие фильтрации в BLoC
                            bloc.add(SearchFilterChanged(_filterOptions));
                            // Сразу запускаем поиск с текущим запросом и фильтром
                            if (_controller.text.length > 1) {
                              bloc.add(SearchQueryChanged(_controller.text, _selectedCategory ?? 'Movie'));
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
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          decoration: const InputDecoration(
                            labelText: 'Search',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            if (value.length > 1) {
                              bloc.add(SearchQueryChanged(value, _selectedCategory ?? 'Movie'));
                            }
                          },
                          onSubmitted: (value) {
                            if (value.length > 1) {
                              bloc.add(SearchQueryChanged(value, _selectedCategory ?? 'Movie'));
                            }
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
                          if (_controller.text.length > 1) {
                            bloc.add(SearchQueryChanged(_controller.text, value ?? 'Movie'));
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: BlocBuilder<SearchBloc, SearchState>(
                      builder: (context, state) {
                        if (state is SearchInitial) {
                          return const Center(child: Text('Enter a search query'));
                        } else if (state is SearchLoading) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (state is SearchLoaded) {
                          if (state.results.isEmpty) {
                            return const Center(child: Text('No results found'));
                          }
                          // Infinite scroll
                          return NotificationListener<ScrollNotification>(
                            onNotification: (notification) {
                              if (notification is ScrollEndNotification &&
                                  _scrollController.position.extentAfter < 300 &&
                                  state.hasMore) {
                                bloc.add(SearchLoadMore());
                              }
                              return false;
                            },
                            child: ListView.builder(
                              controller: _scrollController,
                              itemCount: state.results.length,
                              itemBuilder: (context, index) {
                                final item = state.results[index];
                                if (item.runtimeType.toString() == 'Movie') {
                                  // Movie
                                  return ListTile(
                                    leading: item.posterPath != null
                                        ? Image.network(
                                            'https://image.tmdb.org/t/p/w92${item.posterPath}',
                                            width: 50,
                                            fit: BoxFit.cover,
                                          )
                                        : const Icon(Icons.movie),
                                    title: Text(item.title),
                                    subtitle: Text('Rating: ${item.voteAverage.toStringAsFixed(1)}'),
                                    onTap: () {
                                      showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                                        ),
                                        builder: (context) {
                                          return FutureBuilder(
                                            future: Modular.get<GetMovieDetailsUseCase>().movieRepository(item.id),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState == ConnectionState.waiting) {
                                                return const SizedBox(
                                                  height: 300,
                                                  child: Center(child: CircularProgressIndicator()),
                                                );
                                              }
                                              if (snapshot.hasError) {
                                                return Padding(
                                                  padding: const EdgeInsets.all(24),
                                                  child: Text('Error loading: ${snapshot.error}', style: TextStyle(color: Colors.red)),
                                                );
                                              }
                                              final details = snapshot.data;
                                              if (details == null) {
                                                return const Padding(
                                                  padding: EdgeInsets.all(24),
                                                  child: Text('No data available'),
                                                );
                                              }
                                              return Padding(
                                                padding: const EdgeInsets.all(24),
                                                child: SingleChildScrollView(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      if (details.posterPath != null)
                                                        Center(
                                                          child: ClipRRect(
                                                            borderRadius: BorderRadius.circular(16),
                                                            child: Image.network(
                                                              'https://image.tmdb.org/t/p/w300${details.posterPath}',
                                                              height: 220,
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        ),
                                                      const SizedBox(height: 16),
                                                      Text(details.title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                                                      const SizedBox(height: 8),
                                                      Row(
                                                        children: [
                                                          Icon(Icons.star, color: Colors.amber, size: 20),
                                                          const SizedBox(width: 4),
                                                          Text(details.voteAverage.toStringAsFixed(1)),
                                                          const SizedBox(width: 16),
                                                          Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                                                          const SizedBox(width: 4),
                                                          Text(details.releaseDate, style: const TextStyle(color: Colors.grey)),
                                                        ],
                                                      ),
                                                      const SizedBox(height: 12),
                                                      Text(details.overview, style: Theme.of(context).textTheme.bodyMedium),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        },
                                      );
                                    },
                                  );
                                } else if (item.runtimeType.toString() == 'TVShow') {
                                  // TV Show
                                  return ListTile(
                                    leading: item.posterPath != null
                                        ? Image.network(
                                            'https://image.tmdb.org/t/p/w92${item.posterPath}',
                                            width: 50,
                                            fit: BoxFit.cover,
                                          )
                                        : const Icon(Icons.tv),
                                    title: Text(item.name),
                                    subtitle: Text('Rating: ${item.voteAverage.toStringAsFixed(1)}'),
                                    // TODO: onTap: open TV show details
                                  );
                                } else if (item.runtimeType.toString() == 'Keyword') {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                    child: ActionChip(
                                      label: Text(item.name),
                                      onPressed: () {
                                        // New search by keyword
                                        bloc.add(SearchQueryChanged(item.name, 'Movie'));
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
