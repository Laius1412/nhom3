import 'dart:convert';
import 'package:http/http.dart' as http;
import '/Model/match_model/lineup_model.dart';

class LineupAPI {
  static const String apiKey = 'a8b9270205mshe69813972780fc4p1bc17fjsn215c01f05e0b';
  static const String apiHost = 'api-football-v1.p.rapidapi.com';

  static Future<List<Lineup>?> fetchMatchLineup(int fixtureId) async {
    try {
      final url = Uri.parse('https://$apiHost/v3/fixtures/lineups?fixture=$fixtureId');
      print('📡 Gửi yêu cầu API: $url');

      final response = await http.get(url, headers: {
        'x-rapidapi-key': apiKey,
        'x-rapidapi-host': apiHost,
      });

      print('📩 Headers: ${json.encode({'x-rapidapi-key': apiKey, 'x-rapidapi-host': apiHost})}');
      print('📨 Phản hồi API: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['response'] is List) {
          return (data['response'] as List).map((team) => Lineup.fromJson(team)).toList();
        } else {
          print('❌ Cấu trúc JSON không đúng: ${response.body}');
          return null;
        }
      } else {
        print('❌ Lỗi API Lineup: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('❌ Lỗi khi gọi API Lineup: $e');
      return null;
    }
  }
}
