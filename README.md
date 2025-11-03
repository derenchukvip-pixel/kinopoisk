# Kinopoisk Flutter App

Приложение для просмотра фильмов и сериалов с использованием API TMDB.

## Основные возможности
- Главная страница с категориями: Now Playing, Popular, Top Rated, Upcoming
- Переключение между фильмами и сериалами
- Поиск с фильтрами и бесконечной прокруткой
- Просмотр деталей фильма/сериала
- Добавление в избранное
- Профиль пользователя с аватаром и последним избранным фильмом
- BottomSheet для быстрых деталей
- Кэширование и быстрая загрузка данных
- Автоматическое обновление сессии

## Используемые технологии
- [Flutter Modular](https://pub.dev/packages/flutter_modular) — навигация и DI
- [Dio](https://pub.dev/packages/dio) — сетевые запросы
- [Hive](https://pub.dev/packages/hive), [flutter_secure_storage](https://pub.dev/packages/flutter_secure_storage), [shared_preferences](https://pub.dev/packages/shared_preferences) — локальное хранение
- [rxdart](https://pub.dev/packages/rxdart) — streams для Home
- [flutter_bloc](https://pub.dev/packages/flutter_bloc) — BLoC для поиска

## Архитектура
- Clean Architecture
- Разделение на data/domain/presentation
- Принципы DRY и SOLID

## Запуск проекта
1. Клонируйте репозиторий:
   ```sh
   git clone https://github.com/derenchukvip-pixel/kinopoisk.git
   ```
2. Перейдите в папку проекта:
   ```sh
   cd kinopoisk
   ```
3. Установите зависимости:
   ```sh
   flutter pub get
   ```
4. Запустите приложение:
   ```sh
   flutter run
   ```

## Ссылки
- [TMDB API Docs](https://developer.themoviedb.org/reference/movie-details)
- [UI Inspiration](https://dribbble.com/shots/18632188-Movie-App)

---

_Проект в разработке. Все пожелания и баги — в Issues._

