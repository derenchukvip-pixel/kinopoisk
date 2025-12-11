import 'package:flutter/material.dart';
import 'package:kinopoisk/l10n/app_localizations.dart';

class LocalizationService {
  static final LocalizationService _instance = LocalizationService._internal();
  factory LocalizationService() {
    return _instance;
  }

  LocalizationService._internal();

  String getString(BuildContext context, String key) {
    final localizations = AppLocalizations.of(context);
    if (localizations == null) return key;
    final map = <String, String>{
      'sortPopularDesc': localizations.sortPopularDesc,
      'sortPopularAsc': localizations.sortPopularAsc,
      'sortReleaseDesc': localizations.sortReleaseDesc,
      'sortReleaseAsc': localizations.sortReleaseAsc,
      'sortRatingDesc': localizations.sortRatingDesc,
      'sortRatingAsc': localizations.sortRatingAsc,
      'movieIdNotFound': localizations.movieIdNotFound,
      'appTitle': localizations.appTitle,
      'login': localizations.login,
      'logout': localizations.logout,
      'username': localizations.username,
      'password': localizations.password,
      'loginError': localizations.loginError,
      'profile': localizations.profile,
      'search': localizations.search,
      'catalog': localizations.catalog,
      'filters': localizations.filters,
      'clearAll': localizations.clearAll,
      'clear': localizations.clear,
      'genres': localizations.genres,
      'year': localizations.year,
      'rating': localizations.rating,
      'country': localizations.country,
      'language': localizations.language,
      'sortBy': localizations.sortBy,
      'notChosen': localizations.notChosen,
      'apply': localizations.apply,
      'loading': localizations.loading,
      'error': localizations.error,
      'noData': localizations.noData,
      'errorLoadingKeywords': localizations.errorLoadingKeywords,
      'keywords': localizations.keywords,
      'noKeywordsFound': localizations.noKeywordsFound,
      'noMovies': localizations.noMovies,
      'nowPlaying': localizations.nowPlaying,
      'popular': localizations.popular,
      'topRated': localizations.topRated,
      'upcoming': localizations.upcoming,
    };
    return map[key] ?? key;
  }
}
