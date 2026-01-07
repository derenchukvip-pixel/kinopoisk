
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:kinopoisk/l10n/app_localizations.dart';
import 'package:kinopoisk/data/models/movie.dart';
import 'package:kinopoisk/data/repositories/movie_repository.dart';
import 'package:kinopoisk/domain/usecases/get_now_playing_movies_usecase.dart';
import 'package:kinopoisk/domain/usecases/get_popular_movies_usecase.dart';
import 'package:kinopoisk/domain/usecases/get_top_rated_movies_usecase.dart';
import 'package:kinopoisk/domain/usecases/get_upcoming_movies_usecase.dart';
import 'package:kinopoisk/pages/search_page.dart';
import 'package:kinopoisk/features/auth/presentation/profile_page.dart';
import 'package:kinopoisk/core/config/localization_service.dart';

class HomePage extends StatefulWidget {
	const HomePage({Key? key}) : super(key: key);

	@override
	State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
	int _selectedIndex = 0;

	final List<Widget> _pages = [
		MainTab(),
		SearchPage(),
		ProfilePage(),
	];

	void _onItemTapped(int index) {
		setState(() {
			_selectedIndex = index;
		});
	}

	@override
	Widget build(BuildContext context) {
				final localization = LocalizationService();
				return Scaffold(
					backgroundColor: Colors.black,
					body: SafeArea(
						child: _pages[_selectedIndex],
					),
					bottomNavigationBar: BottomNavigationBar(
						currentIndex: _selectedIndex,
						onTap: _onItemTapped,
						backgroundColor: Colors.black,
						selectedItemColor: Colors.red,
						unselectedItemColor: Colors.white70,
						items: [
							BottomNavigationBarItem(
								icon: Icon(Icons.home),
								label: localization.getString(context, 'appTitle'),
							),
							BottomNavigationBarItem(
								icon: Icon(Icons.search),
								label: localization.getString(context, 'catalog'),
							),
							BottomNavigationBarItem(
								icon: Icon(Icons.person),
								label: localization.getString(context, 'profile'),
							),
						],
					),
				);
	}
}
// ...existing code...

class MainTab extends StatefulWidget {
	const MainTab({Key? key}) : super(key: key);

	@override
	State<MainTab> createState() => _MainTabState();
}

class _MainTabState extends State<MainTab> with SingleTickerProviderStateMixin {
	late TabController _tabController;
	final List<String> categories = [
		'now_playing',
		'popular',
		'top_rated',
		'upcoming',
	];

	@override
	void initState() {
		super.initState();
		_tabController = TabController(length: categories.length, vsync: this);
	}

	Future<List<Movie>> _loadMovies(String category) {
		final repo = Modular.get<MovieRepository>();
		switch (category) {
			case 'now_playing':
				final nowPlaying = Modular.get<GetNowPlayingMoviesUseCase>();
				return nowPlaying.movieRepository();
			case 'popular':
				final popularMovies = Modular.get<GetPopularMoviesUseCase>();
				return popularMovies.movieRepository();
			case 'top_rated':
				final topRated = Modular.get<GetTopRatedMoviesUseCase>();
				return topRated.movieRepository();
			case 'upcoming':
				final upcoming = Modular.get<GetUpcomingMoviesUseCase>();
				return upcoming.movieRepository();
			default:
				return repo.getNowPlaying();
		}
	}

