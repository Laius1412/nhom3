import 'package:intl/intl.dart';

class NewsArticle {
  final String articleId;
  final String title;
  final String link;
  final String? description;
  final String? content;
  final String? imageUrl;
  final String? pubDate;
  final String? sourceName;

  NewsArticle({
    required this.articleId,
    required this.title,
    required this.link,
    this.description,
    this.content,
    this.imageUrl,
    this.pubDate,
    this.sourceName,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      articleId: json['article_id'] ?? "",
      title: json['title'] ?? "Không có tiêu đề",
      link: json['link'] ?? "",
      description: json['description'] ?? "Không có mô tả",
      content: json['content'] ?? "Nội dung không khả dụng",
      imageUrl: json['image_url'], // API có thể trả về null
      pubDate: _formatDate(json['pubDate']),
      sourceName: json['source_name'] ?? "Nguồn không xác định",
    );
  }
  static String _formatDate(String? isoDate) {
    if (isoDate == null || isoDate.isEmpty) return "Không rõ thời gian";
    try {
      DateTime date = DateTime.parse(isoDate);
      return DateFormat("HH:mm, dd/MM/yyyy").format(date);
    } catch (e) {
      return ("Không rõ thời gian");
    }
  }
}
