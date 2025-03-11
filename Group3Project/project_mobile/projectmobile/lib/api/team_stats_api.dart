import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:projectmobile/Model/team_model/team_stats_model.dart';

class TeamStatsAPI {
  static const String apiKey = '444b390a0amsh964e81611163fa9p112dffjsn8c81817d45aa';
  static const String apiHost = 'api-football-v1.p.rapidapi.com';
  final String baseUrl = 'https://$apiHost/v3/teams/statistics';

  /// Fetch team statistics based on league, season, and team ID
  Future<TeamStatistics> fetchTeamStatistics({
    required String league,
    required String season,
    required String teamId,
  }) async {
    final Uri url = Uri.parse('$baseUrl?league=$league&season=$season&team=$teamId');

    final http.Response response = await http.get(
      url,
      headers: {
        'X-RapidAPI-Key': apiKey,
        'X-RapidAPI-Host': apiHost,
      },
    );

    if (response.statusCode == 200) {
      return TeamStatistics.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load team statistics');
    }
  }
}