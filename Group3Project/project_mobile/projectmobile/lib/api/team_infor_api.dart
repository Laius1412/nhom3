import 'package:http/http.dart' as http;
import 'package:projectmobile/Model/team_model/team_infor_model.dart';

class TeamInfoAPI {
  static const apiKey = '444b390a0amsh964e81611163fa9p112dffjsn8c81817d45aa';
  static const apiHost = 'api-football-v1.p.rapidapi.com';
  final String baseUrl = 'https://$apiHost/v3/teams';

  /// Fetch team info based on team ID
  Future<TeamResponse> fetchTeamInfo({required String teamId}) async {
    final url = Uri.parse('$baseUrl?id=$teamId');

    final response = await http.get(
      url,
      headers: {
        'X-RapidAPI-Key': apiKey,
        'X-RapidAPI-Host': apiHost,
      },
    );

    if (response.statusCode == 200) {
      return TeamResponse.fromJson(response.body);
    } else {
      throw Exception('Failed to load team info');
    }
  }
}
