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
