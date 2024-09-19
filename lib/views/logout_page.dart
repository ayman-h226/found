// lib/views/logout_page.dart

import 'package:flutter/material.dart';

class LogoutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Déconnexion'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Logique pour déconnecter l'utilisateur ici
            Navigator.pushReplacementNamed(context, '/login');
          },
          child: Text('Se déconnecter'),
        ),
      ),
    );
  }
}
