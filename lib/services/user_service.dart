// lib/services/user_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';

class UserService {
  // Fonction de connexion
  Future<User?> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('https://votreapi.com/login'),
      body: jsonEncode({'email': email, 'password': password}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      // Gérer les erreurs
      return null;
    }
  }

  // Fonction d'inscription
  Future<User?> signup(String fullName, String email, String password) async {
    final response = await http.post(
      Uri.parse('https://votreapi.com/signup'),
      body: jsonEncode({
        'full_name': fullName,
        'email': email,
        'password': password,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 201) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      // Gérer les erreurs
      return null;
    }
  }
}
