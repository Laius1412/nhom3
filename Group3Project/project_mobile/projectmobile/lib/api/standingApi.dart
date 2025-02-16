// import 'dart:convert';
// import 'package:http/http.dart' as http;

// class StandingEPL {
//   static const apiKey = '444b390a0amsh964e81611163fa9p112dffjsn8c81817d45aa';
//   static const apiHost = 'api-football-v1.p.rapidapi.com';
//   final baseUrl = 'https://$apiHost/v3/standings';

//   /// Fetch standings based on league and season
//   Future<Map<String, dynamic>> fetchStandings({
//     required String leagueId,
//     required String seasonId,
//   }) async {
//     final url = Uri.parse('$baseUrl?league=$leagueId&season=$seasonId');

//     final response = await http.get(
//       url,
//       headers: {
//         'X-RapidAPI-Key': apiKey,
//         'X-RapidAPI-Host': apiHost,
//       },
//     );

//     if (response.statusCode == 200) {
//       return json.decode(response.body); // Return decoded JSON data
//     } else {
//       throw Exception('Failed to load standings');
//     }
//   }
// }
