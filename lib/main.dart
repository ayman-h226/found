import 'package:flutter/material.dart';
import 'views/home_page.dart';
import 'views/search_results_page.dart';

void main() {
  runApp(const MyApp());
}

/// Classe principale de l'application
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Objets Trouvés SNCF',
      theme: _appTheme, // Utiliser une constante pour le thème
      initialRoute: '/',
      routes: _routes, // Routes définies comme une constante
    );
  }

  /// Thème de l'application
  static final ThemeData _appTheme = ThemeData(
    colorScheme: ColorScheme.fromSwatch(
      primarySwatch: Colors.blue,
    ).copyWith(
      secondary: Colors.orange,
      surface: Colors.white,
      error: Colors.red,
    ),
    textTheme: TextTheme(
      displayLarge: TextStyle(
        fontSize: 24.0,
        fontWeight: FontWeight.bold,
        color: Colors.blue[900], // Bleu foncé
      ),
      titleLarge: TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.w600,
        color: Colors.blue[900], // Bleu foncé
      ),
      bodyLarge: const TextStyle(fontSize: 16.0, color: Colors.black87),
      bodyMedium: const TextStyle(fontSize: 14.0, color: Colors.black54),
      labelLarge: const TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
  );

  /// Définition des routes de l'application
  static final Map<String, WidgetBuilder> _routes = {
    '/': (context) =>  HomePage(),
    '/search_results': (context) =>  SearchResultsPage(),
  };
}
