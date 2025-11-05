import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../core/storage/favorite_service.dart';

class FavoriteButton extends StatelessWidget {
  final int movieId;
  const FavoriteButton({Key? key, required this.movieId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final favoriteService = Modular.get<FavoriteService>();
    return AnimatedBuilder(
      animation: favoriteService,
      builder: (context, _) {
        final isFav = favoriteService.isFavorite(movieId);
        return ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: isFav ? Colors.redAccent : Colors.grey[300],
            foregroundColor: isFav ? Colors.white : Colors.black87,
            elevation: isFav ? 4 : 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          icon: Icon(isFav ? Icons.favorite : Icons.favorite_border),
          label: Text(isFav ? 'В избранном' : 'В избранное'),
          onPressed: () => favoriteService.toggleFavorite(movieId),
        );
      },
    );
  }
}