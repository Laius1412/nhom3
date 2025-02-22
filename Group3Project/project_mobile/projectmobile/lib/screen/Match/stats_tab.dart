import 'package:flutter/material.dart';
import 'package:projectmobile/API/stats_api.dart';
import 'package:projectmobile/Model/match_model/stats_model.dart';

class StatsTab extends StatelessWidget {
  final int fixtureId;

  const StatsTab({Key? key, required this.fixtureId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<MatchStatisticsModel?>(
      future: fetchMatchStatistics(fixtureId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError || snapshot.data == null) {
          return const Center(child: Text("Lỗi khi tải dữ liệu"));
        }

        final stats = snapshot.data!.response;
        if (stats.length < 2) {
          return const Center(child: Text("Dữ liệu không hợp lệ"));
        }

        final team1 = stats[0];
        final team2 = stats[1];

        return Container(
          color: Colors.black,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildTeamHeader(team1.team.name, team2.team.name),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: team1.statistics.length,
                  itemBuilder: (context, index) {
                    return _buildStatRow(
                      team1.statistics[index].type,
                      team1.statistics[index].value,
                      team2.statistics[index].value,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTeamHeader(String team1, String team2) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(team1,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold)),
        const Text("VS",
            style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold)),
        Text(team2,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildStatRow(
      String statName, dynamic team1Value, dynamic team2Value) {
    double team1Ratio = (team1Value is int && team2Value is int)
        ? team1Value / (team1Value + team2Value)
        : 0.5;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(statName,
              style: const TextStyle(color: Colors.white, fontSize: 14)),
        ),
        Row(
          children: [
            Expanded(
              flex: (team1Ratio * 100).toInt(),
              child: Container(
                  height: 10, color: const Color.fromARGB(255, 200, 54, 1)),
            ),
            Expanded(
              flex: 100 - (team1Ratio * 100).toInt(),
              child: Container(height: 10, color: Colors.green),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("$team1Value",
                style: const TextStyle(color: Colors.white, fontSize: 12)),
            Text("$team2Value",
                style: const TextStyle(color: Colors.white, fontSize: 12)),
          ],
        ),
        const Divider(color: Colors.grey),
      ],
    );
  }
}
