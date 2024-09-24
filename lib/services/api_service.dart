import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Base URL pour récupérer les objets trouvés
  final String baseUrl = 'https://data.sncf.com/api/records/1.0/search/';

  // URL pour récupérer la liste des gares via Open Data SNCF
  final String stationsUrl =
      'https://ressources.data.sncf.com/api/records/1.0/search/?dataset=referentiel-gares-voyageurs';

  // Fonction pour récupérer les gares en fonction de l'entrée utilisateur
  Future<List<String>> fetchStations(String query) async {
    final uri = Uri.parse('$stationsUrl&q=$query');

    // Affiche l'URL de la requête pour déboguer
    print("Requête pour les gares : $uri");

    // Effectuer la requête HTTP GET
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      print("gare chargé avec succès");
      final data = jsonDecode(response.body);
      List<String> stationNames = [];

      // Parcours des résultats pour récupérer les noms des gares
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
    required String trainNumber,
  }) async {
    // Paramètres de la requête API
    final Map<String, String> queryParams = {
      'dataset': 'objets-trouves-restitution',
      'rows': '20', // Limite à 20 résultats
    };

    if (stationName.isNotEmpty) {
      queryParams['refine.gare_origine_r_name'] = stationName;
    }
    if (category.isNotEmpty) {
      queryParams['refine.gc_obo_nature_c'] = category;
    }
    if (trainNumber.isNotEmpty) {
      queryParams['refine.gc_obo_numero_de_train'] = trainNumber;
    }

    // Construire l'URL avec les paramètres
    final uri = Uri.parse(baseUrl).replace(queryParameters: queryParams);

    // Effectuer la requête GET
    final response = await http.get(uri);

    print('Statut de la réponse: ${response.statusCode}'); // Pour débogage

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['records']; // Retourne la liste des objets trouvés
    } else {
      print('Erreur: ${response.statusCode} - ${response.body}');
      throw Exception('Erreur lors de la récupération des objets trouvés');
    }
  }

  // Fonction pour récupérer les 100 derniers objets trouvés
  Future<List<dynamic>> fetchRecentItems() async {
    final queryParams = {
      'dataset': 'objets-trouves-restitution',
      'rows': '100', // Afficher les 100 derniers résultats
      'sort': '-date', // Tri par date décroissante
    };

    final uri = Uri.parse(baseUrl).replace(queryParameters: queryParams);

    print("Requête pour les 100 derniers objets : $uri");

    // Effectuer la requête GET
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['records']; // Retourne les objets trouvés
    } else {
      print('Erreur: ${response.statusCode} - ${response.body}');
      throw Exception('Erreur lors de la récupération des 100 derniers objets trouvés');
    }
  }
}
