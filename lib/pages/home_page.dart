import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../data/models/movie.dart';
import '../data/repositories/movie_repository.dart';
import '../widgets/movie_list_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    MainTab(),
    const CatalogTab(),
    const ProfileTab(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Главная',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Каталог',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Профиль',
          ),
        ],
      ),
    );
  }
}

class MainTab extends StatefulWidget {
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

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<List<Movie>> _loadMovies(String category) {
    final repo = Modular.get<MovieRepository>();
    switch (category) {
      case 'now_playing':
        return repo.getNowPlaying();
      case 'popular':
        return repo.getPopular();
      case 'top_rated':
        return repo.getTopRated();
      case 'upcoming':
        return repo.getUpcoming();
      default:
        return repo.getNowPlaying();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Now Playing'),
            Tab(text: 'Popular'),
            Tab(text: 'Top Rated'),
            Tab(text: 'Upcoming'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: categories.map((category) {
              return FutureBuilder<List<Movie>>(
                future: _loadMovies(category),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Ошибка: \\${snapshot.error}'));
                  }
                  final movies = snapshot.data ?? [];
                  return MovieListWidget(movies: movies);
                },
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class CatalogTab extends StatelessWidget {
  const CatalogTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Каталог и поиск'));
  }
}

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Профиль'));
  }
}