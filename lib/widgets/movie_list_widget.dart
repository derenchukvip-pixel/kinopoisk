import 'package:flutter/material.dart';
import '../../data/models/movie.dart';
import 'package:kinopoisk/l10n/app_localizations.dart';
import 'package:flutter_modular/flutter_modular.dart';

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
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () {
              Modular.to.pushNamed('/details', arguments: movie.id);
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                movie.posterPath != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: Stack(
                          children: [
                            Image.network(
                              'https://image.tmdb.org/t/p/w185${movie.posterPath}',
                              width: 95,
                              height: 140,
                              fit: BoxFit.cover,
                            ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                height: 36,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Colors.black.withOpacity(0.4),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : const Icon(Icons.movie, size: 95),
                const SizedBox(width: 28),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        movie.title,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        (AppLocalizations.of(context)?.rating ?? 'Rating') + ': ${movie.voteAverage.toStringAsFixed(1)}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
