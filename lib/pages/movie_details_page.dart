import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../data/models/movie_details.dart';
import '../domain/usecases/get_movie_details_usecase.dart';
import '_favorite_button.dart';

class MovieDetailsPage extends StatelessWidget {
  final int movieId;

  const MovieDetailsPage({Key? key, required this.movieId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final useCase = Modular.get<GetMovieDetailsUseCase>();

    return FutureBuilder<MovieDetails>(
      future: useCase(movieId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(title: const Text('Загрузка...')),
            body: const Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(title: const Text('Ошибка')),
            body: Center(child: Text('Ошибка: ${snapshot.error}')),
          );
        }
        final details = snapshot.data;
        if (details == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Нет данных')),
            body: const SizedBox(),
          );
        }
        return Scaffold(
          appBar: AppBar(
            title: Text(details.title, maxLines: 2, overflow: TextOverflow.ellipsis),
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
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                  child: Text(
                    details.title,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 26,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 4.0),
                  child: Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 22),
                      const SizedBox(width: 4),
                      Text(
                        details.voteAverage.toStringAsFixed(1),
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(width: 16),
                      Icon(Icons.calendar_today, size: 18, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        details.releaseDate,
                        style: const TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                  child: Text(
                    details.overview,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 16),
                  ),
                ),
                // Кнопка избранного
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                  child: FavoriteButton(movieId: details.id),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
