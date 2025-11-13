// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tv_show_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TVShowDetails _$TVShowDetailsFromJson(Map<String, dynamic> json) =>
    TVShowDetails(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      overview: json['overview'] as String,
      posterPath: json['poster_path'] as String?,
      firstAirDate: json['first_air_date'] as String,
      voteAverage: (json['vote_average'] as num).toDouble(),
      keywords: (json['keywords'] as List<dynamic>)
          .map((e) => Keyword.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TVShowDetailsToJson(TVShowDetails instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'overview': instance.overview,
      'poster_path': instance.posterPath,
      'first_air_date': instance.firstAirDate,
      'vote_average': instance.voteAverage,
      'keywords': instance.keywords,
    };

Keyword _$KeywordFromJson(Map<String, dynamic> json) =>
    Keyword(id: (json['id'] as num).toInt(), name: json['name'] as String);

Map<String, dynamic> _$KeywordToJson(Keyword instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
};
