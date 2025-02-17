import 'package:flutter/material.dart';
import 'package:projectmobile/Model/newsModel.dart';
// import 'package:url_launcher/url_launcher.dart';

class NewsDetailScreen extends StatelessWidget {
  final NewsArticle article;

  const NewsDetailScreen({Key? key, required this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          article.sourceName ?? "Chi tiết bài báo",
          style: TextStyle(color: Colors.white),
        ),
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
      body: NewsDetailBody(article)
    );
  }

  Widget NewsDetailBody(NewsArticle article) {
    return Container(
      height: double.infinity,
      decoration: BoxDecoration(
        color: Color.fromARGB(158, 10, 10, 10), // Màu nền cho body
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tiêu đề
                  Text(
                    article.title,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  SizedBox(height: 10),
                  // Thời gian & nguồn
                  Text(
                    "${article.sourceName ?? "Nguồn không xác định"} • ${article.pubDate ?? "Không rõ thời gian"}",
                    style: TextStyle(color: const Color.fromARGB(162, 255, 255, 255)),
                  ),
                  SizedBox(height: 15),
                  // Anh
                  if (article.imageUrl != null && article.imageUrl!.isNotEmpty)
                    Container(
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(article.imageUrl!),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  SizedBox(height: 15),
      
                  // Nội dung bài báo
                  Text(
                    article.description ?? "Nội dung không khả dụng",
                    style: TextStyle(fontSize: 16, height: 1.5,color: Colors.white),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
