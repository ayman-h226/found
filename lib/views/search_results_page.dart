// lib/views/search_results_page.dart

import 'package:flutter/material.dart';

class SearchResultsPage extends StatelessWidget {
  final List<Map<String, dynamic>> searchResults;

  SearchResultsPage({required this.searchResults});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Résultats de Recherche'),
      ),
      body: searchResults.isEmpty
          ? Center(
              child: Text(
                'Aucun objet trouvé.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            )
          : ListView.builder(
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                final result = searchResults[index];
                return ListTile(
                  title: Text(result['name'] ?? 'Objet inconnu'),
                  subtitle: Text(
                      'Gare: ${result['station']}\nTrain: ${result['train_number']}'),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // Logique pour afficher les détails de l'objet si nécessaire
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Icon(Icons.arrow_back),
        tooltip: 'Retour',
      ),
    );
  }
}
