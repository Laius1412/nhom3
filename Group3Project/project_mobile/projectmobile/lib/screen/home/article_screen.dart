import 'package:flutter/material.dart';

class ArticleScreen extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String content; // Thêm nội dung bài viết

  const ArticleScreen({
    required this.title,
    required this.imageUrl,
    required this.content, // Thêm vào constructor
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Chi tiết bài viết",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white), // Màu nút back
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color.fromARGB(255, 0, 0, 0), Color.fromARGB(255, 77, 16, 28)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ảnh bài viết
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(imageUrl, width: double.infinity, height: 200, fit: BoxFit.cover),
            ),
            SizedBox(height: 16),

            // Tiêu đề bài viết
            Text(
              title,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(height: 16),

            // Nội dung bài viết
            Text(
              content, // Hiển thị nội dung động
              style: TextStyle(fontSize: 16, color: Colors.white70),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.black,
    );
  }
}
