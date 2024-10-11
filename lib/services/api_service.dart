import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart'; // Importer pour initialiser les données de locale

class ApiService {
  // URL de base pour récupérer les objets trouvés
  final String baseUrl = 'https://data.sncf.com/api/records/1.0/search/';

  // URL pour récupérer la liste des gares via Open Data SNCF
  final String stationsUrl =
      'https://ressources.data.sncf.com/api/records/1.0/search/?dataset=referentiel-gares-voyageurs';

  // Dictionnaire de mots-clés pour chaque catégorie
  final Map<String, List<String>> categoryDictionaries = {
    'Vêtements': ['vêtements', 'veste', 'chaussures', 'manteau', 'blouson', 'pantalon', 'robe', 'chemise', 'pull', 'gilet'],
    'Bagagerie': ['bagagerie', 'sac', 'valise', 'cartable', 'sac à dos', 'sacoche', 'sac de voyage'],
    'Papeterie': ['livre', 'agenda', 'papeterie', 'cahier', 'stylo', 'bloc-notes', 'fournitures scolaires'],
    'Electronique': ['électronique', 'ordinateur', 'téléphone', 'appareil photo', 'tablette', 'caméra'],
    'Clés': ['clé', 'badge', 'porte-clés', 'carte d\'accès'],
    'Bijoux': ['bijoux', 'bracelet', 'collier', 'bague', 'pendentif', 'montre'],
    'Portefeuille': ['porte-monnaie', 'portefeuille', 'carte de crédit', 'argent'],
    'Pièces': ['carte d\'identité', 'passeport', 'document officiel', 'permis de conduire'],
    'Sport': ['sport', 'ballon', 'raquette', 'vélo', 'trottinette', 'gants de boxe'],
    'Divers': ['divers', 'parapluie', 'lunettes', 'accessoires'],
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

  // Fonction privée pour effectuer les requêtes avec des filtres dynamiques
  Future<List<dynamic>> _fetchLostItems({
    String? stationName,
    String? category,
    String? dateTime,
    DateTime? lastLaunchDate,
    bool exactDate = false,
    bool aroundDate = false,
    bool fromLastLaunch = false,
  }) async {
    try {
      await initializeDateFormatting('fr_FR');

      // Déclaration des paramètres de la requête
      final Map<String, String> queryParams = {
        'dataset': 'objets-trouves-restitution',
        'rows': '20',
        'sort': 'date',
        'timezone': 'Europe/Paris',
      };

      // Initialisation de la variable pour la requête dynamique `q`
      String q = '';

      // Filtre de la station si spécifiée
      if (stationName != null && stationName.isNotEmpty) {
        queryParams['refine.gare_origine_r_name'] = stationName;
      }

      // Gestion des filtres de date dans la requête
      if (fromLastLaunch && lastLaunchDate != null) {
        String formattedLastLaunchDate = DateFormat('yyyy-MM-ddTHH:mm:ss').format(lastLaunchDate);
        q = 'date >= "$formattedLastLaunchDate"';
      } else if (dateTime != null && exactDate) {
        try {
          DateTime parsedDateTime = DateFormat('dd MMMM yyyy HH:mm', 'fr_FR').parseLoose(dateTime);
          String formattedDateTime = DateFormat('yyyy-MM-ddTHH:mm:ss').format(parsedDateTime);
          q = 'date="$formattedDateTime" AND gc_obo_gare_origine_r_name="$stationName"';
        } catch (e) {
          print('Erreur de format de date : $e');
          throw FormatException('Erreur lors de la conversion de la date');
        }
      } else if (dateTime != null && aroundDate) {
        DateTime parsedDateTime = DateFormat('yyyy-MM-ddTHH:mm:ss').parse(dateTime);
        DateTime oneHourBefore = parsedDateTime.subtract(Duration(hours: 1));
        DateTime oneHourAfter = parsedDateTime.add(Duration(hours: 1));
        String beforeDateTime = DateFormat('yyyy-MM-ddTHH:mm:ss').format(oneHourBefore);
        String afterDateTime = DateFormat('yyyy-MM-ddTHH:mm:ss').format(oneHourAfter);
        q = 'date>="$beforeDateTime" AND date<="$afterDateTime" AND gc_obo_gare_origine_r_name="$stationName"';
      }

      // Ajout des filtres pour la catégorie dans la requête
      if (category != null && categoryDictionaries.containsKey(category)) {
        final keywords = categoryDictionaries[category] ?? [];
        final String keywordsQuery = keywords.map((word) => '"$word"').join(' OR ');

        // Ajout des filtres de catégorie à la requête `q`
        if (q.isNotEmpty) {
          q += ' AND (gc_obo_type_c:($keywordsQuery) OR gc_obo_nature_c:($keywordsQuery))';
        } else {
          q = '(gc_obo_type_c:($keywordsQuery) OR gc_obo_nature_c:($keywordsQuery))';
        }
      }

      if (q.isNotEmpty) {
        queryParams['q'] = q;
      }

      final uri = Uri.parse(baseUrl).replace(queryParameters: queryParams);
      print('Requête pour les objets trouvés : $uri');

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List<dynamic> records = data['records'];

        // Filtrer les objets non restitués
        records = records.where((record) {
          return record['fields']['gc_obo_date_heure_restitution_c'] == null;
        }).toList();

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

  // Fonction pour récupérer les objets pour une recherche de date exacte
  Future<List<dynamic>> fetchLostItems({
    required String stationName,
    required String category,
    required String dateTime,
  }) async {
    return await _fetchLostItems(
      stationName: stationName,
      category: category,
      dateTime: dateTime,
      exactDate: true,
    );
  }

  // Fonction pour récupérer des objets proches de la date spécifiée
  Future<List<dynamic>> fetchLostItemsAroundDate(
      String stationName,
      String category,
      String dateTime,
      ) async {
    return await _fetchLostItems(
      stationName: stationName,
      category: category,
      dateTime: dateTime,
      aroundDate: true,
    );
  }

  // Fonction pour récupérer les objets trouvés depuis une date donnée
  Future<List<dynamic>> fetchLostItemsSinceDate(DateTime lastLaunchDate) async {
    return await _fetchLostItems(
      stationName: null,
      fromLastLaunch: true,
      lastLaunchDate: lastLaunchDate,
    );
  }

  // Fonction pour récupérer les derniers objets trouvés (recherche générique)
  Future<List<dynamic>> fetchRecentItems() async {
    final DateTime currentDate = DateTime.now();
    return await _fetchLostItems(
      stationName: null,
      dateTime: currentDate.toIso8601String(),
    );
  }
}
