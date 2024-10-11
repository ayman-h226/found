import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import 'package:searchfield/searchfield.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Controllers pour gérer l'entrée utilisateur
  final TextEditingController gareController = TextEditingController();
  final TextEditingController dateTimeController = TextEditingController();

  // Variables pour gérer la liste des gares, la catégorie sélectionnée, le statut de chargement, etc.
  List<String>? stationList;
  String? selectedCategory;
  bool isLoadingStations = false;
  DateTime? lastLaunchDate;
  int newItemsCount = 0;
  bool isFirstConnection = true;

  // Liste des catégories disponibles
  final List<String> categories = [
    'Vêtements',
    'Bagagerie',
    'Papeterie',
    'Electronique',
    'Clés',
    'Bijoux',
    'Pièces',
    'Portefeuille',
    'Sport',
    'Divers'
  ];

  @override
  void initState() {
    super.initState();
    _loadLastLaunchDate(); // Charger la date de dernière visite pour déterminer si c'est la première connexion
  }

  // Charger la date de dernière visite depuis les préférences partagées
  Future<void> _loadLastLaunchDate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? lastLaunchDateString = prefs.getString('lastLaunchDate');

    if (lastLaunchDateString != null) {
      setState(() {
        lastLaunchDate = DateTime.parse(lastLaunchDateString);
        isFirstConnection = false; // L'utilisateur a déjà lancé l'application
      });
      _checkForNewItems(); // Vérifier les nouveaux objets depuis la dernière visite
    } else {
      // Première fois que l'application est lancée
      setState(() {
        isFirstConnection = true;
        lastLaunchDate = DateTime.now();
      });
    }

    // Sauvegarder la date de lancement actuelle
    prefs.setString('lastLaunchDate', DateTime.now().toIso8601String());
  }

  // Sauvegarder la date de lancement actuelle lorsque l'utilisateur quitte la page
  Future<void> _saveCurrentLaunchDate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('lastLaunchDate', DateTime.now().toIso8601String());
  }

  // Vérifier les nouveaux objets trouvés depuis la dernière visite
  Future<void> _checkForNewItems() async {
    if (lastLaunchDate != null) {
      final apiService = ApiService();
      try {
        final results = await apiService.fetchLostItemsSinceDate(lastLaunchDate!);
        setState(() {
          newItemsCount = results.length; // Mettre à jour le nombre d'objets trouvés depuis la dernière visite
        });
      } catch (e) {
        print('Erreur lors de la vérification des nouveaux objets : $e');
      }
    }
  }

  // Récupérer la liste des gares basée sur l'entrée utilisateur
  Future<void> fetchStations(String query) async {
    setState(() {
      isLoadingStations = true; // Activer l'indicateur de chargement
    });

    try {
      final stations = await ApiService().fetchStations(query);
      setState(() {
        stationList = stations;
      });
    } catch (e) {
      print('Erreur lors de la récupération des gares: $e');
    } finally {
      setState(() {
        isLoadingStations = false; // Désactiver l'indicateur de chargement
      });
    }
  }

  // Construire le widget de message d'accueil en fonction de l'historique utilisateur
  Widget _buildGreetingMessage() {
    if (!isFirstConnection) {
      if (newItemsCount > 0) {
        return Text(
          '$newItemsCount objets retrouvés depuis votre dernière visite',
          style: TextStyle(fontSize: 18, color: Colors.blue),
          textAlign: TextAlign.center,
        );
      } else {
        return Text(
          'Rien de nouveau depuis votre dernière visite.',
          style: TextStyle(fontSize: 15, color: Colors.blueAccent),
          textAlign: TextAlign.center,
        );
      }
    }
    return Container(); // Aucun message si c'est la première connexion
  }

  // Construire un bouton pour sélectionner une catégorie
  Widget _buildCategoryButton(BuildContext context, String label, String assetImagePath) {
    bool isSelected = selectedCategory == label;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = label; // Mettre à jour la catégorie sélectionnée
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

  // Construire l'interface principale de la page
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Message de bienvenue et logo
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
                    SizedBox(height: 10),
                    // Afficher le message d'accueil seulement si ce n'est pas la première connexion
                    _buildGreetingMessage(),
                  ],
                ),
              ),
              SizedBox(height: 20),

              // Champ de recherche pour le nom de la gare
              SearchField(
                controller: gareController,
                suggestions: stationList != null
                    ? stationList!.map((station) => SearchFieldListItem<String>(station)).toList()
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
                  gareController.text = suggestion.searchKey; // Mettre à jour le champ avec la suggestion sélectionnée
                },
                onSearchTextChanged: (query) {
                  if (query.isNotEmpty) {
                    fetchStations(query);
                  }
                },
              ),
              SizedBox(height: 15),

              // Champ de sélection de la date et de l'heure
              TextField(
                controller: dateTimeController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Date et Heure de départ *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.access_time),
                ),
                onTap: () async {
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
                      dateTimeController.text = DateFormat('dd MMMM yyyy HH:mm', 'fr_FR').format(selectedDateTime);
                    }
                  }
                },
              ),
              SizedBox(height: 20),

              // Boutons pour sélectionner la catégorie
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
              SizedBox(height: 10),
              GridView.count(
                crossAxisCount: 3,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(), // Désactiver le défilement de GridView
                children: categories.map((category) {
                  String iconPath = 'assets/icons/default.png';
                  switch (category) {
                    case 'Vêtements':
                      iconPath = 'assets/icons/vetements.png';
                      break;
                    case 'Bagagerie':
                      iconPath = 'assets/icons/sacs.png';
                      break;
                    case 'Papeterie':
                      iconPath = 'assets/icons/book.png';
                      break;
                    case 'Electronique':
                      iconPath = 'assets/icons/electronique.png';
                      break;
                    case 'Clés':
                      iconPath = 'assets/icons/cles.png';
                      break;
                    case 'Bijoux':
                      iconPath = 'assets/icons/bijoux.png';
                      break;
                    case 'Pièces':
                      iconPath = 'assets/icons/documents.png';
                      break;
                    case 'Portefeuille':
                      iconPath = 'assets/icons/portefeuille.png';
                      break;
                    case 'Sport':
                      iconPath = 'assets/icons/sport.png';
                      break;
                    case 'Divers':
                      iconPath = 'assets/icons/divers.png';
                      break;
                  }
                  return _buildCategoryButton(context, category, iconPath);
                }).toList(),
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
                    final category = selectedCategory ?? 'Divers';
                    final dateTime = dateTimeController.text;

                    try {
                      DateTime parsedDateTime = DateFormat('dd MMMM yyyy HH:mm', 'fr_FR').parseLoose(dateTime);
                      String formattedDateTime = DateFormat('yyyy-MM-ddTHH:mm:ss').format(parsedDateTime);
                      // Rechercher des objets avec une date exacte
                      final exactResults = await ApiService().fetchLostItems(
                        stationName: stationName,
                        category: category,
                        dateTime: dateTime,
                      );

                      if (exactResults.isEmpty) {
                        // Si aucun résultat exact, rechercher des objets autour de la date spécifiée (±1h)
                        final aroundResults = await ApiService().fetchLostItemsAroundDate(
                          stationName,
                          category,
                          formattedDateTime,
                        );

                        if (aroundResults.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                              'Aucun objet trouvé pour la gare "$stationName" et la catégorie "$category" autour de "$dateTime". Essayez avec des entrées différentes.',
                            ),
                          ));
                        } else {
                          Navigator.pushNamed(
                            context,
                            '/search_results',
                            arguments: {
                              'results': aroundResults,
                              'stationName': stationName,
                              'category': category,
                              'dateTime': dateTime,
                              'isApproximate': true,
                            },
                          );
                        }
                      } else {
                        Navigator.pushNamed(
                          context,
                          '/search_results',
                          arguments: {
                            'results': exactResults,
                            'stationName': stationName,
                            'category': category,
                            'dateTime': dateTime,
                            'isApproximate': false,
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

              // Bouton pour afficher les derniers objets trouvés
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
      ),
    );
  }

  // Sauvegarder la date de lancement actuelle lorsque l'utilisateur quitte la page
  @override
  void dispose() {
    _saveCurrentLaunchDate();
    super.dispose();
  }
}
