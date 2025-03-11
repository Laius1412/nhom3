import 'package:http/http.dart' as http;
import 'package:projectmobile/Model/team_model/coach_model.dart';

class CoachsApi {
  static const apiKey = '444b390a0amsh964e81611163fa9p112dffjsn8c81817d45aa';
  static const apiHost = 'api-football-v1.p.rapidapi.com';
  final String baseUrl = 'https://$apiHost/v3/coachs';

  Future<CoachResponse> fetchCoachInfo({required String teamId}) async {
    final url = Uri.parse('$baseUrl?team=$teamId');

    final response = await http.get(
      url,
      headers: {
        'X-RapidAPI-Key': apiKey,
        'X-RapidAPI-Host': apiHost,
      },
    );

    if (response.statusCode == 200) {
      return CoachResponse.fromJson(response.body);
    } else {
      throw Exception('Lỗi khi tải dữ liệu huấn luyện viên');
    }
  }
}
