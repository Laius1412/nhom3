import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:projectmobile/Model/newsModel.dart';

class NewsApi {
  static const String apiKey = "pub_694807809029babdb10636b552dcf05ed11df";
  static const String baseUrl = "https://newsdata.io/api/1/news";

  static Future<List<NewsArticle>> fetchNews() async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl?apikey=$apiKey&language=vi&category=sports"),
      );

      if (response.statusCode == 200) {
        final String responseBody = utf8.decode(response.bodyBytes);
        final Map<String, dynamic> data = json.decode(responseBody);

        if (data["results"] == null || data["results"].isEmpty) {
          throw Exception("Không có dữ liệu tin tức");
        }
        List<dynamic> results = data["results"];

        // 🔹 Danh sách các nguồn tin muốn lấy
        List<String> allowedSources = [
          "thethao247.vn",
          "vnexpress.net",
          "bongda.com.vn",
          "24h.com.vn",
        ];

        // 🔍 Lọc bài báo từ danh sách nguồn tin (Kiểm tra null trước)
        List<NewsArticle> filteredNews = results
            .where((article) =>
                article["link"] != null &&
                allowedSources.any((source) =>
                    article["link"]!.toString().contains(source)))
            .map((json) => NewsArticle.fromJson(json))
            .toList();

        if (filteredNews.isEmpty) {
          throw Exception("Không có tin tức từ các nguồn được chọn.");
        }

        // 🔹 Giới hạn số lượng bài báo (Chỉ lấy tối đa 10 bài)
        return filteredNews.take(10).toList();
      } else {
        throw Exception("Lỗi kết nối API: Mã lỗi ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Lỗi khi tải tin tức: $e");
    }
  }
}
