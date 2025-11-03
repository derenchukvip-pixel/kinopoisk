import 'package:flutter_modular/flutter_modular.dart';
import 'package:kinopoisk/pages/home_page.dart';

class AppModule extends Module {
  @override
  void routes(RouteManager r) {
    r.child('/', child: (_) => const HomePage());
  }
  }