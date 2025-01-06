import 'package:flutter/material.dart';

class NewsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tin tức'),
      ),
      body: Center(
        child: Text('Trang tin tức'),
      ),
    );
  }
}