import 'package:flutter/material.dart';
import '../../data/models/movie.dart';
import 'package:kinopoisk/l10n/app_localizations.dart';

class MovieListWidget extends StatelessWidget {
  final List<Movie> movies;
  final void Function(Movie)? onTap;

  const MovieListWidget({
    Key? key,
    required this.movies,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (movies.isEmpty) {
      return Center(child: Text(AppLocalizations.of(context)!.noMovies));
    }
    return ListView.builder(
      itemCount: movies.length,
      itemBuilder: (context, index) {
        final movie = movies[index];
        return ListTile(
          leading: movie.posterPath != null
              ? Image.network(
                  'https://image.tmdb.org/t/p/w92${movie.posterPath}',
                  width: 50,
                  fit: BoxFit.cover,
                )
              : const Icon(Icons.movie),
          title: Text(movie.title),
          subtitle: Text(AppLocalizations.of(context)!.rating + ': ${movie.voteAverage.toStringAsFixed(1)}'),
          onTap: onTap != null ? () => onTap!(movie) : null,
        );
      },
    );
  }
}
