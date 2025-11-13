// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovieDetails _$MovieDetailsFromJson(Map<String, dynamic> json) => MovieDetails(
  id: (json['id'] as num).toInt(),
  title: json['title'] as String,
  overview: json['overview'] as String,
  posterPath: json['poster_path'] as String?,
  releaseDate: json['release_date'] as String,
  voteAverage: (json['vote_average'] as num).toDouble(),
  keywords: (json['keywords'] as List<dynamic>)
      .map((e) => Keyword.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$MovieDetailsToJson(MovieDetails instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'overview': instance.overview,
      'poster_path': instance.posterPath,
      'release_date': instance.releaseDate,
      'vote_average': instance.voteAverage,
      'keywords': instance.keywords,
    };

Keyword _$KeywordFromJson(Map<String, dynamic> json) =>
    Keyword(id: (json['id'] as num).toInt(), name: json['name'] as String);

Map<String, dynamic> _$KeywordToJson(Keyword instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
};
