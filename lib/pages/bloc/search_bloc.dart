
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'search_event.dart';
import 'search_state.dart';
import '../../data/repositories/search_repository.dart';
import '../../data/models/filter_options.dart';
import '../../data/models/search_category.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchRepository searchRepository;

  FilterOptions? _currentFilter;


  SearchBloc({SearchRepository? repo})
      : searchRepository = repo ?? Modular.get<SearchRepository>(),
        super(SearchInitial()) {
    on<SearchQueryChanged>(_onQueryChanged);
    on<SearchLoadMore>(_onLoadMore);
    on<SearchClear>(_onClear);
    on<SearchFilterChanged>(_onFilterChanged);
  }
  String _lastQuery = '';
  SearchCategory _lastCategory = SearchCategory.movie;
  int _page = 1;
  bool _hasMore = true;
  List<dynamic> _results = [];

  Future<void> _onQueryChanged(SearchQueryChanged event, Emitter<SearchState> emit) async {
    emit(SearchLoading());
    _lastQuery = event.query;
    _lastCategory = event.category is SearchCategory
        ? event.category
        : SearchCategoryExt.fromString(event.category.toString());
    _page = 1;
    _hasMore = true;
    _results = [];
    try {
      List<dynamic> results = await _searchByCategory(_lastQuery, _lastCategory, _page, filter: _currentFilter);
      _results = results;
      _hasMore = results.length >= 20;
      emit(SearchLoaded(results: List.from(_results), hasMore: _hasMore));
    } catch (e) {
      emit(SearchError(e.toString()));
    }
  }

  Future<void> _onLoadMore(SearchLoadMore event, Emitter<SearchState> emit) async {
    if (!_hasMore || state is SearchLoading) return;
    try {
      _page++;
      List<dynamic> results = await _searchByCategory(_lastQuery, _lastCategory, _page, filter: _currentFilter);
      if (results.isEmpty) {
        _hasMore = false;
      } else {
        _results.addAll(results);
        _hasMore = results.length >= 20;
      }
      emit(SearchLoaded(results: List.from(_results), hasMore: _hasMore));
    } catch (e) {
      emit(SearchError(e.toString()));
    }
  }

  Future<List<dynamic>> _searchByCategory(String query, SearchCategory category, int page, {FilterOptions? filter}) async {
    switch (category) {
      case SearchCategory.movie:
        return await searchRepository.searchMovies(query, page: page, filters: filter);
      case SearchCategory.tv:
        return await searchRepository.searchTVShows(query, page: page);
      case SearchCategory.keyword:
        return await searchRepository.searchKeywords(query, page: page);
    }
  }

  void _onFilterChanged(SearchFilterChanged event, Emitter<SearchState> emit) {
    _currentFilter = event.filterOptions;
    // Не запускаем поиск автоматически, только сохраняем фильтр.
    // Поиск будет запущен вручную после применения фильтра.
  }
  }


  void _onClear(SearchClear event, Emitter<SearchState> emit) {
    emit(SearchInitial());
  }
