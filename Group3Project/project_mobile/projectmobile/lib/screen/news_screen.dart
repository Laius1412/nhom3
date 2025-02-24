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
        title: Text(
          "Tin tức thể thao",
          style: TextStyle(color: Colors.white),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 0, 0, 0),
                Color.fromARGB(255, 77, 16, 28)
              ],
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
              ...otherArticles
                  .map((article) => _buildNewsItem(article))
                  .toList(),
            ],
          );
        },
      ),
    );
  }
  // tin nổi bật
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
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      padding: EdgeInsets.all(10), // Tăng padding để box thoáng hơn
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey[850],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Phần nội dung (chiếm 1 phần)
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10), // Khoảng cách trên 10
                // Dòng "Thông tin nổi bật"
                Text(
                  "Thông tin nổi bật",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 5), // Khoảng cách với tiêu đề bài viết
                Text(
                  article.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                // Ngày giờ đăng
                Row(
                  children: [
                    Icon(Icons.access_time, color: Colors.white70, size: 12),
                    SizedBox(width: 4),
                    Text(
                      article.pubDate ?? "Không rõ thời gian",
                      style: TextStyle(color: Colors.white70, fontSize: 10),
                    ),
                  ],
                ),
                SizedBox(height: 6),
                // Nguồn tin
                Row(
                  children: [
                    Icon(Icons.newspaper, color: Colors.white70, size: 12),
                    SizedBox(width: 4),
                    Text(
                      article.sourceName ?? "Nguồn không xác định",
                      style: TextStyle(color: Colors.white70, fontSize: 10),
                    ),
                  ],
                ),
                SizedBox(height: 6),
                // Số bình luận và số lượt xem (tĩnh)
                Row(
                  children: [
                    Icon(Icons.comment, color: Colors.white70, size: 12),
                    SizedBox(width: 4),
                    Text(
                      "15", // Giá trị cố định
                      style: TextStyle(color: Colors.white70, fontSize: 10),
                    ),
                    SizedBox(width: 10),
                    Icon(Icons.remove_red_eye, color: Colors.white70, size: 12),
                    SizedBox(width: 4),
                    Text(
                      "170 View", // Giá trị cố định
                      style: TextStyle(color: Colors.white70, fontSize: 10),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: 15),
          // Phần ảnh (chiếm 2 phần)
          Expanded(
            flex: 2,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: article.imageUrl != null && article.imageUrl!.isNotEmpty
                  ? Image.network(
                      article.imageUrl!,
                      width: double.infinity,
                      height: 180,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: double.infinity,
                          height: 150,
                          color: Colors.grey,
                          child: Icon(Icons.broken_image, size: 60, color: Colors.white),
                        );
                      },
                    )
                  : Container(
                      width: double.infinity,
                      height: 150,
                      color: Colors.grey,
                      child: Icon(Icons.image_not_supported, size: 60, color: Colors.white),
                    ),
            ),
          ),
        ],
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
                        return Icon(Icons.broken_image,
                            size: 95, color: Colors.grey);
                      },
                    )
                  : Icon(Icons.image_not_supported,
                      size: 95, color: Colors.grey),
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
