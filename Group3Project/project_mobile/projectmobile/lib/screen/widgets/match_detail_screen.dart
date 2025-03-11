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
        title: Text("${widget.match.homeTeam} vs ${widget.match.awayTeam}", style: TextStyle(color: Colors.white)),
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _teamColumn(match.homeTeam, match.homeLogo),
                            Text(
                              "${match.homeGoals} - ${match.awayGoals}",
                              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                            _teamColumn(match.awayTeam, match.awayLogo),
                          ],
                        ),
                        SizedBox(height: 16),
                        Align(
                          alignment: Alignment.center,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Trạng thái: ${match.status}",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white),
                              ),
                              SizedBox(height: 8),
                              Text(
                                "Thời gian: ${match.elapsedTime}'",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
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
                          height: 300,
                          child: TabBarView(
                            children: [
                              MatchEventsTab(match: match),
                              MatchLineupTab(fixtureId: match.fixtureId),
                              MatchStatsTab(match: match),
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

  Widget _teamColumn(String teamName, String logoUrl) {
    return Column(
      children: [
        Image.network(logoUrl, width: 50, height: 50),
        SizedBox(height: 4),
        Text(teamName, style: TextStyle(fontSize: 16, color: Colors.white)),
      ],
    );
  }
}
