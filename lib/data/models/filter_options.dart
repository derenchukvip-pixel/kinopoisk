import 'package:json_annotation/json_annotation.dart';

part 'filter_options.g.dart';

@JsonSerializable()
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

  FilterOptions copyWith({
    List<int>? genreIds,
    int? year,
    double? minRating,
    double? maxRating,
    String? country,
    String? language,
    String? sortBy,
  }) {
    return FilterOptions(
      genreIds: genreIds ?? this.genreIds,
      year: year ?? this.year,
      minRating: minRating ?? this.minRating,
      maxRating: maxRating ?? this.maxRating,
      country: country ?? this.country,
      language: language ?? this.language,
      sortBy: sortBy ?? this.sortBy,
    );
  }

  bool get isDefault =>
      genreIds.isEmpty &&
      year == null &&
      minRating == null &&
      maxRating == null &&
      country == null &&
      language == null &&
      sortBy == null;

  factory FilterOptions.fromJson(Map<String, dynamic> json) => _$FilterOptionsFromJson(json);
  Map<String, dynamic> toJson() => _$FilterOptionsToJson(this);
}
