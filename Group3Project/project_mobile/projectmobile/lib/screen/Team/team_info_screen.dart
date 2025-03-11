import 'package:flutter/material.dart';
import 'package:projectmobile/Model/team_model/team_infor_model.dart';
import 'package:projectmobile/api/team_infor_api.dart';
import 'package:projectmobile/Model/team_model/coach_model.dart';
import 'package:projectmobile/api/coachs_api.dart';
import 'package:projectmobile/api/team_stats_api.dart';
import 'package:projectmobile/Model/team_model/team_stats_model.dart';

class TeamInfoScreen extends StatefulWidget {
  final String teamId;
  final String league;
  final String season;

  const TeamInfoScreen({Key? key, required this.teamId, required this.league, required this.season}) : super(key: key);

  @override
  _TeamInfoScreenState createState() => _TeamInfoScreenState();
}

class _TeamInfoScreenState extends State<TeamInfoScreen> {
  late Future<TeamResponse> teamInfo;
  late Future<CoachResponse> coachInfo;
  late Future<TeamStatistics> teamStats;

  @override
  void initState() {
    super.initState();
    teamInfo = TeamInfoAPI().fetchTeamInfo(teamId: widget.teamId);
    coachInfo = CoachsApi().fetchCoachInfo(teamId: widget.teamId);
    teamStats = TeamStatsAPI().fetchTeamStatistics(league: widget.league, season: widget.season, teamId: widget.teamId);
  }
  Coach? getCurrentCoach(List<Coach> coaches, String teamId) {
    if (coaches.isEmpty) return null;

    // Lọc ra HLV có đội trùng khớp
    final coachesForTeam = coaches.where((coach) => 
        coach.team.id.toString() == teamId
    ).toList();

    // Lọc những HLV hiện tại (end == null)
    final activeCoaches = coachesForTeam.where((coach) =>
        coach.career.any((career) => career.end == null || career.end!.isEmpty)
    ).toList();

    if (activeCoaches.isNotEmpty) {
      // 🔥 Nếu có nhiều HLV, chọn người có start mới nhất
      activeCoaches.sort((a, b) {
        final aStart = a.career.first.start;
        final bStart = b.career.first.start;
        return bStart.compareTo(aStart); // Mới nhất lên đầu
      });

      return activeCoaches.first; // Chọn người có start mới nhất
    }
    coachesForTeam.sort((a, b) {
      final aEnd = a.career.last.end ?? ""; // Nếu null -> ""
      final bEnd = b.career.last.end ?? "";
      return bEnd.compareTo(aEnd); // Gần nhất lên đầu
    });

    return coachesForTeam.isNotEmpty ? coachesForTeam.first : null;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder<List<dynamic>>(
        future: Future.wait([teamInfo, coachInfo, teamStats]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                "Lỗi: ${snapshot.error}",
                style: TextStyle(color: Colors.white),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data![0].response.isEmpty) {
            return const Center(
              child: Text("Không có dữ liệu đội bóng", style: TextStyle(color: Colors.white)),
            );
          }

          final teamData = snapshot.data![0].response.first;
          final coachList = snapshot.data![1].response as List<Coach>;
          final coachData = getCurrentCoach(coachList, widget.teamId);
          final teamStatistics = snapshot.data![2] as TeamStatistics?;
          if (teamStatistics == null || teamStatistics.response == null) {
            return Center(
              child: Text("Không có dữ liệu thống kê", style: TextStyle(color: Colors.white)),
            );
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTeamInfo(teamData, coachData, teamStatistics),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTeamInfo(TeamData teamData, Coach? coachData, TeamStatistics teamStatistics) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle("Thông tin đội bóng"),
          const SizedBox(height: 20),
          _buildInfoCard([
            _buildInfoRow("Tên đội", teamData.team.name),
            _buildDivider(),
            _buildInfoRow("Ngày thành lập", teamData.team.founded.toString()),
            _buildDivider(),
            _buildInfoRow("Quốc gia", teamData.team.country),
            _buildDivider(),
            _buildInfoRow(
                "Huấn luyện viên",
                coachData != null ? coachData.name : "Không có dữ liệu"),
            _buildDivider(),
            _buildInfoRow(
                "Quốc tịch HLV", coachData?.nationality ?? "Không có dữ liệu"),
          ]),
          const SizedBox(height: 20),
          _buildSectionTitle("Sân vận động"),
          const SizedBox(height: 20),
          _buildInfoCard([
            _buildInfoRow("Tên sân", teamData.venue.name),
            _buildDivider(),
            _buildInfoRow("Sức chứa", teamData.venue.capacity.toString()),
            _buildDivider(),
            _buildInfoRow("Thành phố", teamData.venue.city),
          ]),
          const SizedBox(height: 20),
          _buildSectionTitle("Thống kê trận đấu"),
          teamStatistics != null
          ? _buildPhongDo(
              int.parse(teamStatistics.response!.fixtures!.wins!.total.toString()),
              int.parse(teamStatistics.response!.fixtures!.draws!.total.toString()),
              int.parse(teamStatistics.response!.fixtures!.loses!.total.toString()),
            )
          : Text("Không có dữ liệu phong độ", style: TextStyle(color: Colors.white)),

          

          const SizedBox(height: 20),
        ], 
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  Widget _buildInfoCard(List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: TextStyle(color: Colors.grey[400], fontSize: 16)),
        Text(value, style: TextStyle(color: Colors.white, fontSize: 16)),
      ],
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Divider(color: Colors.grey[700], thickness: 0.5),
    );
  }
  Widget _buildPhongDo(int wins, int draws, int losses) {
    int totalMatches = wins + draws + losses;

    double winRate = totalMatches > 0 ? wins / totalMatches : 0.0;
    double drawRate = totalMatches > 0 ? draws / totalMatches : 0.0;
    double lossRate = totalMatches > 0 ? losses / totalMatches : 0.0;

    return Card(
      color: Colors.grey[800],
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8),
            // Thanh hiển thị ba thông số
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Row(
                children: [
                  Expanded(
                    flex: (winRate * 100).round(),
                    child: Container(
                      height: 10,
                      color: Colors.green,
                    ),
                  ),
                  Expanded(
                    flex: (drawRate * 100).round(),
                    child: Container(
                      height: 10,
                      color: Colors.yellow,
                    ),
                  ),
                  Expanded(
                    flex: (lossRate * 100).round(),
                    child: Container(
                      height: 10,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            // Số liệu thống kê
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _statItem("Số trận", totalMatches.toString()),
                _statItem("Thắng", wins.toString(), Colors.green),
                _statItem("Hòa", draws.toString(), Colors.yellow),
                _statItem("Thua", losses.toString(), Colors.red),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _statItem(String label, String value, [Color? color]) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: color ?? Colors.black),
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(fontSize: 14, color: color ?? Colors.black),
        ),
      ],
    );
  }

}
