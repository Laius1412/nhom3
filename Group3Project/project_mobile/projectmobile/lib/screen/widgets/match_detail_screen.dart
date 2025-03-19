import 'package:flutter/material.dart';
import '/api/livescore_api.dart';
import '/model/livescore_model.dart';
import '/screen/widgets/tap/match_events_tab.dart';
import '/screen/widgets/tap/match_lineup_tab.dart';
import '/screen/widgets/tap/match_stats_tab.dart';

class MatchDetailScreen extends StatefulWidget {
  final LiveScore match;

  const MatchDetailScreen({Key? key, required this.match}) : super(key: key);

  @override
  _MatchDetailScreenState createState() => _MatchDetailScreenState();
}

class _MatchDetailScreenState extends State<MatchDetailScreen> {
  late Future<LiveScore> _matchDetails;

  @override
  void initState() {
    super.initState();
    _matchDetails = LiveScoreAPI.fetchMatchDetails(widget.match.fixtureId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.match.homeTeam} vs ${widget.match.awayTeam}",
            style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color.fromARGB(255, 0, 0, 0), Color.fromARGB(255, 77, 16, 28)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        color: Colors.black,
        child: FutureBuilder<LiveScore>(
          future: _matchDetails,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Lỗi khi tải dữ liệu", style: TextStyle(color: Colors.white)));
            } else if (!snapshot.hasData) {
              return Center(child: Text("Không có dữ liệu", style: TextStyle(color: Colors.white)));
            }

            final match = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Giải đấu: ${match.leagueName}",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  SizedBox(height: 10),
                  
                  /// Bố cục đối xứng
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.grey[600]!,
                        width: 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(child: _teamColumn(match.homeTeam, match.homeLogo)),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                "${match.homeGoals} - ${match.awayGoals}",
                                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                            ),
                            Expanded(child: _teamColumn(match.awayTeam, match.awayLogo)),
                          ],
                        ),
                        SizedBox(height: 16),
                        Text(
                          "⏳ ${match.elapsedTime}' - ${match.status}",
                          style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20),
                  DefaultTabController(
                    length: 3,
                    child: Column(
                      children: [
                        TabBar(
                          labelColor: Colors.white,
                          unselectedLabelColor: Colors.grey,
                          indicatorColor: Colors.red,
                          tabs: [
                            Tab(text: 'Sự kiện'),
                            Tab(text: 'Đội hình'),
                            Tab(text: 'Thống kê'),
                          ],
                        ),
                        Container(
                          height: 400,
                          child: TabBarView(
                            children: [
                              MatchEventsTab(match: match),
                              MatchLineupTab(fixtureId: match.fixtureId),
                              MatchStatsTab(fixtureId: match.fixtureId),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  /// Hàm hiển thị tên + logo đội bóng (cân đối chiều ngang)
  Widget _teamColumn(String teamName, String logoUrl) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.network(
          logoUrl,
          width: 50,
          height: 50,
          errorBuilder: (context, error, stackTrace) =>
              Icon(Icons.sports_soccer, size: 50, color: Colors.grey),
        ),
        SizedBox(height: 4),
        SizedBox(
          width: 100, // Giới hạn chiều rộng tên đội bóng
          child: Text(
            teamName,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      ],
    );
  }
}
