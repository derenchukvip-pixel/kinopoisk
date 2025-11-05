import 'package:flutter/material.dart';

class FavoriteService extends ChangeNotifier {
  final Set<int> _favoriteIds = {};

  bool isFavorite(int id) => _favoriteIds.contains(id);

  void toggleFavorite(int id) {
    if (_favoriteIds.contains(id)) {
      _favoriteIds.remove(id);
    } else {
      _favoriteIds.add(id);
    }
    notifyListeners();
  }

  List<int> get favorites => _favoriteIds.toList();
}
