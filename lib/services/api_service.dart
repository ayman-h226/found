import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart'; // Importer pour initialiser les données de locale

class ApiService {
  // Base URL pour récupérer les objets trouvés
  final String baseUrl = 'https://data.sncf.com/api/records/1.0/search/';

  // URL pour récupérer la liste des gares via Open Data SNCF
  final String stationsUrl =
      'https://ressources.data.sncf.com/api/records/1.0/search/?dataset=referentiel-gares-voyageurs';

  // Dictionnaires de mots-clés pour chaque catégorie
  final Map<String, List<String>> categoryDictionaries = {
    'Vêtements': [
      'vêtements', 'veste', 'chaussures', 'manteau', 'blouson', 'pantalon', 'robe', 'chemise', 'pull', 'gilet', 'blazer', 'parka', 'cape'
    ],
    'Bagagerie et Sacs': [
      'bagagerie', 'sac', 'valise', 'cartable', 'sac à dos', 'sacoche', 'sac de voyage', 'sac à main', 'trolley', 'porte-documents', 'sac sur roulettes', 'sac d\'enseigne'
    ],
    'Papeterie': [
      'livre', 'agenda', 'papeterie', 'cahier', 'stylo', 'calendrier', 'bloc-notes', 'trousse', 'papier', 'fournitures scolaires'
    ],
    'Electronique': [
      'électronique', 'ordinateur', 'téléphone', 'appareil photo', 'tablette', 'caméra', 'smartphone', 'chargeur', 'accessoires électroniques', 'montre connectée', 'tablette tactile protégée', 'ordinateur portable', 'téléphone portable protégé'
    ],
    'Clés et Badges': [
      'clé', 'badge', 'porte-clés', 'carte d\'accès', 'carte de sécurité', 'clé USB', 'serrure', 'cadenas', 'boîte à clés', 'badge d\'identification', 'badge magnétique'
    ],
    'Bijoux, Montres': [
      'bijoux', 'montres', 'bracelet', 'collier', 'bague', 'pendentif', 'boucles d\'oreilles', 'diamant', 'parure', 'broche'
    ],
    'Porte-monnaie, Portefeuilles et Cartes': [
      'porte-monnaie', 'portefeuille', 'argent', 'titres', 'carte bancaire', 'carte de crédit'
    ],
    'Pièces d\'identité et papiers personnels': [
      'pièces d\'identité', 'carte d\'identité', 'passeport', 'permis de conduire', 'carte Vitale', 'titre de séjour', 'permis de travail', 'document officiel', 'billet', 'autre pièce ou papier personnel'
    ],
    'Sport et Loisirs': [
      'sport', 'ballon', 'raquette', 'vélo', 'trottinette', 'gants de boxe', 'patins', 'bâton de randonnée', 'sac de sport', 'tente', 'articles de sport', 'outils', 'accessoires'
    ],
    'Porte-monnaie / Portefeuille': [
      'porte-monnaie', 'portefeuille', 'carte de crédit', 'CB', 'argent', 'titres'
    ],
    'Divers': [
      'divers', 'parapluie', 'tente', 'objets divers', 'lunettes', 'accessoires', 'autre', 'inconnus', 'autres divers'
    ],
  };


