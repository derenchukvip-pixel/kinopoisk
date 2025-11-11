class FilterOptions {
  final List<int> genreIds;
  final int? year;
  final double? minRating;
  final double? maxRating;
  final String? country;
  final String? language;
  final String? sortBy;

  FilterOptions({
    this.genreIds = const [],
    this.year,
    this.minRating,
    this.maxRating,
    this.country,
    this.language,
    this.sortBy,
  });

  static const _unset = Object();
  FilterOptions copyWith({
    List<int>? genreIds,
    int? year,
    double? minRating,
    double? maxRating,
    Object? country = _unset,
    Object? language = _unset,
    Object? sortBy = _unset,
  }) {
    return FilterOptions(
      genreIds: genreIds ?? this.genreIds,
      year: year ?? this.year,
      minRating: minRating ?? this.minRating,
      maxRating: maxRating ?? this.maxRating,
      country: country == _unset ? this.country : country as String?,
      language: language == _unset ? this.language : language as String?,
      sortBy: sortBy == _unset ? this.sortBy : sortBy as String?,
    );
  }
}
