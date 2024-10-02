import 'package:flutter/material.dart';

class SearchResultsPage extends StatelessWidget {
  final Map<String, List<String>> categoriesDictionary = {
    'Portefeuille': ['Portefeuille', 'Porte-monnaie', 'argent', 'titres', 'carte bancaire', 'CB', 'portefeuille'],
    'Documents': ['Documents', 'Papiers', 'Identité', 'permis', 'pièce', 'calendrier', 'agenda', 'livre'],
    'Sacs': ['Sac', 'bagages', 'valises', 'cartables', 'sacoche', 'sac à dos', 'bandoulière', 'valise'],
    'Electronique': ['Electronique', 'téléphone', 'portable', 'ordinateur', 'caméscope', 'appareil', 'photo', 'vidéo', 'câble'],
    'Affaires d\'enfants': ['Affaires d\'enfants', 'doudou', 'peluche', 'jouet', 'trousse', 'enfant', 'biberon', 'dossier', 'scolaire'],
    'Bijoux': ['Bijoux', 'montres', 'bracelet', 'collier', 'bague', 'pendentif', 'bijou', 'gourmette', 'montre'],
    'Vêtements': ['Vêtements', 'chaussures', 'manteau', 'veste', 'blouson', 'cape', 'chapeau', 'gants', 'écharpe', 'pull'],
    'Clés': ['Clés', 'badge', 'porte-clés', 'magnétique', 'clé', 'badge magnétique', 'carte d\'accès', 'porte-clefs'],
    'Sport': ['Sport', 'ballon', 'raquette', 'tennis', 'vélos', 'trottinettes', 'rollers', 'casque', 'sportif'],
    'Divers': ['Divers', 'parapluie', 'lunettes', 'sacoche', 'autre', 'divers', 'inconnu', 'non précisé'],
  };

  @override
  Widget build(BuildContext context) {
    // Récupération des résultats passés via les arguments
    final arguments = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final List<dynamic>? searchResults = arguments?['results'];

    print('Résultats reçus dans SearchResultsPage: $searchResults');

    return Scaffold(
      appBar: AppBar(
        title: Text('Résultats de la recherche'),
      ),
      body: searchResults == null || searchResults.isEmpty
          ? _buildNoResultsMessage(context) // Afficher un message en cas d'absence de résultats
          : _buildResultsList(searchResults), // Afficher la liste des résultats
    );
  }

  // Fonction pour construire l'affichage de la liste des résultats
  Widget _buildResultsList(List<dynamic> searchResults) {
    return ListView.builder(
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        final item = searchResults[index]['fields'];

        final typeObjet = item['gc_obo_type_c']?.toString() ?? 'Type inconnu';
        final gareOrigine = item['gc_obo_gare_origine_r_name']?.toString() ?? 'Non précisé';
        final date = item['date']?.toString() ?? 'Inconnue';
        final iconPath = _getIconForCategory(typeObjet);

        return ListTile(
          leading: iconPath != null
              ? Image.asset(iconPath, width: 40, height: 40)
              : Icon(Icons.help_outline, size: 40), // Icône générique si pas d'image
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

  // Fonction pour construire le message en cas d'absence de résultats
  Widget _buildNoResultsMessage(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final stationName = arguments?['stationName'] ?? 'la gare sélectionnée';
    final category = arguments?['category'] ?? 'le type d\'objet sélectionné';
    final dateTime = arguments?['dateTime'] ?? 'la date et l\'heure sélectionnées';

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

  // Fonction pour obtenir l'icône correspondante à une catégorie spécifique d'objet
  String? _getIconForCategory(String category) {
    category = category.toLowerCase();
    for (final entry in categoriesDictionary.entries) {
      for (final keyword in entry.value) {
        if (category.contains(keyword.toLowerCase())) {
          String iconName = entry.key.toLowerCase().replaceAll(' ', '_');
          // Ajuster le nom des icônes pour correspondre aux fichiers dans les assets
          switch (iconName) {
            case 'clés':
              iconName = 'cles'; // Correspond au nom de l'asset `cles.png`
              break;
            case 'affaires_d\'enfants':
              iconName = 'enfants'; // Correspond au nom de l'asset `enfants.png`
              break;
            case 'portefeuille':
              iconName = 'portefeuille'; // Correspond au nom de l'asset `portefeuille.png`
              break;
            case 'documents':
              iconName = 'documents'; // Correspond au nom de l'asset `documents.png`
              break;
            case 'sacs':
              iconName = 'sacs'; // Correspond au nom de l'asset `sacs.png`
              break;
            case 'electronique':
              iconName = 'electronique'; // Correspond au nom de l'asset `electronique.png`
              break;
            case 'bijoux':
              iconName = 'bijoux'; // Correspond au nom de l'asset `bijoux.png`
              break;
            case 'vêtements':
              iconName = 'vetements'; // Correspond au nom de l'asset `vetements.png`
              break;
            case 'sport':
              iconName = 'sport'; // Correspond au nom de l'asset `sport.png`
              break;
            case 'divers':
              iconName = 'divers'; // Correspond au nom de l'asset `divers.png`
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