  // Fonction pour récupérer les gares en fonction de l'entrée utilisateur
  Future<List<String>> fetchStations(String query) async {
    final uri = Uri.parse('$stationsUrl&q=$query');

    print("Requête pour les gares : $uri");

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      print("Gares chargées avec succès");
      final data = jsonDecode(response.body);
      List<String> stationNames = [];

      for (var record in data['records']) {
        stationNames.add(record['fields']['gare_ut_libelle']);
      }
      return stationNames;
    } else {
      print('Erreur: ${response.statusCode} - ${response.body}');
      throw Exception('Erreur lors de la récupération des gares');
    }
  }

  // Fonction pour récupérer les objets trouvés avec des filtres
  Future<List<dynamic>> fetchLostItems({
    required String stationName,
    required String category,
    required String dateTime,
  }) async {
    try {
      // Initialiser les données de la locale française
      await initializeDateFormatting('fr_FR');

      // Essayer de convertir la date entrée par l'utilisateur en DateTime
      DateTime parsedDateTime = DateFormat('dd MMMM yyyy HH:mm', 'fr_FR')
          .parseLoose(dateTime);

      // Convertir en ISO 8601 pour l'utiliser dans la requête
      String formattedDateTime = parsedDateTime.toIso8601String();

      // Récupération du dictionnaire de mots-clés associé à la catégorie
      final keywords = categoryDictionaries[category] ?? [];

      // Construire une requête qui filtre les objets dont le type ou la nature correspond à l'un des mots du dictionnaire
      final String keywordsQuery = keywords.map((word) => '"$word"').join(
          ' OR ');

      final Map<String, String> queryParams = {
        'dataset': 'objets-trouves-restitution',
        'rows': '20',
        'refine.gare_origine_r_name': stationName,
        'order_by': 'date desc',
        'timezone': 'Europe/Paris',
      };

      // Ajouter la date en utilisant la version correctement formatée
      queryParams['q'] = 'date=$formattedDateTime';

      // Ajouter les mots-clés si une catégorie est précisée
      if (keywords.isNotEmpty) {
        queryParams['q'] = queryParams['q']! +
            ' AND (gc_obo_type_c:($keywordsQuery) OR gc_obo_nature_c:($keywordsQuery))';
      }

      final uri = Uri.parse(baseUrl).replace(queryParameters: queryParams);

      print('Requête pour les objets trouvés : $uri');

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List<dynamic> records = data['records'];

        // Filtrer les objets qui n'ont pas été restitués
        records = records.where((record) {
          return record['fields']['gc_obo_date_heure_restitution_c'] == null;
        }).toList();

        // Si aucun objet exact n'est trouvé, récupérer des objets proches de la date/heure entrée
        if (records.isEmpty) {
          return await fetchLostItemsAroundDate(
              stationName, category, formattedDateTime);
        }

        return records;
      } else {
        print('Erreur: ${response.statusCode} - ${response.body}');
        throw Exception('Erreur lors de la récupération des objets trouvés');
      }
    } catch (e) {
      print('Erreur lors de la recherche: $e');
      throw Exception('Erreur lors de la recherche : $e');
    }
  }

  // Fonction pour récupérer des objets proches de la date/heure spécifiée
  Future<List<dynamic>> fetchLostItemsAroundDate(String stationName,
      String category, String dateTime) async {
    final keywords = categoryDictionaries[category] ?? [];
    final String keywordsQuery = keywords.map((word) => '"$word"').join(' OR ');

    final Map<String, String> queryParams = {
      'dataset': 'objets-trouves-restitution',
      'rows': '10',
      'refine.gare_origine_r_name': stationName,
      'sort': 'date',
    };

    // Ajouter les mots-clés à la requête si une catégorie est précisée
    if (keywords.isNotEmpty) {
      queryParams['q'] =
      '(gc_obo_type_c:($keywordsQuery) OR gc_obo_nature_c:($keywordsQuery))';
    }

    final uri = Uri.parse(baseUrl).replace(queryParameters: queryParams);

    print('Requête pour les objets autour de la date : $uri');

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['records'];
    } else {
      print('Erreur: ${response.statusCode} - ${response.body}');
      throw Exception(
          'Erreur lors de la récupération des objets autour de la date');
    }
  }

  // Fonction pour récupérer les 100 derniers objets trouvés (à partir de la date actuelle)
  Future<List<dynamic>> fetchRecentItems() async {
    final DateTime currentDate = DateTime.now();
    final String formattedCurrentDate = currentDate.toIso8601String();

    final queryParams = {
      'dataset': 'objets-trouves-restitution',
      'rows': '100',
      'sort': 'date',
      'q': 'date<=$formattedCurrentDate',
      // Récupérer les objets jusqu'à la date actuelle
      'timezone': 'Europe/Paris',
    };

    final uri = Uri.parse(baseUrl).replace(queryParameters: queryParams);

    print("Requête pour les 100 derniers objets : $uri");

    final response = await http.get(uri);
    print('Données retournées par l\'API : ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['records'];
    } else {
      print('Erreur: ${response.statusCode} - ${response.body}');
      throw Exception(
          'Erreur lors de la récupération des 100 derniers objets trouvés');
    }
  }

  // Fonction pour récupérer les objets trouvés depuis une date donnée
  Future<List<dynamic>> fetchLostItemsSinceDate(DateTime lastLaunchDate) async {
    // Initialiser les données de la locale française pour le formatage des dates
    await initializeDateFormatting('fr_FR');

    // Formatage de la date en ISO 8601
    String formattedLastLaunchDate = DateFormat('yyyy-MM-ddTHH:mm:ss').format(
        lastLaunchDate);

    // Construire les paramètres de requête
    final queryParams = {
      'dataset': 'objets-trouves-restitution',
      'rows': '50',
      'q': 'date >= "$formattedLastLaunchDate"',
      'timezone': 'Europe/Paris',
    };

    // Construire l'URI avec les paramètres
    final uri = Uri.parse(baseUrl).replace(queryParameters: queryParams);

    print(
        'Requête pour les objets trouvés depuis la dernière connexion : $uri');

    // Effectuer la requête HTTP
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // Filtrer les objets qui n'ont pas été restitués
      List<dynamic> records = data['records'].where((record) {
        return record['fields']['gc_obo_date_heure_restitution_c'] == null;
      }).toList();
      return records;
    } else {
      print('Erreur: ${response.statusCode} - ${response.body}');
      throw Exception(
          'Erreur lors de la récupération des objets depuis la dernière connexion');
    }
  }
}