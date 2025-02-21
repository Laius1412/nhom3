import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:projectmobile/Model/match_model/fixtures_model.dart';

const String apiKey = '06d5f460ffmshae53777a47926b5p1a1e8djsn6d46ffb5ead1';
const String apiHost = 'api-football-v1.p.rapidapi.com';
const List<int> leagueIds = [2, 39, 140, 135, 78, 61]; // 5 giải đấu hàng đầu

// Mapping league IDs to their respective names
const Map<int, String> leagueNames = {
  2: 'UEFA Champions League',
  39: 'Premier League',
  140: 'La Liga',
  135: 'Serie A',
  78: 'Bundesliga',
  61: 'Ligue 1',
};

Future<Map<int, List<Match>>> fetchMatchesByDate(DateTime date) async {
  final response = await http.get(
    Uri.https(apiHost, '/v3/fixtures', {
      'date': date.toIso8601String().split('T')[0],
    }),
    headers: {
      'X-RapidAPI-Key': apiKey,
      'X-RapidAPI-Host': apiHost,
    },
  );

  if (response.statusCode == 200) {
    List<dynamic> matchesJson = jsonDecode(response.body)['response'];
    Map<int, List<Match>> matchesByLeague = {};

    for (var json in matchesJson) {
      int leagueId = json['league']['id'];
      if (leagueIds.contains(leagueId)) {
        matchesByLeague.putIfAbsent(leagueId, () => []);
        matchesByLeague[leagueId]!.add(Match.fromJson(json));
      }
    }

    // Sắp xếp các trận đấu theo thời gian
    matchesByLeague.forEach((key, matches) {
      matches.sort((a, b) => a.date.compareTo(b.date));
    });

    return matchesByLeague;
  } else {
    print('Failed to load matches: ${response.statusCode}');
    throw Exception('Failed to load matches');
  }
}
