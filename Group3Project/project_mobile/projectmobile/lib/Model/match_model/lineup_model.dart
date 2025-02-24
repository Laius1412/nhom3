class Lineup {
  final Team team;
  final Coach coach;
  final String formation;
  final List<Player> startXI;
  final List<Player> substitutes;

  Lineup({
    required this.team,
    required this.coach,
    required this.formation,
    required this.startXI,
    required this.substitutes,
  });

  factory Lineup.fromJson(Map<String, dynamic> json) {
    return Lineup(
      team: Team.fromJson(json['team']),
      coach: Coach.fromJson(json['coach']),
      formation: json['formation'],
      startXI: (json['startXI'] as List)
          .map((p) => Player.fromJson(p['player']))
          .toList(),
      substitutes: (json['substitutes'] as List)
          .map((p) => Player.fromJson(p['player']))
          .toList(),
    );
  }
}

class Team {
  final String name;
  final String logo;

  Team({required this.name, required this.logo});

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      name: json['name'],
      logo: json['logo'],
    );
  }
}

class Coach {
  final String name;

  Coach({required this.name});

  factory Coach.fromJson(Map<String, dynamic> json) {
    return Coach(
      name: json['name'],
    );
  }
}

class Player {
  final String name;
  final int number;
  final String pos;
  final String? grid;

  Player({
    required this.name,
    required this.number,
    required this.pos,
    this.grid,
  });

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      name: json['name'],
      number: json['number'],
      pos: json['pos'],
      grid: json['grid'],
    );
  }
}
