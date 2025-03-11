class TeamStatistics {
    TeamStatistics({
        required this.teamStatisticsGet,
        required this.parameters,
        required this.errors,
        required this.results,
        required this.paging,
        required this.response,
    });

    final String? teamStatisticsGet;
    final Parameters? parameters;
    final List<dynamic> errors;
    final int? results;
    final Paging? paging;
    final Response? response;

    factory TeamStatistics.fromJson(Map<String, dynamic> json){ 
        return TeamStatistics(
            teamStatisticsGet: json["get"],
            parameters: json["parameters"] == null ? null : Parameters.fromJson(json["parameters"]),
            errors: json["errors"] == null ? [] : List<dynamic>.from(json["errors"]!.map((x) => x)),
            results: json["results"],
            paging: json["paging"] == null ? null : Paging.fromJson(json["paging"]),
            response: json["response"] == null ? null : Response.fromJson(json["response"]),
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
        required this.team,
    });

    final String? league;
    final String? season;
    final String? team;

    factory Parameters.fromJson(Map<String, dynamic> json){ 
        return Parameters(
            league: json["league"],
            season: json["season"],
            team: json["team"],
        );
    }

}

class Response {
    Response({
        required this.league,
        required this.team,
        required this.form,
        required this.fixtures,
        required this.goals,
        required this.biggest,
        required this.cleanSheet,
        required this.failedToScore,
        required this.penalty,
        required this.lineups,
        required this.cards,
    });

    final League? league;
    final Team? team;
    final String? form;
    final Fixtures? fixtures;
    final ResponseGoals? goals;
    final Biggest? biggest;
    final CleanSheet? cleanSheet;
    final CleanSheet? failedToScore;
    final Penalty? penalty;
    final List<Lineup> lineups;
    final Cards? cards;

    factory Response.fromJson(Map<String, dynamic> json){ 
        return Response(
            league: json["league"] == null ? null : League.fromJson(json["league"]),
            team: json["team"] == null ? null : Team.fromJson(json["team"]),
            form: json["form"],
            fixtures: json["fixtures"] == null ? null : Fixtures.fromJson(json["fixtures"]),
            goals: json["goals"] == null ? null : ResponseGoals.fromJson(json["goals"]),
            biggest: json["biggest"] == null ? null : Biggest.fromJson(json["biggest"]),
            cleanSheet: json["clean_sheet"] == null ? null : CleanSheet.fromJson(json["clean_sheet"]),
            failedToScore: json["failed_to_score"] == null ? null : CleanSheet.fromJson(json["failed_to_score"]),
            penalty: json["penalty"] == null ? null : Penalty.fromJson(json["penalty"]),
            lineups: json["lineups"] == null ? [] : List<Lineup>.from(json["lineups"]!.map((x) => Lineup.fromJson(x))),
            cards: json["cards"] == null ? null : Cards.fromJson(json["cards"]),
        );
    }

}

class Biggest {
    Biggest({
        required this.streak,
        required this.wins,
        required this.loses,
        required this.goals,
    });

    final Streak? streak;
    final Loses? wins;
    final Loses? loses;
    final BiggestGoals? goals;

    factory Biggest.fromJson(Map<String, dynamic> json){ 
        return Biggest(
            streak: json["streak"] == null ? null : Streak.fromJson(json["streak"]),
            wins: json["wins"] == null ? null : Loses.fromJson(json["wins"]),
            loses: json["loses"] == null ? null : Loses.fromJson(json["loses"]),
            goals: json["goals"] == null ? null : BiggestGoals.fromJson(json["goals"]),
        );
    }

}

class BiggestGoals {
    BiggestGoals({
        required this.goalsFor,
        required this.against,
    });

    final PurpleAgainst? goalsFor;
    final PurpleAgainst? against;

    factory BiggestGoals.fromJson(Map<String, dynamic> json){ 
        return BiggestGoals(
            goalsFor: json["for"] == null ? null : PurpleAgainst.fromJson(json["for"]),
            against: json["against"] == null ? null : PurpleAgainst.fromJson(json["against"]),
        );
    }

}

class PurpleAgainst {
    PurpleAgainst({
        required this.home,
        required this.away,
    });

    final int? home;
    final int? away;

    factory PurpleAgainst.fromJson(Map<String, dynamic> json){ 
        return PurpleAgainst(
            home: json["home"],
            away: json["away"],
        );
    }

}

class Loses {
    Loses({
        required this.home,
        required this.away,
    });

    final String? home;
    final String? away;

    factory Loses.fromJson(Map<String, dynamic> json){ 
        return Loses(
            home: json["home"],
            away: json["away"],
        );
    }

}

class Streak {
    Streak({
        required this.wins,
        required this.draws,
        required this.loses,
    });

    final int? wins;
    final int? draws;
    final int? loses;

    factory Streak.fromJson(Map<String, dynamic> json){ 
        return Streak(
            wins: json["wins"],
            draws: json["draws"],
            loses: json["loses"],
        );
    }

}

