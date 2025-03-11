import 'dart:convert';

class TeamResponse {
  final String get;
  final Map<String, String> parameters;
  final List<dynamic> errors;
  final int results;
  final Paging paging;
  final List<TeamData> response;

  TeamResponse({
    required this.get,
    required this.parameters,
    required this.errors,
    required this.results,
    required this.paging,
    required this.response,
  });

  factory TeamResponse.fromJson(String str) =>
      TeamResponse.fromMap(json.decode(str));

  factory TeamResponse.fromMap(Map<String, dynamic> json) => TeamResponse(
        get: json["get"],
        parameters: Map<String, String>.from(json["parameters"]),
        errors: List<dynamic>.from(json["errors"]),
        results: json["results"],
        paging: Paging.fromMap(json["paging"]),
        response:
            List<TeamData>.from(json["response"].map((x) => TeamData.fromMap(x))),
      );
}

class Paging {
  final int current;
  final int total;

  Paging({
    required this.current,
    required this.total,
  });

  factory Paging.fromMap(Map<String, dynamic> json) => Paging(
        current: json["current"],
        total: json["total"],
      );
}

class TeamData {
  final Team team;
  final Venue venue;

  TeamData({
    required this.team,
    required this.venue,
  });

  factory TeamData.fromMap(Map<String, dynamic> json) => TeamData(
        team: Team.fromMap(json["team"]),
        venue: Venue.fromMap(json["venue"]),
      );
}

class Team {
  final int id;
  final String name;
  final String code;
  final String country;
  final int founded;
  final bool national;
  final String logo;

  Team({
    required this.id,
    required this.name,
    required this.code,
    required this.country,
    required this.founded,
    required this.national,
    required this.logo,
  });

  factory Team.fromMap(Map<String, dynamic> json) => Team(
        id: json["id"],
        name: json["name"],
        code: json["code"],
        country: json["country"],
        founded: json["founded"],
        national: json["national"],
        logo: json["logo"],
      );
}

class Venue {
  final int id;
  final String name;
  final String address;
  final String city;
  final int capacity;
  final String surface;
  final String image;

  Venue({
    required this.id,
    required this.name,
    required this.address,
    required this.city,
    required this.capacity,
    required this.surface,
    required this.image,
  });

  factory Venue.fromMap(Map<String, dynamic> json) => Venue(
        id: json["id"],
        name: json["name"],
        address: json["address"],
        city: json["city"],
        capacity: json["capacity"],
        surface: json["surface"],
        image: json["image"],
      );
}
