import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteTeamStorage {
  static const String _favoriteKey = "favorite_teams";

  /// ✅ Thêm đội bóng vào danh sách yêu thích
  static Future<void> addFavoriteTeam(Map<String, String> team) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favoriteTeams = prefs.getStringList(_favoriteKey) ?? [];

    // Lưu danh sách ID thay vì lưu cả object
    if (!favoriteTeams.contains(team["id"])) {
      favoriteTeams.add(team["id"]!);
      await prefs.setStringList(_favoriteKey, favoriteTeams);
    }

    // Lưu thông tin đội bóng vào một key riêng
    await prefs.setString("team_${team['id']}", jsonEncode(team));
  }

  /// ✅ Lấy danh sách đội bóng yêu thích
  static Future<List<Map<String, String>>> getFavoriteTeams() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favoriteIds = prefs.getStringList(_favoriteKey) ?? [];

    List<Map<String, String>> teams = [];
    for (String id in favoriteIds) {
      String? teamJson = prefs.getString("team_$id");
      if (teamJson != null) {
        teams.add(Map<String, String>.from(jsonDecode(teamJson)));
      }
    }
    return teams;
  }

  /// ✅ Xóa một đội bóng khỏi danh sách yêu thích
  static Future<void> removeFavoriteTeam(String teamId) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favoriteTeams = prefs.getStringList(_favoriteKey) ?? [];

    favoriteTeams.remove(teamId);
    await prefs.setStringList(_favoriteKey, favoriteTeams);
    await prefs.remove("team_$teamId"); // Xóa dữ liệu chi tiết đội bóng
  }

  /// ✅ Kiểm tra xem đội bóng có trong danh sách yêu thích không
  static Future<bool> isFavoriteTeam(String teamId) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favoriteTeams = prefs.getStringList(_favoriteKey) ?? [];
    return favoriteTeams.contains(teamId);
  }
}
