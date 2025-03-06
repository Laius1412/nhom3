import 'dart:convert';
import 'package:http/http.dart' as http;
import '/model/match_model/event_model.dart'; // Sửa đường dẫn import cho đúng

class EventAPI {
  static const String apiKey = 'a8b9270205mshe69813972780fc4p1bc17fjsn215c01f05e0b';
  static const String apiUrl = 'https://api-football-v1.p.rapidapi.com/v3/fixtures/events?fixture=';

  static Future<List<MatchEvent>> fetchMatchEvents(int fixtureId) async {
    final response = await http.get(
      Uri.parse('$apiUrl$fixtureId'),
      headers: {
        'X-RapidAPI-Key': apiKey,
        'X-RapidAPI-Host': 'api-football-v1.p.rapidapi.com',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> eventsJson = jsonDecode(response.body)['response'];
      return eventsJson.map((json) => MatchEvent.fromJson(json)).toList();
    } else {
      throw Exception('Lỗi khi tải dữ liệu sự kiện trận đấu');
    }
  }
}
