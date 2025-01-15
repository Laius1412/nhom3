import 'dart:convert';
import 'package:http/http.dart' as http;

const String apiKey = '444b390a0amsh964e81611163fa9p112dffjsn8c81817d45aa';
const String apiHost = 'api-football-v1.p.rapidapi.com';
const List<int> leagueIds = [39, 140, 135, 78, 61]; // 5 giải đấu hàng đầu

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

  Match({
    required this.homeTeam,
    required this.awayTeam,
    required this.status,
    required this.result,
    required this.date,
    required this.homeTeamLogo,
    required this.awayTeamLogo,
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
    );
  }
}
