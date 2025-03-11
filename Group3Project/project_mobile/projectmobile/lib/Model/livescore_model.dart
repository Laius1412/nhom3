class LiveScore {
  final int fixtureId;
  final String leagueName;
  final String leagueLogo;
  final String homeTeam;
  final String homeLogo;
  final int homeGoals;
  final String awayTeam;
  final String awayLogo;
  final int awayGoals;
  final String status;
  final int elapsedTime;

  LiveScore({
    required this.fixtureId,
    required this.leagueName,
    required this.leagueLogo,
    required this.homeTeam,
    required this.homeLogo,
    required this.homeGoals,
    required this.awayTeam,
    required this.awayLogo,
    required this.awayGoals,
    required this.status,
    required this.elapsedTime,
  });

  factory LiveScore.fromJson(Map<String, dynamic> json) {
    return LiveScore(
      fixtureId: json['fixture']['id'],
      leagueName: json['league']['name'],
      leagueLogo: json['league']['logo'],
      homeTeam: json['teams']['home']['name'],
      homeLogo: json['teams']['home']['logo'],
      homeGoals: json['goals']['home'] ?? 0,
      awayTeam: json['teams']['away']['name'],
      awayLogo: json['teams']['away']['logo'],
      awayGoals: json['goals']['away'] ?? 0,
      status: json['fixture']['status']['long'],
      elapsedTime: json['fixture']['status']['elapsed'] ?? 0,
    );
  }
}
