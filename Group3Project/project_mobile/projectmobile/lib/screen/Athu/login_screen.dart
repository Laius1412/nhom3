import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projectmobile/screen/profile_screen.dart';
import 'package:projectmobile/screen/Athu/register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoginHovering = false;
  bool isRegisterHovering = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  Future<void> _login() async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      if (userDoc.exists) {
        final role = userDoc['role'] ?? 'user';
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ProfileScreen(role: role)),
        );
      } else {
        _showSnackBar("Không tìm thấy thông tin người dùng");
      }
    } on FirebaseAuthException catch (e) {
      _showSnackBar(e.code == 'user-not-found'
          ? "Không tìm thấy người dùng với email này"
          : e.code == 'wrong-password'
              ? "Sai mật khẩu"
              : "Đăng nhập thất bại");
    } catch (e) {
      _showSnackBar("Đăng nhập thất bại: $e");
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildBackground(),
          _buildLoginForm(),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [Color.fromARGB(255, 0, 0, 0), Color.fromARGB(255, 77, 16, 28)]),
      ),
      child: const Padding(
        padding: EdgeInsets.only(top: 60.0, left: 22),
        child: Text(
          'Xin chào\nBạn hãy đăng nhập!',
          style: TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Padding(
      padding: const EdgeInsets.only(top: 200.0),
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
          color: Colors.white,
        ),
        height: double.infinity,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: SingleChildScrollView( // Add this
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildTextField(_emailController, 'Gmail', Icons.check, false),
                const SizedBox(height: 20),
                _buildTextField(_passwordController, 'Mật khẩu', Icons.visibility_off, true),
                const SizedBox(height: 20),
                const Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Quên mật khẩu?',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Color(0xff281537)),
                  ),
                ),
                const SizedBox(height: 70),
                _buildLoginButton(),
                const SizedBox(height: 40), // Reduced from 150 to 40
                _buildRegisterPrompt(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, bool obscureText) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        suffixIcon: Icon(icon, color: Colors.grey),
        labelText: label,
        labelStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
      ),
    );
  }

  Widget _buildLoginButton() {
    return MouseRegion(
      onEnter: (event) => setState(() => isLoginHovering = true),
      onExit: (event) => setState(() => isLoginHovering = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: _login,
        child: Container(
          height: 55,
          width: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: const LinearGradient(colors: [Color(0xffB81736), Color(0xff281537)]),
          ),
          child: Center(
            child: Text(
              'Đăng nhập',
              style: TextStyle(
                fontWeight: FontWeight.bold, 
                fontSize: 20,
                color: isLoginHovering ? Colors.green : Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRegisterPrompt() {
    return Align(
      alignment: Alignment.bottomRight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Text(
            "Chưa có tài khoản?",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
          ),
          MouseRegion(
            onEnter: (even) => setState(() => isRegisterHovering = true),
            onExit: (even) => setState(() => isRegisterHovering = false),
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RegisterScreen()),
              ),
              child: Text(
                "Đăng ký",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                  color: isRegisterHovering ? Colors.green : Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}