class MovieDetails {
  final int id;
  final String title;
  final String overview;
  final String? posterPath;
  final String releaseDate;
  final double voteAverage;
  final List<Keyword> keywords;

  MovieDetails({
    required this.id,
    required this.title,
    required this.overview,
    this.posterPath,
    required this.releaseDate,
    required this.voteAverage,
    required this.keywords,
  });
}

class Keyword {
  final int id;
  final String name;

  Keyword({required this.id, required this.name});
}
