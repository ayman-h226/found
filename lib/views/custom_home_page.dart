import 'package:flutter/material.dart';

class CustomHomePage extends StatelessWidget {
  final String userName;
  final int foundItemsCount;

  CustomHomePage({required this.userName, required this.foundItemsCount});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bienvenue, $userName'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Vous avez trouvé $foundItemsCount objets depuis votre dernière connexion.',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Logique de recherche ici
              },
              child: Text('Rechercher des objets'),
            ),
          ],
        ),
      ),
    );
  }
}
