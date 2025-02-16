import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projectmobile/Model/user_model.dart';
import 'package:projectmobile/services/firestore_service.dart';
import 'package:projectmobile/screen/Athu/login_screen.dart';
import 'package:projectmobile/api/CloudinaryApi.dart'; // Import CloudinaryService

class ProfileScreen extends StatefulWidget {
  final String role;

  const ProfileScreen({super.key, required this.role});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirestoreService firestoreService = FirestoreService();
  final CloudinaryService cloudinaryService = CloudinaryService();
  final ImagePicker _picker = ImagePicker();

  void _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
  }

  Future<void> _changeAvatar(String userId) async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;

    File imageFile = File(pickedFile.path);
    String? imageUrl = await cloudinaryService.uploadImage(imageFile);

    if (imageUrl != null) {
      await firestoreService.updateUserProfile(userId, {'avatar': imageUrl});
      setState(() {}); // Refresh UI
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Upload ảnh thất bại!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData) {
          return const LoginScreen();
        }

        String userId = snapshot.data!.uid;

        return FutureBuilder<AppUser>(
          future: firestoreService.fetchUserData(userId),
          builder: (context, userSnapshot) {
            if (userSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (userSnapshot.hasError || !userSnapshot.hasData) {
              return const Center(child: Text('Lỗi khi tải dữ liệu người dùng!'));
            }

            AppUser user = userSnapshot.data!;

            return Scaffold(
              body: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 400,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.grey[800],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () => _changeAvatar(userId),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  CircleAvatar(
                                    radius: 75,
                                    backgroundImage: user.avatar != null && user.avatar!.isNotEmpty
                                        ? NetworkImage(user.avatar!)
                                        : const AssetImage('assets/images/avt.jpg') as ImageProvider,
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.blueAccent,
                                      ),
                                      padding: const EdgeInsets.all(8),
                                      child: const Icon(Icons.camera_alt, color: Colors.white, size: 24),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(user.username, style: const TextStyle(color: Colors.white, fontSize: 20)),
                            Text(user.email, style: const TextStyle(color: Colors.white)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      _buildMenuItem(icon: Icons.person, title: 'Cá nhân'),
                      _buildMenuItem(icon: Icons.settings, title: 'Cài đặt'),
                      _buildMenuItem(icon: Icons.notifications, title: 'Thông báo'),
                      _buildMenuItem(icon: Icons.logout, title: 'Đăng xuất', onTap: () => _logout(context)),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildMenuItem({required IconData icon, required String title, VoidCallback? onTap}) {
    return Container(
      width: 400,
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.white),
        title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
        onTap: onTap,
      ),
    );
  }
}
