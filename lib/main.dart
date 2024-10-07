import 'package:flutter/material.dart';
import 'views/home_page.dart';
import 'views/search_results_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

/// Classe principale de l'application
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Objets Trouvés SNCF',
      theme: _buildAppTheme(), // Utiliser une méthode séparée pour construire le thème
      initialRoute: '/',
      routes: _buildRoutes(), // Routes définies dans une méthode dédiée
    );
  }

  /// Fonction pour définir le thème de l'application
  ThemeData _buildAppTheme() {
    return ThemeData(
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
        bodyLarge: TextStyle(fontSize: 16.0, color: Colors.black87),
        bodyMedium: TextStyle(fontSize: 14.0, color: Colors.black54),
        labelLarge: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  /// Fonction pour définir les routes de l'application
  Map<String, WidgetBuilder> _buildRoutes() {
    return {
      '/': (context) => HomePage(),
      '/search_results': (context) => SearchResultsPage(),
    };
  }
}
