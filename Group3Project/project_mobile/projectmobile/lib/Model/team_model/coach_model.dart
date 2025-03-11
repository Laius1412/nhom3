import 'dart:convert';

class CoachResponse {
  final String? get;
  final Map<String, dynamic> parameters;
  final List<dynamic> errors;
  final int? results;
  final Paging paging;
  final List<Coach> response;

  CoachResponse({
    required this.get,
    required this.parameters,
    required this.errors,
    required this.results,
    required this.paging,
    required this.response,
  });

  factory CoachResponse.fromJson(String source) =>
      CoachResponse.fromMap(json.decode(source));

  factory CoachResponse.fromMap(Map<String, dynamic> map) {
    return CoachResponse(
      get: map['get'],
      parameters: Map<String, dynamic>.from(map['parameters']),
      errors: List<dynamic>.from(map['errors']),
      results: map['results'],
      paging: Paging.fromMap(map['paging']),
      response: List<Coach>.from(map['response'].map((x) => Coach.fromMap(x))),
    );
  }
}

class Paging {
  final int? current;
  final int? total;

  Paging({required this.current, required this.total});

  factory Paging.fromMap(Map<String, dynamic> map) {
    return Paging(
      current: map['current'],
      total: map['total'],
    );
  }
}

class Coach {
  final int? id;
  final String name;
  final String firstname;
  final String lastname;
  final int? age;
  final Birth? birth;
  final String? nationality;
  final Team team;
  final List<Career> career;

  Coach({
    required this.id,
    required this.name,
    required this.firstname,
    required this.lastname,
    this.age,
    required this.birth,
    required this.nationality,
    required this.team,
    required this.career,
  });

  factory Coach.fromMap(Map<String, dynamic> map) {
    return Coach(
      id: map['id'],
      name: map['name'],
      firstname: map['firstname'],
      lastname: map['lastname'],
      age: map['age'],
      birth: Birth.fromMap(map['birth']),
      nationality: map['nationality'],
      team: Team.fromMap(map['team']),
      career: List<Career>.from(map['career'].map((x) => Career.fromMap(x))),
    );
  }
}

class Birth {
  final String? date;
  final String? place;
  final String? country;

  Birth({this.date, this.place, this.country});

  factory Birth.fromMap(Map<String, dynamic> map) {
    return Birth(
      date: map['date'] ?? "Không rõ ngày sinh",
      place: map['place'] ?? "Không rõ nơi sinh",
      country: map['country'] ?? "Không rõ quốc gia",
    );
  }
}


class Team {
  final int? id;
  final String name;
  final String logo;

  Team({this.id, required this.name, required this.logo});

  factory Team.fromMap(Map<String, dynamic> map) {
    return Team(
      id: map['id'],
      name: map['name'] ?? "Không có tên đội",
      logo: map['logo'] ?? "",
    );
  }
}


class Career {
  final Team team;
  final String start;
  final String? end;

  Career({required this.team, required this.start, this.end});

  factory Career.fromMap(Map<String, dynamic> map) {
    return Career(
      team: Team.fromMap(map['team']),
      start: map['start'] ?? "Không rõ ngày bắt đầu",
      end: map['end'], // Cho phép null
    );
  }
}
