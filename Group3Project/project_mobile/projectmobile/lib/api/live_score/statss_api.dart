import 'package:http/http.dart' as http;
import 'package:projectmobile/Model/match_model/stats_model.dart';

Future<MatchStatisticsModel?> fetchMatchStatistics(int fixtureId) async {
  final url = Uri.parse(
      'https://api-football-v1.p.rapidapi.com/v3/fixtures/statistics?fixture=$fixtureId');

  final response = await http.get(
    url,
    headers: {
      'x-rapidapi-key':
          'a8b9270205mshe69813972780fc4p1bc17fjsn215c01f05e0b', // Thay bằng API Key của bạn
      'x-rapidapi-host': 'api-football-v1.p.rapidapi.com',
    },
  );

  if (response.statusCode == 200) {
    return matchStatisticsModelFromJson(response.body);
  } else {
    print('Lỗi khi gọi API: ${response.statusCode}');
    return null;
  }
}
