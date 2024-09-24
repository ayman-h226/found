// lib/models/user.dart

class User {
  final String fullName;
  final String email;
  final String token;

  User({
    required this.fullName,
    required this.email,
    required this.token,
  });

  // Convertir un objet JSON en instance de User
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      fullName: json['full_name'],
      email: json['email'],
      token: json['token'],
    );
  }

  // Convertir une instance de User en JSON
  Map<String, dynamic> toJson() {
    return {
      'full_name': fullName,
      'email': email,
      'token': token,
    };
  }
}
