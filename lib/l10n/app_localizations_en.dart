// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Kinopoisk';

  @override
  String get login => 'Login';

  @override
  String get logout => 'Logout';

  @override
  String get username => 'Username';

  @override
  String get password => 'Password';

  @override
  String get loginError => 'Invalid username or password.';

  @override
  String get profile => 'Profile';

  @override
  String get search => 'Search';

  @override
  String get catalog => 'Catalog';

  @override
  String get filters => 'Filters';

  @override
  String get clearAll => 'Clear all';

  @override
  String get clear => 'Clear';

  @override
  String get genres => 'Genres';

  @override
  String get year => 'Year';

  @override
  String get rating => 'Rating';

  @override
  String get country => 'Country';

  @override
  String get language => 'Language';

  @override
  String get sortBy => 'Sort by';

  @override
  String get notChosen => 'Not chosen';

  @override
  String get apply => 'Apply';

  @override
  String get loading => 'Loading...';

  @override
  String get error => 'Error';

  @override
  String get noData => 'No Data';

  @override
  String get errorLoadingKeywords => 'Error loading keywords';

  @override
  String get keywords => 'Keywords:';

  @override
  String get noKeywordsFound => 'No keywords found';

  @override
  String get noMovies => 'No movies to display';

  @override
  String get nowPlaying => 'Now Playing';

  @override
  String get popular => 'Popular';

  @override
  String get topRated => 'Top Rated';

  @override
  String get upcoming => 'Upcoming';
}
