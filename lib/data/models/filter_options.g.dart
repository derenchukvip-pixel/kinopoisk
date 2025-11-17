// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'filter_options.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FilterOptions _$FilterOptionsFromJson(Map<String, dynamic> json) =>
    FilterOptions(
      genreIds:
          (json['genreIds'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const [],
      year: (json['year'] as num?)?.toInt(),
      minRating: (json['minRating'] as num?)?.toDouble(),
      maxRating: (json['maxRating'] as num?)?.toDouble(),
      country: json['country'] as String?,
      language: json['language'] as String?,
      sortBy: json['sortBy'] as String?,
    );

Map<String, dynamic> _$FilterOptionsToJson(FilterOptions instance) =>
    <String, dynamic>{
      'genreIds': instance.genreIds,
      'year': instance.year,
      'minRating': instance.minRating,
      'maxRating': instance.maxRating,
      'country': instance.country,
      'language': instance.language,
      'sortBy': instance.sortBy,
    };
