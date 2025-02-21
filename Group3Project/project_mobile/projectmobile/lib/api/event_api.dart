import 'dart:convert';
import 'package:http/http.dart' as http;

const String apiKey = '06d5f460ffmshae53777a47926b5p1a1e8djsn6d46ffb5ead1';
const String apiHost = 'api-football-v1.p.rapidapi.com';

class MatchEvent {
  final int time;
  final String type;
  final String detail;
  final String player;
  final String? assist;
  final int teamId;
  final String teamName;

  MatchEvent({
    required this.time,
    required this.type,
    required this.detail,
    required this.player,
    this.assist,
    required this.teamId,
    required this.teamName,
  });

  factory MatchEvent.fromJson(Map<String, dynamic> json) {
    return MatchEvent(
      time: json['time']['elapsed'],
      type: json['type'],
      detail: json['detail'],
      player: json['player']['name'],
      assist: json['assist'] != null ? json['assist']['name'] : null,
      teamId: json['team']['id'],
      teamName: json['team']['name'],
    );
  }
}

Future<Map<int, List<MatchEvent>>> fetchMatchEvents(int fixtureId) async {
  final response = await http.get(
    Uri.https(apiHost, '/v3/fixtures/events', {
      'fixture': fixtureId.toString(),
    }),
    headers: {
      'X-RapidAPI-Key': apiKey,
      'X-RapidAPI-Host': apiHost,
    },
  );

  if (response.statusCode == 200) {
    List<dynamic> eventsJson = jsonDecode(response.body)['response'];
    Map<int, List<MatchEvent>> eventsByTeam = {};

    for (var json in eventsJson) {
      MatchEvent event = MatchEvent.fromJson(json);
      eventsByTeam.putIfAbsent(event.teamId, () => []);
      eventsByTeam[event.teamId]!.add(event);
    }

    return eventsByTeam;
  } else {
    print('Failed to load match events: ${response.statusCode}');
    throw Exception('Failed to load match events');
  }
}
