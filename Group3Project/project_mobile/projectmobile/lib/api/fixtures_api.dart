import 'dart:convert';
import 'package:http/http.dart' as http;

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

class Match {
  final String homeTeam;
  final String awayTeam;
  final String status;
  final String result;
  final DateTime date;
  final String homeTeamLogo;
  final String awayTeamLogo;
  final int fixtureId;

  Match({
    required this.homeTeam,
    required this.awayTeam,
    required this.status,
    required this.result,
    required this.date,
    required this.homeTeamLogo,
    required this.awayTeamLogo,
    required this.fixtureId,
  });

  factory Match.fromJson(Map<String, dynamic> json) {
    return Match(
      homeTeam: json['teams']['home']['name'],
      awayTeam: json['teams']['away']['name'],
      status: json['fixture']['status']['short'],
      result: json['goals']['home'] != null && json['goals']['away'] != null
          ? '${json['goals']['home']} - ${json['goals']['away']}'
          : '',
      date: DateTime.parse(json['fixture']['date']),
      homeTeamLogo: json['teams']['home']['logo'],
      awayTeamLogo: json['teams']['away']['logo'],
      fixtureId: json['fixture']['id'],
    );
  }
}
