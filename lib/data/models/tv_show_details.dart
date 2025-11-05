class TVShowDetails {
  final int id;
  final String name;
  final String overview;
  final String? posterPath;
  final String firstAirDate;
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
}

class Keyword {
  final int id;
  final String name;

  Keyword({required this.id, required this.name});
}
