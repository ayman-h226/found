// lib/views/custom_home_page.dart

import 'package:flutter/material.dart';

class CustomHomePage extends StatelessWidget {
  final String userName;
  final int foundItemsCount;

  CustomHomePage({
    required this.userName,
    required this.foundItemsCount,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Accueil personnalisé'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Bonjour $userName'),
            SizedBox(height: 20),
            Text('Nombre d\'objets trouvés : $foundItemsCount'),
          ],
        ),
      ),
    );
  }
}
