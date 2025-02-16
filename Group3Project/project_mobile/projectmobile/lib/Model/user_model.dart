import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  String username;
  String email;
  String role;

  AppUser({required this.username, required this.email, required this.role});

  // Factory method để tạo từ Firestore
  factory AppUser.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    if (data == null) {
      throw Exception('Document data is null');
    }
    return AppUser(
      username: data['username'] ?? '',
      email: data['email'] ?? '',
      role: data['role'] ?? '',
    );
  }
}
