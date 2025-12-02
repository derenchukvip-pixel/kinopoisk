import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:kinopoisk/l10n/app_localizations.dart';
import 'package:kinopoisk/data/models/movie_details.dart';
import 'package:kinopoisk/domain/usecases/get_movie_details_usecase.dart';
import 'package:kinopoisk/domain/usecases/get_keywords_usecase.dart';
import '_favorite_button.dart';

class MovieDetailsPage extends StatelessWidget {
  final int movieId;

  const MovieDetailsPage({Key? key, required this.movieId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final movieDetailsUseCase = Modular.get<GetMovieDetailsUseCase>();

    return FutureBuilder<MovieDetails>(
      future: movieDetailsUseCase.movieRepository(movieId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(title: Text(AppLocalizations.of(context)!.loading)),
            body: const Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(title: Text(AppLocalizations.of(context)!.error)),
            body: Center(child: Text(AppLocalizations.of(context)!.error + ': ${snapshot.error}')),
          );
        }
        final details = snapshot.data;
        if (details == null) {
          return Scaffold(
            appBar: AppBar(title: Text(AppLocalizations.of(context)!.noData)),
            body: const SizedBox(),
          );
        }
        return Scaffold(
          appBar: AppBar(
            title: Text(
              details.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Modular.to.pop(),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (details.posterPath != null)
                  Container(
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 12,
                          offset: Offset(0, 6),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        'https://image.tmdb.org/t/p/w500${details.posterPath}',
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 260,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: Colors.grey[300],
                          height: 260,
                          child: const Center(
                            child: Icon(Icons.broken_image, size: 64),
                          ),
                        ),
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 8.0,
                  ),
                  child: Text(
                    details.title,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 26,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 4.0,
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 22),
                      const SizedBox(width: 4),
                      Text(
                        details.voteAverage.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Icon(Icons.calendar_today, size: 18, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        details.releaseDate,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 12.0,
                  ),
                  child: Text(
                    details.overview,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(fontSize: 16),
                  ),
                ),
                // Кнопка избранного
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 8.0,
                  ),
                    child: FavoriteButton(movieId: details.id),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 8.0,
                  ),
                  child: FutureBuilder<List<Keyword>>(
                    future: Modular.get<GetKeywordsUseCase>().movieRepository(details.id),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Text(AppLocalizations.of(context)!.errorLoadingKeywords, style: const TextStyle(color: Colors.red));
                      }
                      final keywords = snapshot.data ?? [];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.keywords,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          keywords.isEmpty
                               ? Text(AppLocalizations.of(context)!.noKeywordsFound, style: const TextStyle(color: Colors.grey))
                              : Wrap(
                                  spacing: 8,
                                  children: keywords.map((k) => ActionChip(
                                    label: Text(k.name),
                                    onPressed: () {
                                      Modular.to.pushNamed('/search', arguments: {
                                        'initialQuery': k.name,
                                        'initialCategory': 'Keyword',
                                      });
                                    },
                                  )).toList(),
                                ),
                        ],
                      );
                    },
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
