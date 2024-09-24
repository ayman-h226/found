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
  final TextEditingController trainNumberController = TextEditingController();
  final TextEditingController dateTimeController = TextEditingController();

  List<String>? stationList; // Liste des gares
  String? selectedCategory; // Stocker la catégorie sélectionnée
  bool isLoadingStations = false; // Indicateur de chargement

  @override
  void initState() {
    super.initState();
    // On récupère les gares uniquement si besoin, via les saisies de l'utilisateur
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
  Widget _buildCategoryButton(BuildContext context, IconData icon, String label) {
    return ElevatedButton.icon(
      onPressed: () {
        setState(() {
          selectedCategory = label; // Définir la catégorie sélectionnée
        });
      },
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: selectedCategory == label
            ? Theme.of(context).colorScheme.primary
            : Colors.grey,
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
        actions: [
          IconButton(
            icon: Icon(Icons.login),
            iconSize: 35,
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
                  .toList() // Correction du typage avec <String>
                  : [],
              searchInputDecoration: SearchInputDecoration( // Utilisation correcte de InputDecoration
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

            // Numéro de train (optionnel)
            TextField(
              controller: trainNumberController,
              decoration: InputDecoration(
                labelText: 'Numéro de train (optionnel)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.train),
              ),
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
                    dateTimeController.text = DateFormat('dd MMMM yyyy HH:mm')
                        .format(selectedDateTime);
                  }
                }
              },
            ),
            SizedBox(height: 20),

            // Boutons de catégorie
            Text(
              'Catégories d\'objets',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 25),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: [
                _buildCategoryButton(context, Icons.phone_android, 'Téléphone'),
                _buildCategoryButton(context, Icons.backpack, 'Sac à dos'),
                _buildCategoryButton(context, Icons.wallet_travel, 'Portefeuille'),
                _buildCategoryButton(context, Icons.laptop, 'Ordinateur'),
                _buildCategoryButton(context, Icons.headphones, 'Casque Audio'),
                _buildCategoryButton(context, Icons.watch, 'Montre'),
                _buildCategoryButton(context, Icons.add_circle_outline, 'Autres'),
              ],
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
                  final category = selectedCategory ?? ''; // Catégorie sélectionnée
                  final trainNumber = trainNumberController.text;

                  try {
                    final results = await ApiService().fetchLostItems(
                      stationName: stationName,
                      category: category,
                      trainNumber: trainNumber,
                    );
                    Navigator.pushNamed(
                        context, '/search_results', arguments: results);
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
                        context, '/search_results', arguments: results);
                  } catch (e) {
                    print('Erreur lors de la récupération des objets: $e');
                  }
                },
                child: Text('Afficher les 100 derniers objets trouvés'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
