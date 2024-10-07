import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Pour formater la date et l'heure
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import 'package:searchfield/searchfield.dart'; // Pour l'auto-complétion

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Controllers for user input fields
  final TextEditingController gareController = TextEditingController();
  final TextEditingController dateTimeController = TextEditingController();

  // Variables to manage station list, selected category, loading status, etc.
  List<String>? stationList;
  String? selectedCategory;
  bool isLoadingStations = false;
  DateTime? lastLaunchDate;
  int newItemsCount = 0;
  bool isFirstConnection = true;

  // List of available categories
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
    _loadLastLaunchDate(); // Load the last launch date to determine if it's the first connection
  }

  // Load the last launch date from shared preferences
  Future<void> _loadLastLaunchDate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? lastLaunchDateString = prefs.getString('lastLaunchDate');

    if (lastLaunchDateString != null) {
      setState(() {
        lastLaunchDate = DateTime.parse(lastLaunchDateString);
        isFirstConnection = false; // User has launched the app before
      });
      _checkForNewItems(); // Check for new items since the last visit
    } else {
      // First time launch
      setState(() {
        isFirstConnection = true;
        lastLaunchDate = DateTime.now();
      });
    }

    // Save the current launch date
    prefs.setString('lastLaunchDate', DateTime.now().toIso8601String());
  }

  // Save the current launch date when leaving the page
  Future<void> _saveCurrentLaunchDate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('lastLaunchDate', DateTime.now().toIso8601String());
  }

  // Check for new items found since the last launch
  Future<void> _checkForNewItems() async {
    if (lastLaunchDate != null) {
      final apiService = ApiService();
      try {
        final results = await apiService.fetchLostItemsSinceDate(lastLaunchDate!);
        setState(() {
          newItemsCount = results.length;
        });
      } catch (e) {
        print('Erreur lors de la vérification des nouveaux objets : $e');
      }
    }
  }

  // Fetch the stations list based on user input
  Future<void> fetchStations(String query) async {
    setState(() {
      isLoadingStations = true; // Set loading indicator
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
        isLoadingStations = false; // Stop loading indicator
      });
    }
  }

  // Build the greeting message widget based on the user's history
  Widget _buildGreetingMessage() {
    if (!isFirstConnection) {
      if (newItemsCount > 0) {
        return Text(
          '$newItemsCount objets qui ont été retrouvés depuis votre dernière visite',
          style: TextStyle(fontSize: 18, color: Colors.blue),
          textAlign: TextAlign.center,
        );
      } else {
        return Text(
          'R-A-S depuis $lastLaunchDate.',
          style: TextStyle(fontSize: 15, color: Colors.blueAccent),
          textAlign: TextAlign.center,
        );
      }
    }
    return Container(); // No message for the first connection
  }

  // Build a button for selecting a category
  Widget _buildCategoryButton(BuildContext context, String label, String assetImagePath) {
    bool isSelected = selectedCategory == label;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = label; // Update selected category
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

  // Build the main UI of the page
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
      body: SingleChildScrollView( // Ajout du SingleChildScrollView pour éviter le dépassement
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome message and logo
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
                    // Display greeting message only if not the first connection
                    _buildGreetingMessage(),
                  ],
                ),
              ),
              SizedBox(height: 20),

              // Search field for station name
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
                  gareController.text = suggestion.searchKey; // Utiliser 'searchKey' pour obtenir le nom de la gare
                },
                onSearchTextChanged: (query) {
                  if (query.isNotEmpty) {
                    fetchStations(query);
                  }
                },
              ),
              SizedBox(height: 15),

              // Date and time picker field
              TextField(
                controller: dateTimeController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Date et Heure de départ *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.access_time),
                ),
                onTap: () async {
                  // Open date picker
                  DateTime? selectedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2010),
                    lastDate: DateTime(2050),
                  );

                  if (selectedDate != null) {
                    // Open time picker
                    TimeOfDay? selectedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );

                    if (selectedTime != null) {
                      // Format and display selected date and time
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

              // Category buttons
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
                physics: NeverScrollableScrollPhysics(), // Disable scrolling of GridView
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

              // Search button
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

              // "Afficher tout" button
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

  // Save the current launch date when leaving the page
  @override
  void dispose() {
    _saveCurrentLaunchDate();
    super.dispose();
  }
}
