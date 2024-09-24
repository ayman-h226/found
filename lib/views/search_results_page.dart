// lib/views/search_results_page.dart

import 'package:flutter/material.dart';

class SearchResultsPage extends StatelessWidget {
  final List<dynamic> searchResults;

  SearchResultsPage({required this.searchResults});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Résultats de la recherche'),
      ),
      body: searchResults.isEmpty
          ? Center(
        child: Text('Aucun objet trouvé.'),
      )
          : ListView.builder(
        itemCount: searchResults.length,
        itemBuilder: (context, index) {
          final item = searchResults[index]['fields'];

          return ListTile(
            leading: Icon(Icons.find_in_page),
            title: Text(item['gc_obo_type_c'] ?? 'Type inconnu'),
            subtitle: Text(
              'Gare: ${item['gc_obo_gare_origine_r_name'] ?? 'Non précisé'}',
            ),
            trailing: Text(
              'Date: ${item['date'] ?? 'Inconnue'}',
              style: TextStyle(color: Colors.grey),
            ),
          );
        },
      ),
    );
  }
}
