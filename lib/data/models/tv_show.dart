import 'package:json_annotation/json_annotation.dart';

part 'tv_show.g.dart';

@JsonSerializable()
class TVShow {
  final int id;
  final String name;
  final String overview;
  @JsonKey(name: 'poster_path')
  final String? posterPath;
  @JsonKey(name: 'first_air_date')
  final String firstAirDate;
  @JsonKey(name: 'vote_average')
  final double voteAverage;

  TVShow({
    required this.id,
    required this.name,
    required this.overview,
    this.posterPath,
    required this.firstAirDate,
    required this.voteAverage,
  });

  factory TVShow.fromJson(Map<String, dynamic> json) => _$TVShowFromJson(json);
  Map<String, dynamic> toJson() => _$TVShowToJson(this);
}
