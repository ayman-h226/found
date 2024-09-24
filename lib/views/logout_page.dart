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
            // Logique pour se déconnecter, comme réinitialiser les données utilisateur
            // et rediriger vers la page de connexion ou d'accueil.
            Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
          },
          child: Text('Se déconnecter'),
        ),
      ),
    );
  }
}
