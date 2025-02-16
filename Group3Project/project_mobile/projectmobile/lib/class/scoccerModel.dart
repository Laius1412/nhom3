class SoccerMatch {
    SoccerMatch({
        required this.soccerMatchGet,
        required this.parameters,
        required this.errors,
        required this.results,
        required this.paging,
        required this.response,
    });

    final String? soccerMatchGet;
    final Parameters? parameters;
    final List<dynamic> errors;
    final int? results;
    final Paging? paging;
    final List<Response> response;

    factory SoccerMatch.fromJson(Map<String, dynamic> json){ 
        return SoccerMatch(
            soccerMatchGet: json["get"],
            parameters: json["parameters"] == null ? null : Parameters.fromJson(json["parameters"]),
            errors: json["errors"] == null ? [] : List<dynamic>.from(json["errors"]!.map((x) => x)),
            results: json["results"],
            paging: json["paging"] == null ? null : Paging.fromJson(json["paging"]),
            response: json["response"] == null ? [] : List<Response>.from(json["response"]!.map((x) => Response.fromJson(x))),
        );
    }

}

class Paging {
    Paging({
        required this.current,
        required this.total,
    });

    final int? current;
    final int? total;

    factory Paging.fromJson(Map<String, dynamic> json){ 
        return Paging(
            current: json["current"],
            total: json["total"],
        );
    }

}

class Parameters {
    Parameters({
        required this.league,
        required this.season,
    });

    final String? league;
    final String? season;

    factory Parameters.fromJson(Map<String, dynamic> json){ 
        return Parameters(
            league: json["league"],
            season: json["season"],
        );
    }

}

class Response {
    Response({
        required this.league,
    });

    final League? league;

    factory Response.fromJson(Map<String, dynamic> json){ 
        return Response(
            league: json["league"] == null ? null : League.fromJson(json["league"]),
        );
    }

}

class League {
    League({
        required this.id,
        required this.name,
        required this.country,
        required this.logo,
        required this.flag,
        required this.season,
        required this.standings,
    });

    final int? id;
    final String? name;
    final String? country;
    final String? logo;
    final String? flag;
    final int? season;
    final List<List<Standing>> standings;

    factory League.fromJson(Map<String, dynamic> json){ 
        return League(
            id: json["id"],
            name: json["name"],
            country: json["country"],
            logo: json["logo"],
            flag: json["flag"],
            season: json["season"],
            standings: json["standings"] == null ? [] : List<List<Standing>>.from(json["standings"]!.map((x) => x == null ? [] : List<Standing>.from(x!.map((x) => Standing.fromJson(x))))),
        );
    }

}

class Standing {
    Standing({
        required this.rank,
        required this.team,
        required this.points,
        required this.goalsDiff,
        required this.group,
        required this.form,
        required this.status,
        required this.description,
        required this.all,
        required this.home,
        required this.away,
        required this.update,
    });

    final int? rank;
    final Team? team;
    final int? points;
    final int? goalsDiff;
    final String? group;
    final String? form;
    final String? status;
    final String? description;
    final All? all;
    final All? home;
    final All? away;
    final DateTime? update;

    factory Standing.fromJson(Map<String, dynamic> json){ 
        return Standing(
            rank: json["rank"],
            team: json["team"] == null ? null : Team.fromJson(json["team"]),
            points: json["points"],
            goalsDiff: json["goalsDiff"],
            group: json["group"],
            form: json["form"],
            status: json["status"],
            description: json["description"],
            all: json["all"] == null ? null : All.fromJson(json["all"]),
            home: json["home"] == null ? null : All.fromJson(json["home"]),
            away: json["away"] == null ? null : All.fromJson(json["away"]),
            update: DateTime.tryParse(json["update"] ?? ""),
        );
    }

}

class All {
    All({
        required this.played,
        required this.win,
        required this.draw,
        required this.lose,
        required this.goals,
    });

    final int? played;
    final int? win;
    final int? draw;
    final int? lose;
    final Goals? goals;

    factory All.fromJson(Map<String, dynamic> json){ 
        return All(
            played: json["played"],
            win: json["win"],
            draw: json["draw"],
            lose: json["lose"],
            goals: json["goals"] == null ? null : Goals.fromJson(json["goals"]),
        );
    }

}

class Goals {
    Goals({
        required this.goalsFor,
        required this.against,
    });

    final int? goalsFor;
    final int? against;

    factory Goals.fromJson(Map<String, dynamic> json){ 
        return Goals(
            goalsFor: json["for"],
            against: json["against"],
        );
    }

}

class Team {
    Team({
        required this.id,
        required this.name,
        required this.logo,
    });

    final int? id;
    final String? name;
    final String? logo;

    factory Team.fromJson(Map<String, dynamic> json){ 
        return Team(
            id: json["id"],
            name: json["name"],
            logo: json["logo"],
        );
    }

}
