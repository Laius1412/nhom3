import 'package:flutter/material.dart';

class InforMatchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          color: Color(0xFF000000),
          child: Center(
            child: Text(
              "This is information about this match",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
