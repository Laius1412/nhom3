import 'package:flutter/material.dart';
import 'package:projectmobile/Model/match_model/lineup_model.dart';
import 'package:projectmobile/api/lineup_api.dart';

class LineupTab extends StatelessWidget {
  final int fixtureId;

  LineupTab({required this.fixtureId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Lineup>>(
      future: fetchMatchLineup(fixtureId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
              child: Text('Lỗi tải dữ liệu',
                  style: TextStyle(color: Colors.white)));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
              child: Text('Không có dữ liệu đội hình',
                  style: TextStyle(color: Colors.white)));
        }

        List<Lineup> lineups = snapshot.data!;
        return SingleChildScrollView(
          child: Column(
            children:
                lineups.map((lineup) => buildTeamSection(lineup)).toList(),
          ),
        );
      },
    );
  }

  Widget buildTeamSection(Lineup lineup) {
    return Column(
      children: [
        SizedBox(height: 20),
        // Logo + Tên đội
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(lineup.team.logo, width: 50, height: 50),
            SizedBox(width: 10),
            Text(
              lineup.team.name,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
        SizedBox(height: 10),

        // HLV + Formation
        Text(
          "HLV: ${lineup.coach.name} | Sơ đồ: ${lineup.formation}",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        SizedBox(height: 20),

        // Đội hình ra sân
        buildFormation(lineup.startXI),

        // Cầu thủ dự bị
        SizedBox(height: 20),
        Text("Cầu thủ dự bị",
            style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold)),
        buildSubstitutes(lineup.substitutes),

        SizedBox(height: 30),
      ],
    );
  }

  Widget buildFormation(List<Player> players) {
    Map<int, List<Player>> groupedPlayers = {};

    for (var player in players) {
      if (player.grid != null) {
        int row = int.parse(player.grid!.split(":")[0]);
        groupedPlayers.putIfAbsent(row, () => []).add(player);
      }
    }

    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.symmetric(horizontal: 20),
      height: 400,
      decoration: BoxDecoration(
        color: Colors.green[700],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: groupedPlayers.entries.map((entry) {
          int row = entry.key;
          List<Player> rowPlayers = entry.value;
          rowPlayers.sort((a, b) => int.parse(a.grid!.split(":")[1])
              .compareTo(int.parse(b.grid!.split(":")[1])));

          return Row(
            mainAxisAlignment: rowPlayers.length == 5
                ? MainAxisAlignment.spaceBetween
                : MainAxisAlignment.spaceEvenly,
            children: rowPlayers.reversed
                .map((player) => buildPlayerCircle(player))
                .toList(),
          );
        }).toList(),
      ),
    );
  }

  Widget buildPlayerCircle(Player player) {
    String shortName = shortenName(player.name);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 3),
      child: Column(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              "${player.number}",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 12),
            ),
          ),
          SizedBox(height: 5),
          Container(
            width: 60,
            child: Text(
              shortName,
              style: TextStyle(color: Colors.white, fontSize: 9),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }

  String shortenName(String name) {
    List<String> parts = name.split(" ");
    if (parts.length > 1) {
      return "${parts[0][0]}. ${parts.sublist(1).join(" ")}";
    }
    return name;
  }

  Widget buildSubstitutes(List<Player> substitutes) {
    return Column(
      children: substitutes.map((player) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "${player.number}. ",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 5),
              Expanded(
                child: Text(
                  "${shortenName(player.name)} - ${player.pos}",
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
