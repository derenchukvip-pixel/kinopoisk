class TVShow {
  final int id;
  final String name;
  final String overview;
  final String? posterPath;
  final String firstAirDate;
  final double voteAverage;

  TVShow({
    required this.id,
    required this.name,
    required this.overview,
    this.posterPath,
    required this.firstAirDate,
    required this.voteAverage,
  });

  factory TVShow.fromJson(Map<String, dynamic> json) => TVShow(
        id: json['id'],
        name: json['name'] ?? '',
        overview: json['overview'] ?? '',
        posterPath: json['poster_path'],
        firstAirDate: json['first_air_date'] ?? '',
        voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
      );
}
