enum SearchCategory {
  movie,
  tv,
  keyword,
}

extension SearchCategoryExt on SearchCategory {
  String get name => toString().split('.').last;
  static SearchCategory fromString(String value) {
    switch (value.toLowerCase()) {
      case 'movie':
        return SearchCategory.movie;
      case 'tv':
        return SearchCategory.tv;
      case 'keyword':
        return SearchCategory.keyword;
      default:
        throw ArgumentError('Unknown category: $value');
    }
  }
}
