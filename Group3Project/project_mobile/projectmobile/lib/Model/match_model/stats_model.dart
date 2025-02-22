import 'dart:convert';

// Hàm parse JSON thành model
MatchStatisticsModel matchStatisticsModelFromJson(String str) =>
    MatchStatisticsModel.fromJson(json.decode(str));

class MatchStatisticsModel {
  final List<TeamStatistics> response;

  MatchStatisticsModel({required this.response});

  factory MatchStatisticsModel.fromJson(Map<String, dynamic> json) =>
      MatchStatisticsModel(
        response: List<TeamStatistics>.from(
            json["response"].map((x) => TeamStatistics.fromJson(x))),
      );
}

class TeamStatistics {
  final Team team;
  final List<Statistic> statistics;

  TeamStatistics({required this.team, required this.statistics});

  factory TeamStatistics.fromJson(Map<String, dynamic> json) => TeamStatistics(
        team: Team.fromJson(json["team"]),
        statistics: List<Statistic>.from(
            json["statistics"].map((x) => Statistic.fromJson(x))),
      );
}

class Team {
  final int id;
  final String name;
  final String logo;

  Team({required this.id, required this.name, required this.logo});

  factory Team.fromJson(Map<String, dynamic> json) => Team(
        id: json["id"],
        name: json["name"],
        logo: json["logo"],
      );
}

class Statistic {
  final String type;
  final dynamic value;

  Statistic({required this.type, required this.value});

  factory Statistic.fromJson(Map<String, dynamic> json) => Statistic(
        type: json["type"],
        value: json["value"],
      );
}
