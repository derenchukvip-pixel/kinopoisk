import 'package:equatable/equatable.dart';
import '../../data/models/search_category.dart';
import '../../data/models/filter_options.dart';
class SearchFilterChanged extends SearchEvent {
  final FilterOptions filterOptions;
  const SearchFilterChanged(this.filterOptions);

  @override
  List<Object?> get props => [filterOptions];
}

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object?> get props => [];
}


class SearchQueryChanged extends SearchEvent {
  final String query;
  final SearchCategory category;
  const SearchQueryChanged(this.query, this.category);

  @override
  List<Object?> get props => [query, category];
}

class SearchLoadMore extends SearchEvent {}

class SearchClear extends SearchEvent {}
