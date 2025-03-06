import 'package:flutter/material.dart';
import '/api/livescore_api.dart';
import '/model/livescore_model.dart';
import '/screen/widgets/match_detail_screen.dart'; // Import màn hình chi tiết trận đấu

class LiveMatchesSlider extends StatefulWidget {
  @override
  _LiveMatchesSliderState createState() => _LiveMatchesSliderState();
}

class _LiveMatchesSliderState extends State<LiveMatchesSlider> {
  late Future<List<LiveScore>> _liveMatches;

  @override
  void initState() {
    super.initState();
    _liveMatches = LiveScoreAPI.fetchLiveScores();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            "Trận đấu đang diễn ra",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 160,
          child: FutureBuilder<List<LiveScore>>(
            future: _liveMatches,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text("Lỗi tải dữ liệu", style: TextStyle(color: Colors.white)));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text("Không có trận đấu nào", style: TextStyle(color: Colors.white)));
              }

              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final match = snapshot.data![index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MatchDetailScreen(match: match),
                        ),
                      );
                    },
                    child: _buildMatchCard(match),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMatchCard(LiveScore match) {
    return Container(
      width: 280,
      margin: EdgeInsets.symmetric(horizontal: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            match.leagueName,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _teamColumn(match.homeTeam, match.homeLogo),
              Text(
                "${match.homeGoals} - ${match.awayGoals}",
                style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
              ),
              _teamColumn(match.awayTeam, match.awayLogo),
            ],
          ),
          SizedBox(height: 8),
          Text(
            "⏳ ${match.elapsedTime}'",
            style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _teamColumn(String teamName, String logoUrl) {
    return Column(
      children: [
        Image.network(logoUrl, width: 40, height: 40),
        SizedBox(height: 4),
        Text(
          teamName,
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
      ],
    );
  }
}
