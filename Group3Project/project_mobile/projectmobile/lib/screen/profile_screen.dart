import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:projectmobile/screen/Athu/login_screen.dart';  // Import màn hình đăng nhập

class ProfileScreen extends StatelessWidget {
  final String role;

  const ProfileScreen({super.key, required this.role});

  void _logout(BuildContext context) {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // Nếu chưa đăng nhập, điều hướng đến màn hình đăng nhập
        if (!snapshot.hasData) {
          return const LoginScreen();
        }

        // Nếu đã đăng nhập, hiển thị thông tin người dùng
        return Scaffold(
          appBar: AppBar(
            title: const Text("Trang cá nhân"),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () => _logout(context),
              ),
            ],
          ),
          body: Center(
            child: Text("Chào mừng! Vai trò của bạn là: $role"),
          ),
        );
      },
    );
  }
}
