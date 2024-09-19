// lib/main.dart

import 'package:flutter/material.dart';
import 'views/login_page.dart';
import 'views/signup_page.dart';
import 'views/logout_page.dart';
import 'views/home_page.dart';
import 'views/custom_home_page.dart';
import 'views/search_results_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Objets Trouvés SNCF',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors
              .grey, // Utilisez primarySwatch pour définir la couleur principale
        ).copyWith(
          secondary: Color(0xFFFF6600), // Utilisez secondary pour l'accentColor
          surface: Color(0xFFF5F5F5), // background pour backgroundColor
          error: Color(0xFFD32F2F), // error pour errorColor
        ),
        textTheme: TextTheme(
          displayLarge: TextStyle(
              // headline1 devient displayLarge
              fontSize: 25.0,
              fontWeight: FontWeight.bold,
              color: Color(0xFF003366)),
          titleLarge: TextStyle(
              // headline6 devient titleLarge
              fontSize: 18.0,
              fontWeight: FontWeight.w600,
              color: Color(0xFF003366)),
          bodyLarge: TextStyle(
              fontSize: 16.0,
              color: Colors.black87), // bodyText1 devient bodyLarge
          bodyMedium: TextStyle(
              fontSize: 14.0,
              color: Colors.black54), // bodyText2 devient bodyMedium
          labelLarge: TextStyle(
              // button utilise maintenant labelLarge
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Colors.white),
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: Color(0xFFFF6600), // Couleur des boutons
          textTheme: ButtonTextTheme.primary, // Texte des boutons
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignupPage(),
        '/logout': (context) => LogoutPage(),
        '/custom_home_page': (context) => CustomHomePage(
              userName: '',
              foundItemsCount: 5,
            ),
        '/search_results': (context) => SearchResultsPage(
              searchResults: [],
            ),
      },
    );
  }
}
