class Movie {
  final int id;
  final String title;
  final String overview;
  final String? posterPath;
  final String releaseDate;
  final double voteAverage;

  Movie({
    required this.id,
    required this.title,
    required this.overview,
    this.posterPath,
    required this.releaseDate,
    required this.voteAverage,
  });

  factory Movie.fromJson(Map<String, dynamic> json) => Movie(
        id: json['id'],
        title: json['title'] ?? '',
        overview: json['overview'] ?? '',
        posterPath: json['poster_path'],
        releaseDate: json['release_date'] ?? '',
        voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
      );
}
