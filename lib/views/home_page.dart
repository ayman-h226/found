import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Pour formater la date et l'heure
import '../services/api_service.dart';
import 'package:searchfield/searchfield.dart'; // Pour l'auto-complétion

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController gareController = TextEditingController();
  final TextEditingController dateTimeController = TextEditingController();

  List<String>? stationList; // Liste des gares
  String? selectedCategory; // Stocker la catégorie sélectionnée
  bool isLoadingStations = false; // Indicateur de chargement

  // Liste des catégories disponibles
  final List<String> categories = [
    'Vêtements',
    'Bagagerie',
    'Papeterie',
    'Electronique',
    'Clés',
    'Bijoux, Montres',
    'Pièces d\'identité',
    'Sport et Loisirs',
    'Divers'
  ];

  @override
  void initState() {
    super.initState();
  }

  // Fonction pour récupérer les gares en fonction de l'entrée utilisateur
  Future<void> fetchStations(String query) async {
    setState(() {
      isLoadingStations = true; // Activer le chargement
    });

    try {
      final stations = await ApiService().fetchStations(query);
      setState(() {
        stationList = stations;
        print("Liste des gares récupérée : $stationList");
      });
    } catch (e) {
      print('Erreur lors de la récupération des gares: $e');
    } finally {
      setState(() {
        isLoadingStations = false; // Désactiver le chargement
      });
    }
  }

  // Construire chaque bouton de catégorie
  Widget _buildCategoryButton(BuildContext context, String label, String assetImagePath) {
    bool isSelected = selectedCategory == label;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = label; // Définir la catégorie sélectionnée
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? Colors.blueAccent.withOpacity(0.3) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? Colors.blueAccent : Colors.transparent,
            width: 2,
          ),
        ),
        padding: EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(assetImagePath, width: 40, height: 40),
            SizedBox(height: 10),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isSelected ? Colors.blueAccent : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Objets Trouvés SNCF'),
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 23,
          fontWeight: FontWeight.bold,
        ),
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
                  Image.asset('assets/images/SNCF.png', width: 100, height: 100),
                  SizedBox(height: 15),
                  Text(
                    'Bienvenue dans l\'application Objets Trouvés',
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            SizedBox(height: 40),

            // Champs de recherche - Gare de départ
            SearchField(
              controller: gareController,
              suggestions: stationList != null
                  ? stationList!
                  .map((station) => SearchFieldListItem<String>(station))
                  .toList()
                  : [],
              searchInputDecoration: SearchInputDecoration(
                labelText: 'Gare de départ *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.location_on),
                suffixIcon: isLoadingStations
                    ? Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
                    : Icon(Icons.search),
              ),
              onSuggestionTap: (suggestion) {
                gareController.text = suggestion.item! as String; // Typage explicite en String
              },
              onSearchTextChanged: (query) {
                if (query.isNotEmpty) {
                  fetchStations(query); // Récupérer les gares correspondant à la saisie
                }
              },
            ),
            SizedBox(height: 15),

            // Date et Heure de départ
            TextField(
              controller: dateTimeController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Date et Heure de départ *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.access_time),
              ),
              onTap: () async {
                // Sélection de la date et de l'heure
                DateTime? selectedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2010),
                  lastDate: DateTime(2050),
                );

                if (selectedDate != null) {
                  TimeOfDay? selectedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );

                  if (selectedTime != null) {
                    DateTime selectedDateTime = DateTime(
                      selectedDate.year,
                      selectedDate.month,
                      selectedDate.day,
                      selectedTime.hour,
                      selectedTime.minute,
                    );
                    dateTimeController.text =
                        DateFormat('dd MMMM yyyy HH:mm').format(selectedDateTime);
                  }
                }
              },
            ),
            SizedBox(height: 20),

            // Boutons de catégorie
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Catégories d\'objets',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text(
                  '(Faites défiler vers le bas)',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ],
            ),
            SizedBox(height: 25),
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                children: categories.map((category) {
                  String iconPath = 'assets/icons/default.png'; // Définir un chemin d'icône par défaut
                  switch (category) {
                    case 'Vêtements':
                      iconPath = 'assets/icons/vetements.png';
                      break;
                    case 'Bagagerie':
                      iconPath = 'assets/icons/sacs.png';
                      break;
                    case 'Papeterie':
                      iconPath = 'assets/icons/documents.png';
                      break;
                    case 'Electronique':
                      iconPath = 'assets/icons/electronique.png';
                      break;
                    case 'Clés':
                      iconPath = 'assets/icons/cles.png';
                      break;
                    case 'Bijoux, Montres':
                      iconPath = 'assets/icons/bijoux.png';
                      break;
                    case 'Pièces d\'identité':
                      iconPath = 'assets/icons/documents.png';
                      break;
                    case 'Sport et Loisirs':
                      iconPath = 'assets/icons/sport.png';
                      break;
                    case 'Divers':
                      iconPath = 'assets/icons/divers.png';
                      break;
                  }
                  return _buildCategoryButton(context, category, iconPath);
                }).toList(),
              ),
            ),
            SizedBox(height: 20),
            Text(
              '* Champs obligatoires',
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 20),

            // Bouton de recherche
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  if (gareController.text.isEmpty || dateTimeController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Veuillez remplir les champs obligatoires'),
                    ));
                    return;
                  }

                  final stationName = gareController.text;
                  final category = selectedCategory ?? 'Divers'; // Catégorie sélectionnée
                  final dateTime = dateTimeController.text;

                  try {
                    final results = await ApiService().fetchLostItems(
                      stationName: stationName,
                      category: category,
                      dateTime: dateTime,
                    );

                    if (results.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                            'Aucun objet de type "$category" trouvé pour la gare "$stationName" à l\'heure "$dateTime". Essayez avec des entrées différentes.'),
                      ));
                    } else {
                      Navigator.pushNamed(
                        context,
                        '/search_results',
                        arguments: {
                          'results': results,
                          'stationName': stationName,
                          'category': category,
                          'dateTime': dateTime,
                        },
                      );
                    }
                  } catch (e) {
                    print('Erreur lors de la recherche: $e');
                  }
                },
                child: Text('Rechercher'),
              ),
            ),
            SizedBox(height: 15),

            // Bouton "Afficher tout"
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  try {
                    final results = await ApiService().fetchRecentItems();
                    Navigator.pushNamed(
                      context,
                      '/search_results',
                      arguments: {
                        'results': results,
                      },
                    );
                  } catch (e) {
                    print('Erreur lors de la récupération des objets: $e');
                  }
                },
                child: Text('Afficher les derniers objets trouvés'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