class Cards {
    Cards({
        required this.yellow,
        required this.red,
    });

    final Map<String, Missed> yellow;
    final Map<String, Missed> red;

    factory Cards.fromJson(Map<String, dynamic> json){ 
        return Cards(
            yellow: Map.from(json["yellow"]).map((k, v) => MapEntry<String, Missed>(k, Missed.fromJson(v))),
            red: Map.from(json["red"]).map((k, v) => MapEntry<String, Missed>(k, Missed.fromJson(v))),
        );
    }

}

class Missed {
    Missed({
        required this.total,
        required this.percentage,
    });

    final int? total;
    final String? percentage;

    factory Missed.fromJson(Map<String, dynamic> json){ 
        return Missed(
            total: json["total"],
            percentage: json["percentage"],
        );
    }

}

class CleanSheet {
    CleanSheet({
        required this.home,
        required this.away,
        required this.total,
    });

    final int? home;
    final int? away;
    final int? total;

    factory CleanSheet.fromJson(Map<String, dynamic> json){ 
        return CleanSheet(
            home: json["home"],
            away: json["away"],
            total: json["total"],
        );
    }

}

class Fixtures {
    Fixtures({
        required this.played,
        required this.wins,
        required this.draws,
        required this.loses,
    });

    final CleanSheet? played;
    final CleanSheet? wins;
    final CleanSheet? draws;
    final CleanSheet? loses;

    factory Fixtures.fromJson(Map<String, dynamic> json){ 
        return Fixtures(
            played: json["played"] == null ? null : CleanSheet.fromJson(json["played"]),
            wins: json["wins"] == null ? null : CleanSheet.fromJson(json["wins"]),
            draws: json["draws"] == null ? null : CleanSheet.fromJson(json["draws"]),
            loses: json["loses"] == null ? null : CleanSheet.fromJson(json["loses"]),
        );
    }

}

class ResponseGoals {
    ResponseGoals({
        required this.goalsFor,
        required this.against,
    });

    final FluffyAgainst? goalsFor;
    final FluffyAgainst? against;

    factory ResponseGoals.fromJson(Map<String, dynamic> json){ 
        return ResponseGoals(
            goalsFor: json["for"] == null ? null : FluffyAgainst.fromJson(json["for"]),
            against: json["against"] == null ? null : FluffyAgainst.fromJson(json["against"]),
        );
    }

}

class FluffyAgainst {
    FluffyAgainst({
        required this.total,
        required this.average,
        required this.minute,
        required this.underOver,
    });

    final CleanSheet? total;
    final Average? average;
    final Map<String, Missed> minute;
    final Map<String, UnderOver> underOver;

    factory FluffyAgainst.fromJson(Map<String, dynamic> json){ 
        return FluffyAgainst(
            total: json["total"] == null ? null : CleanSheet.fromJson(json["total"]),
            average: json["average"] == null ? null : Average.fromJson(json["average"]),
            minute: Map.from(json["minute"]).map((k, v) => MapEntry<String, Missed>(k, Missed.fromJson(v))),
            underOver: Map.from(json["under_over"]).map((k, v) => MapEntry<String, UnderOver>(k, UnderOver.fromJson(v))),
        );
    }

}

class Average {
    Average({
        required this.home,
        required this.away,
        required this.total,
    });

    final String? home;
    final String? away;
    final String? total;

    factory Average.fromJson(Map<String, dynamic> json){ 
        return Average(
            home: json["home"],
            away: json["away"],
            total: json["total"],
        );
    }

}

class UnderOver {
    UnderOver({
        required this.over,
        required this.under,
    });

    final int? over;
    final int? under;

    factory UnderOver.fromJson(Map<String, dynamic> json){ 
        return UnderOver(
            over: json["over"],
            under: json["under"],
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
    });

    final int? id;
    final String? name;
    final String? country;
    final String? logo;
    final String? flag;
    final int? season;

    factory League.fromJson(Map<String, dynamic> json){ 
        return League(
            id: json["id"],
            name: json["name"],
            country: json["country"],
            logo: json["logo"],
            flag: json["flag"],
            season: json["season"],
        );
    }

}

class Lineup {
    Lineup({
        required this.formation,
        required this.played,
    });

    final String? formation;
    final int? played;

    factory Lineup.fromJson(Map<String, dynamic> json){ 
        return Lineup(
            formation: json["formation"],
            played: json["played"],
        );
    }

}

class Penalty {
    Penalty({
        required this.scored,
        required this.missed,
        required this.total,
    });

    final Missed? scored;
    final Missed? missed;
    final int? total;

    factory Penalty.fromJson(Map<String, dynamic> json){ 
        return Penalty(
            scored: json["scored"] == null ? null : Missed.fromJson(json["scored"]),
            missed: json["missed"] == null ? null : Missed.fromJson(json["missed"]),
            total: json["total"],
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
