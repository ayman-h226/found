// lib/views/home_page.dart

import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final TextEditingController gareController = TextEditingController();
  final TextEditingController trainNumberController = TextEditingController();
  final TextEditingController timeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Objets Trouvés SNCF'),
        actions: [
          IconButton(
            icon: Icon(Icons.login),
            onPressed: () {
              Navigator.pushNamed(context, '/login');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Logo et Bienvenue
            Center(
              child: Column(
                children: [
                  Center(
                      child: Image.asset('assets/images/SNCF.png',
                          width: 100, height: 100)),
                  SizedBox(height: 12),
                  Text(
                    'Bienvenue dans l\'application Objets Trouvés',
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            // Champs de recherche
            TextField(
              controller: gareController,
              decoration: InputDecoration(
                labelText: 'Gare de départ',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.location_on),
              ),
            ),
            SizedBox(height: 12),
            TextField(
              controller: trainNumberController,
              decoration: InputDecoration(
                labelText: 'Numéro de train',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.train),
              ),
            ),
            SizedBox(height: 12),
            TextField(
              controller: timeController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Heure de départ',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.access_time),
              ),
              onTap: () async {
                TimeOfDay? selectedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (selectedTime != null) {
                  timeController.text = selectedTime.format(context);
                }
              },
            ),
            SizedBox(height: 20),
            // Boutons de catégorie
            Text(
              'Catégories d\'objets',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 12),
            Wrap(
              spacing: 8.0, // Espacement horizontal entre les boutons
              runSpacing:
                  8.0, // Espacement vertical entre les lignes de boutons
              children: [
                _buildCategoryButton(context, Icons.phone_android, 'Téléphone'),
                _buildCategoryButton(context, Icons.backpack, 'Sac à dos'),
                _buildCategoryButton(
                    context, Icons.wallet_travel, 'Portefeuille'),
                _buildCategoryButton(context, Icons.laptop, 'Ordinateur'),
                _buildCategoryButton(context, Icons.headphones, 'Casque Audio'),
                _buildCategoryButton(context, Icons.watch, 'Montre'),
                // Ajoutez d'autres catégories selon les besoins
              ],
            ),
            Spacer(),
            // Bouton de recherche
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Appel de la fonction de recherche ici
                  _searchObjects();
                },
                child: Text('Rechercher'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Fonction pour construire chaque bouton de catégorie
  Widget _buildCategoryButton(
      BuildContext context, IconData icon, String label) {
    return ElevatedButton.icon(
      onPressed: () {
        // Logique de filtrage par catégorie ici
      },
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Theme.of(context).colorScheme.secondary,
        //onPrimary: Colors.white,
      ),
    );
  }

  // Exemple de fonction de recherche
  void _searchObjects() {
    // Logique pour déclencher la recherche en utilisant l'API de la SNCF
    // Utilisez les valeurs de gareController, trainNumberController, et timeController
  }
}
