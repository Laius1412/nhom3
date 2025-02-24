import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:projectmobile/Model/match_model/lineup_model.dart';

Future<List<Lineup>> fetchMatchLineup(int fixtureId) async {
  final url = Uri.parse(
      'https://api-football-v1.p.rapidapi.com/v3/fixtures/lineups?fixture=$fixtureId');
  final response = await http.get(
    url,
    headers: {
      'x-rapidapi-key': '06d5f460ffmshae53777a47926b5p1a1e8djsn6d46ffb5ead1',
      'x-rapidapi-host': 'api-football-v1.p.rapidapi.com',
    },
  );
  if (response.statusCode == 200) {
    final data = json.decode(response.body)['response'] as List;
    return data.map((team) => Lineup.fromJson(team)).toList();
  } else {
    print('Lỗi khi gọi API Lineup: ${response.statusCode}');
    return [];
  }
}
