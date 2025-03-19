import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:projectmobile/Model/scoccerModel.dart';
import 'package:projectmobile/screen/Team/match_schedule_screen.dart';
import 'package:projectmobile/screen/Team/player_stats_screen.dart';
import 'package:projectmobile/screen/Team/team_info_screen.dart';
import 'package:projectmobile/services/favorite_team_storage.dart';

class TeamDetailsScreen extends StatefulWidget {
  final Standing team;
  final String leagueId;
  final String seasonYear;

  const TeamDetailsScreen({
    Key? key,
    required this.team,
    required this.leagueId,
    required this.seasonYear,
  }) : super(key: key);

  @override
  _TeamDetailsScreenState createState() => _TeamDetailsScreenState();
}

class _TeamDetailsScreenState extends State<TeamDetailsScreen>
    with SingleTickerProviderStateMixin {
  bool isFavorite = false;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadFavoriteStatus();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  /// 🔹 Load trạng thái yêu thích từ SharedPreferences
  Future<void> _loadFavoriteStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isFavorite = prefs.getBool('favorite_${widget.team.team?.id}') ?? false;
    });
  }

  /// 🔹 Thay đổi trạng thái yêu thích và lưu vào SharedPreferences
  Future<void> _toggleFavorite() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool("isLoggedIn") ?? false; // Kiểm tra đăng nhập

    if (!isLoggedIn) {
      // Hiển thị thông báo yêu cầu đăng nhập
      _showLoginDialog();
      return; // Thoát khỏi hàm, không cho phép thêm vào yêu thích
    }

    setState(() {
      isFavorite = !isFavorite;
    });

    await prefs.setBool('favorite_${widget.team.team?.id}', isFavorite);

    Map<String, String> teamData = {
      "id": widget.team.team?.id?.toString() ?? "0",
      "name": widget.team.team?.name ?? "No Name",
      "logo": widget.team.team?.logo ?? "",
      "leagueId": widget.leagueId,
      "seasonYear": widget.seasonYear,
    };

    if (isFavorite) {
      await FavoriteTeamStorage.addFavoriteTeam(teamData);
    } else {
      await FavoriteTeamStorage.removeFavoriteTeam(teamData);
    }
  }

  void _showLoginDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Yêu cầu đăng nhập"),
          content: const Text("Bạn cần đăng nhập để thêm đội bóng vào yêu thích."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Hủy"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                // Chuyển hướng đến trang đăng nhập (giả sử có LoginScreen)
                Navigator.pushNamed(context, '/login');
              },
              child: const Text("Đăng nhập"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final teamId = widget.team.team?.id?.toString() ?? "0";
    final leagueId = widget.leagueId;
    final seasonYear = widget.seasonYear;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 150,
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.network(
              widget.team.team?.logo ?? '',
              width: 100,
              height: 100,
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.error,
                color: Colors.red,
                size: 40,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              widget.team.team?.name ?? 'No Name',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.star : Icons.star_border,
              color: Colors.yellow,
            ),
            onPressed: _toggleFavorite,
          ),
        ],
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 0, 0, 0),
                Color.fromARGB(255, 77, 16, 28)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Color.fromARGB(158, 10, 10, 10),
        ),
        child: Column(
          children: [
            Container(
              color: const Color.fromARGB(158, 10, 10, 10),
              child: TabBar(
                controller: _tabController,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.grey,
                tabs: const [
                  Tab(icon: Icon(Icons.info)),
                  Tab(icon: Icon(Icons.perm_contact_calendar)),
                  Tab(icon: Icon(Icons.calendar_today)),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  TeamInfoScreen(
                    teamId: teamId,
                    league: leagueId,
                    season: seasonYear,
                  ),
                  PlayerStatsScreen(),
                  MatchScheduleScreen(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
