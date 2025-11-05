import 'package:flutter/material.dart';
import '../../data/models/movie.dart';

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
      return const Center(child: Text('Нет фильмов для отображения'));
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
          subtitle: Text('Рейтинг: ${movie.voteAverage.toStringAsFixed(1)}'),
          onTap: onTap != null ? () => onTap!(movie) : null,
        );
      },
    );
  }
}
