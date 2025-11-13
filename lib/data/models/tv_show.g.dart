// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tv_show.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TVShow _$TVShowFromJson(Map<String, dynamic> json) => TVShow(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  overview: json['overview'] as String,
  posterPath: json['poster_path'] as String?,
  firstAirDate: json['first_air_date'] as String,
  voteAverage: (json['vote_average'] as num).toDouble(),
);

Map<String, dynamic> _$TVShowToJson(TVShow instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'overview': instance.overview,
  'poster_path': instance.posterPath,
  'first_air_date': instance.firstAirDate,
  'vote_average': instance.voteAverage,
};
