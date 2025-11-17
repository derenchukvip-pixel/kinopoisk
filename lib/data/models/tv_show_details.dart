import 'package:json_annotation/json_annotation.dart';

part 'tv_show_details.g.dart';

@JsonSerializable()
class TVShowDetails {
  final int id;
  final String name;
  final String overview;
  @JsonKey(name: 'poster_path')
  final String? posterPath;
  @JsonKey(name: 'first_air_date')
  final String firstAirDate;
  @JsonKey(name: 'vote_average')
  final double voteAverage;
  final List<Keyword> keywords;

  TVShowDetails({
    required this.id,
    required this.name,
    required this.overview,
    this.posterPath,
    required this.firstAirDate,
    required this.voteAverage,
    required this.keywords,
  });

  factory TVShowDetails.fromJson(Map<String, dynamic> json) => _$TVShowDetailsFromJson(json);
  Map<String, dynamic> toJson() => _$TVShowDetailsToJson(this);
}

@JsonSerializable()
class Keyword {
  final int id;
  final String name;

  Keyword({required this.id, required this.name});

  factory Keyword.fromJson(Map<String, dynamic> json) => _$KeywordFromJson(json);
  Map<String, dynamic> toJson() => _$KeywordToJson(this);
}
