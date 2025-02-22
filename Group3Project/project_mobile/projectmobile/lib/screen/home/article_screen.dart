import 'package:flutter/material.dart';

class ArticleScreen extends StatelessWidget {
  final String title;
  final String imageUrl;

  const ArticleScreen({required this.title, required this.imageUrl, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chi tiết bài viết", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(imageUrl, width: double.infinity, height: 200, fit: BoxFit.cover),
            ),
            SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(height: 16),
            Text(
              "Đây là nội dung chi tiết của bài viết. ",
              style: TextStyle(fontSize: 16, color: Colors.white70),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.black,
    );
  }
}
