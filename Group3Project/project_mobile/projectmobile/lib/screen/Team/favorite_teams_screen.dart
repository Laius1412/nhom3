import 'package:flutter/material.dart';
import 'package:projectmobile/screen/Team/team_screen.dart';
import 'package:projectmobile/services/favorite_team_storage.dart';
import 'package:projectmobile/Model/scoccerModel.dart';


class FavoriteTeamsScreen extends StatefulWidget {
  @override
  _FavoriteTeamsScreenState createState() => _FavoriteTeamsScreenState();
}

class _FavoriteTeamsScreenState extends State<FavoriteTeamsScreen> {
  List<Map<String, dynamic>> favoriteTeams = [];

  @override
  void initState() {
    super.initState();
    _loadFavoriteTeams();
  }

  Future<void> _loadFavoriteTeams() async {
    List<Map<String, dynamic>> teams = await FavoriteTeamStorage.getFavoriteTeams();
    setState(() {
      favoriteTeams = teams;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color.fromARGB(255, 0, 0, 0), Color.fromARGB(255, 77, 16, 28)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: const Text("Đội bóng yêu thích",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 30,
            ),
        )
      ),
      body: favoriteTeams.isEmpty
          ? const Center(child: Text("Không có đội bóng yêu thích"))
          : Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
                itemCount: favoriteTeams.length,
                itemBuilder: (context, index) {
                  var team = favoriteTeams[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[800], // Màu nền
                        borderRadius: BorderRadius.circular(10), // Bo góc
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),

                      child: ListTile(
                        leading: Image.network(team["logo"]!, width: 50, height: 50, errorBuilder: (context, error, stackTrace) => Icon(Icons.image)),
                        title: Text(
                          team["name"]!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                        onTap: () {
                          if (team["id"] != null && team["name"] != null && team["logo"] != null &&
                              team["leagueId"] != null && team["seasonYear"] != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TeamDetailsScreen(
                                  team: Standing(
                                    rank: 0, // Giá trị mặc định
                                    team: Team(
                                      id: int.tryParse(team["id"].toString()) ?? 0,
                                      name: team["name"].toString(),
                                      logo: team["logo"].toString(),
                                    ),
                                    points: 0, // Giá trị mặc định
                                    goalsDiff: 0, // Giá trị mặc định
                                    group: '', // Giá trị mặc định
                                    form: '', // Giá trị mặc định
                                    status: '', // Giá trị mặc định
                                    description: '', // Giá trị mặc định
                                    all: All(
                                      played: 0,
                                      win: 0,
                                      draw: 0,
                                      lose: 0,
                                      goals: Goals(
                                        goalsFor: 0,
                                        against: 0,
                                      ),
                                    ),
                                    home: All(
                                      played: 0,
                                      win: 0,
                                      draw: 0,
                                      lose: 0,
                                      goals: Goals(
                                        goalsFor: 0,
                                        against: 0,
                                      ),
                                    ),
                                    away: All(
                                      played: 0,
                                      win: 0,
                                      draw: 0,
                                      lose: 0,
                                      goals: Goals(
                                        goalsFor: 0,
                                        against: 0,
                                      ),
                                    ),
                                    update: DateTime.now(), // Giá trị mặc định
                                  ),
                                  leagueId: team["leagueId"].toString(),
                                  seasonYear: team["seasonYear"].toString(),
                                ),
                              ),
                            );
                          } else {
                            print("Lỗi: Dữ liệu không đầy đủ để điều hướng.");
                          }
                        }
                                  
                      ),
                    ),
                  );
                },
              ),
          ),
    );
  }
}
