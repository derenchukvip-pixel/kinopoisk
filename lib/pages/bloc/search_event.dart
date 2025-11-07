import 'package:equatable/equatable.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object?> get props => [];
}

class SearchQueryChanged extends SearchEvent {
  final String query;
  final String category;
  const SearchQueryChanged(this.query, this.category);

  @override
  List<Object?> get props => [query, category];
}

class SearchLoadMore extends SearchEvent {}

class SearchClear extends SearchEvent {}
