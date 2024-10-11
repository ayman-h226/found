import 'package:flutter/material.dart';

class SearchResultsPage extends StatelessWidget {
  // Dictionnaire des catégories d'objets et de leurs mots-clés
  final Map<String, List<String>> categoriesDictionary = {
    'Vêtements': ['vêtements', 'veste', 'chaussures', 'manteau', 'blouson', 'pantalon', 'robe', 'chemise', 'pull', 'gilet'],
    'Bagagerie': ['sac', 'valise', 'cartable', 'sac à dos', 'sacoche', 'bagages'],
    'Papeterie': ['livre', 'agenda', 'papeterie', 'cahier', 'stylo', 'bloc-notes', 'fournitures scolaires'],
    'Electronique': ['électronique', 'téléphone', 'ordinateur', 'tablette', 'smartphone', 'appareil photo', 'caméra'],
    'Clés': ['clé', 'badge', 'porte-clés'],
    'Bijoux': ['bijou', 'bracelet', 'collier', 'bague', 'pendentif', 'montre'],
    'Pièces': ['carte d\'identité', 'passeport', 'document officiel', 'permis', 'titre de séjour', 'papiers'],
    'Sport': ['sport', 'ballon', 'raquette', 'équipement sportif', 'vélo'],
    'Portefeuille': ['argent', 'portefeuille', 'porte-monnaie', 'carte de crédit', 'CB'],
    'Divers': ['parapluie', 'lunettes', 'accessoires', 'divers'],
  };

  @override
  Widget build(BuildContext context) {
    // Récupération des arguments passés à cette page
    final arguments = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final List<dynamic>? searchResults = arguments?['results'];
    final bool isApproximate = arguments?['isApproximate'] ?? false;

    return Scaffold(
      appBar: AppBar(
        title: Text('Résultats de la recherche'),
      ),
      body: Column(
        children: [
          if (isApproximate) _buildApproximateMessage(), // Affiche un message si les résultats sont approximatifs
          Expanded(
            child: searchResults == null || searchResults.isEmpty
                ? _buildNoResultsMessage(context) // Affiche un message s'il n'y a pas de résultats
                : _buildResultsList(searchResults), // Affiche la liste des résultats
          ),
        ],
      ),
    );
  }

  // Construit un message indiquant que les résultats sont approximatifs
  Widget _buildApproximateMessage() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        'Aucun objet trouvé à l\'heure exacte. Voici les objets trouvés autour de cette heure.',
        style: TextStyle(color: Colors.orange, fontSize: 16),
        textAlign: TextAlign.center,
      ),
    );
  }

  /// Construit la liste des résultats de recherche
  Widget _buildResultsList(List<dynamic> searchResults) {
    return ListView.builder(
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        final item = searchResults[index]['fields'];
        final String typeObjet = item['gc_obo_type_c']?.toString() ?? 'Type inconnu';
        final String gareOrigine = item['gc_obo_gare_origine_r_name']?.toString() ?? 'Non précisé';
        final String date = item['date']?.toString() ?? 'Inconnue';
        final String? iconPath = _getIconForCategory(typeObjet);

        return ListTile(
          leading: iconPath != null
              ? Image.asset(iconPath, width: 40, height: 40)
              : Icon(Icons.help_outline, size: 40), // Icône par défaut si aucune icône n'est trouvée
          title: Text(
            typeObjet,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text('Gare: $gareOrigine'),
          trailing: Text(
            'Date: $date',
            style: TextStyle(color: Colors.grey),
          ),
        );
      },
    );
  }

  /// Construit le message en cas d'absence de résultats
  Widget _buildNoResultsMessage(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final String stationName = arguments?['stationName'] ?? 'la gare sélectionnée';
    final String category = arguments?['category'] ?? 'le type d\'objet sélectionné';
    final String dateTime = arguments?['dateTime'] ?? 'la date et l\'heure sélectionnées';

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 80,
              color: Colors.grey,
            ),
            SizedBox(height: 20),
            Text(
              'Aucun objet de type "$category" trouvé pour la gare "$stationName" à l\'heure "$dateTime".',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 15),
            Text(
              'Essayez de rechercher avec des entrées différentes, ou consultez les objets récemment trouvés.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 25),
            ElevatedButton.icon(
              icon: Icon(Icons.replay),
              label: Text('Retourner à la recherche'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Obtient le chemin de l'icône correspondant à une catégorie d'objet
  String? _getIconForCategory(String category) {
    category = category.toLowerCase();
    for (final entry in categoriesDictionary.entries) {
      for (final keyword in entry.value) {
        if (category.contains(keyword.toLowerCase())) {
          String iconName = entry.key.toLowerCase().replaceAll(' ', '_');

          // Ajuster les noms des icônes pour correspondre aux assets
          switch (iconName) {
            case 'vêtements':
              iconName = 'vetements';
              break;
            case 'bagagerie':
              iconName = 'sacs';
              break;
            case 'papeterie':
              iconName = 'book';
              break;
            case 'electronique':
              iconName = 'electronique';
              break;
            case 'clés':
              iconName = 'cles';
              break;
            case 'bijoux':
              iconName = 'bijoux';
              break;
            case 'pièces':
              iconName = 'documents';
              break;
            case 'sport':
              iconName = 'sport';
              break;
            case 'portefeuille':
              iconName = 'portefeuille';
              break;
            case 'divers':
              iconName = 'divers';
              break;
            default:
              return null;
          }
          return 'assets/icons/$iconName.png';
        }
      }
    }
    return null; // Retourne null si aucune icône ne correspond à la catégorie
  }
}
