// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get sortPopularDesc => 'Сначала популярные';

  @override
  String get sortPopularAsc => 'Сначала непопулярные';

  @override
  String get sortReleaseDesc => 'Сначала новые';

  @override
  String get sortReleaseAsc => 'Сначала старые';

  @override
  String get sortRatingDesc => 'Высокий рейтинг';

  @override
  String get sortRatingAsc => 'Низкий рейтинг';

  @override
  String get movieIdNotFound => 'ID фильма не найден';

  @override
  String get appTitle => 'Кинопоиск';

  @override
  String get login => 'Войти';

  @override
  String get logout => 'Выйти';

  @override
  String get username => 'Имя пользователя';

  @override
  String get password => 'Пароль';

  @override
  String get loginError => 'Неверное имя пользователя или пароль.';

  @override
  String get profile => 'Профиль';

  @override
  String get search => 'Поиск';

  @override
  String get catalog => 'Каталог';

  @override
  String get filters => 'Фильтры';

  @override
  String get clearAll => 'Очистить всё';

  @override
  String get clear => 'Очистить';

  @override
  String get genres => 'Жанры';

  @override
  String get year => 'Год';

  @override
  String get rating => 'Рейтинг';

  @override
  String get country => 'Страна';

  @override
  String get language => 'Язык';

  @override
  String get sortBy => 'Сортировать по';

  @override
  String get notChosen => 'Не выбрано';

  @override
  String get apply => 'Применить';

  @override
  String get loading => 'Загрузка...';

  @override
  String get error => 'Ошибка';

  @override
  String get noData => 'Нет данных';

  @override
  String get errorLoadingKeywords => 'Ошибка загрузки ключевых слов';

  @override
  String get keywords => 'Ключевые слова:';

  @override
  String get noKeywordsFound => 'Ключевые слова не найдены';

  @override
  String get noMovies => 'Нет фильмов для отображения';

  @override
  String get nowPlaying => 'Сейчас в кино';

  @override
  String get popular => 'Популярные';

  @override
  String get topRated => 'Лучшие';

  @override
  String get upcoming => 'Скоро';
}
