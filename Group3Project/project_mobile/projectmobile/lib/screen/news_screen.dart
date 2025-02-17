import 'package:flutter/material.dart';
import 'package:projectmobile/Model/newsModel.dart';
import 'package:projectmobile/api/newsApi.dart';
import 'package:projectmobile/screen/NewsDetail/news_detail_screen.dart';

class NewsScreen extends StatefulWidget {
  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  late Future<List<NewsArticle>> futureNews;

  @override
  void initState() {
    super.initState();
    futureNews = NewsApi.fetchNews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tin tức thể thao",
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
      body: FutureBuilder<List<NewsArticle>>(
        future: futureNews,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Lỗi: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("Không có tin tức"));
          }

          // Lấy danh sách tin tức
          List<NewsArticle> articles = snapshot.data!;
          
          // Tin nổi bật là bài đầu tiên
          NewsArticle featuredArticle = articles.first;
          List<NewsArticle> otherArticles = articles.skip(1).toList();

          return ListView(
            children: [
              _buildFeaturedNews(featuredArticle),

              ...otherArticles.map((article) => _buildNewsItem(article)).toList(),
            ],
          );
        },
      ),
    );
  }

  // 🔹 Widget hiển thị tin nổi bật
  Widget _buildFeaturedNews(NewsArticle article) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NewsDetailScreen(article: article),
          ),
        );
      },
      child: Container(
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.3), blurRadius: 5)],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            // Ảnh lớn của tin nổi bật
            article.imageUrl != null && article.imageUrl!.isNotEmpty
                ? Image.network(
                    article.imageUrl!,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 200,
                        color: Colors.grey,
                        child: Icon(Icons.broken_image, size: 80, color: Colors.white),
                      );
                    },
                  )
                : Container(height: 200, color: Colors.grey),

            // Tiêu đề bài báo
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "${article.sourceName ?? "Nguồn không xác định"} • ${article.pubDate ?? "Không rõ thời gian"}",
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
    );
  }

  // 🔹 Widget hiển thị tin tức bình thường
    Widget _buildNewsItem(NewsArticle article) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NewsDetailScreen(article: article),
          ),
        );
      },
      child: Container(
        height: 100,
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          leading: Container(
            width: 95,
            height: 95,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey[200],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: article.imageUrl != null && article.imageUrl!.isNotEmpty
                  ? Image.network(
                      article.imageUrl!,
                      width: 95,
                      height: 95,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(Icons.broken_image, size: 95, color: Colors.grey);
                      },
                    )
                  : Icon(Icons.image_not_supported, size: 95, color: Colors.grey),
            ),
          ),
          title: Text(
            article.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          subtitle: Text(
            "${article.sourceName ?? "Nguồn không xác định"} • ${article.pubDate ?? "Không rõ thời gian"}",
            style: TextStyle(color: Colors.white70),
          ),
        ),
      ),
    );
  }
}