	@override
	Widget build(BuildContext context) {
		return Column(
			children: [
				Container(
					color: Colors.transparent,
					child: SafeArea(
						child: Padding(
							padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
							child: Row(
								children: [
									Text(
										AppLocalizations.of(context)!.appTitle,
										style: Theme.of(context).textTheme.headlineMedium?.copyWith(
											fontWeight: FontWeight.bold,
											color: Colors.white,
										),
									),
								],
							),
						),
					),
				),
				Container(
					margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
					decoration: const BoxDecoration(
						color: Colors.transparent,
					),
					child: TabBar(
						controller: _tabController,
						indicator: UnderlineTabIndicator(
							borderSide: BorderSide(color: Colors.red, width: 4),
							insets: EdgeInsets.symmetric(horizontal: 16),
						),
						labelColor: Colors.white,
						unselectedLabelColor: Colors.white70,
						tabs: [
							Tab(text: AppLocalizations.of(context)?.nowPlaying ?? 'Now Playing'),
							Tab(text: AppLocalizations.of(context)?.popular ?? 'Popular'),
							Tab(text: AppLocalizations.of(context)?.topRated ?? 'Top Rated'),
							Tab(text: AppLocalizations.of(context)?.upcoming ?? 'Upcoming'),
						],
					),
				),
				Expanded(
					child: Stack(
						children: [
							TabBarView(
								controller: _tabController,
								children: categories.map((category) {
									return FutureBuilder<List<Movie>>(
										future: _loadMovies(category),
										builder: (context, snapshot) {
											if (snapshot.connectionState == ConnectionState.waiting) {
												return const Center(child: CircularProgressIndicator());
											}
											if (snapshot.hasError) {
												return Center(child: Text('Error: ${snapshot.error}'));
											}
											final movies = snapshot.data ?? [];
											return GridView.builder(
												padding: EdgeInsets.zero,
												gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
													crossAxisCount: 2,
													childAspectRatio: 0.65,
													crossAxisSpacing: 0,
													mainAxisSpacing: 0,
												),
												itemCount: movies.length,
												itemBuilder: (context, index) {
													final movie = movies[index];
													return GestureDetector(
														onTap: () {
															Modular.to.pushNamed('/details', arguments: movie.id);
														},
														child: AnimatedOpacity(
															opacity: 1.0,
															duration: Duration(milliseconds: 400 + index * 60),
															curve: Curves.easeOut,
															child: Container(
																margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
																padding: const EdgeInsets.all(0),
																decoration: BoxDecoration(
																	borderRadius: BorderRadius.circular(16),
																),
																child: Stack(
																	children: [
																		ClipRRect(
																			borderRadius: BorderRadius.circular(16),
																			child: Image.network(
																				'https://image.tmdb.org/t/p/w300${movie.posterPath}',
																				height: 170,
																				width: double.infinity,
																				fit: BoxFit.cover,
																				errorBuilder: (context, error, stackTrace) =>
																					Container(
																						color: Colors.grey[300],
																						height: 170,
																						child: const Center(child: Icon(Icons.broken_image, size: 32)),
																					),
																			),
																		),
																		Positioned(
																			left: 12,
																			right: 12,
																			bottom: 12,
																			child: Column(
																				crossAxisAlignment: CrossAxisAlignment.start,
																				children: [
																					Text(
																						movie.title,
																						maxLines: 2,
																						overflow: TextOverflow.ellipsis,
																						style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.white),
																					),
																					const SizedBox(height: 4),
																					Row(
																						children: [
																							Icon(Icons.star, color: Colors.amber, size: 15),
																							const SizedBox(width: 3),
																							Text(
																								movie.voteAverage.toStringAsFixed(1),
																								style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white),
																							),
																							const SizedBox(width: 10),
																							Icon(Icons.calendar_today, size: 13, color: Colors.grey),
																							const SizedBox(width: 3),
																							Text(
																								movie.releaseDate,
																								style: const TextStyle(fontSize: 12, color: Colors.grey),
																							),
																						],
																					),
																					const SizedBox(height: 6),
																					Text(
																						movie.overview,
																						maxLines: 2,
																						overflow: TextOverflow.ellipsis,
																						style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white70, fontSize: 12),
																					),
																				],
																			),
																		),
																	],
																),
															),
														),
													);
												},
											);
										},
									);
								}).toList(),
							),
							// Глобальное затемнение снизу экрана
							Positioned(
								left: 0,
								right: 0,
								bottom: 0,
								child: IgnorePointer(
									child: Container(
										height: 80,
										decoration: BoxDecoration(
											gradient: LinearGradient(
												begin: Alignment.topCenter,
												end: Alignment.bottomCenter,
												colors: [
													Colors.transparent,
													Colors.black.withOpacity(0.7),
												],
											),
										),
									),
								),
							),
						],
					),
				),
			],
		);
	}
}