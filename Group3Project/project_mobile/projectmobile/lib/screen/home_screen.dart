import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Container(
        // color: Color(0xFF0A0A23),
        child: Center(
          child: Text('This is the Home Screen'),
        ),
      ),
    );
  }
}