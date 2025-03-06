import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/livescore_model.dart';

class LiveScoreAPI {
  static const String apiKey = "a8b9270205mshe69813972780fc4p1bc17fjsn215c01f05e0b";
  static const String apiUrl = "https://api-football-v1.p.rapidapi.com/v3/fixtures?live=all";

  static Future<List<LiveScore>> fetchLiveScores() async {
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        "x-rapidapi-key": apiKey,
        "x-rapidapi-host": "api-football-v1.p.rapidapi.com",
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> matches = data["response"];

      return matches.map((json) => LiveScore.fromJson(json)).toList();
    } else {
      throw Exception("Lỗi khi lấy dữ liệu livescore");
    }
  }
  static Future<LiveScore> fetchMatchDetails(int fixtureId) async {
  final String apiUrl = "https://api-football-v1.p.rapidapi.com/v3/fixtures?id=$fixtureId";

  final response = await http.get(
    Uri.parse(apiUrl),
    headers: {
      "x-rapidapi-key": apiKey,
      "x-rapidapi-host": "api-football-v1.p.rapidapi.com",
    },
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);
    final List<dynamic> matches = data["response"];

    if (matches.isNotEmpty) {
      return LiveScore.fromJson(matches[0]);
    } else {
      throw Exception("Không tìm thấy dữ liệu trận đấu");
    }
  } else {
    throw Exception("Lỗi khi lấy dữ liệu trận đấu");
  }
}

}
