import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteTeamStorage {
  static const String _favoriteKey = "favorite_teams";

  /// ✅ Thêm đội bóng vào danh sách yêu thích
  static Future<void> addFavoriteTeam(Map<String, String> team) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favoriteTeams = prefs.getStringList(_favoriteKey) ?? [];

    // Chuyển dữ liệu đội bóng thành JSON string
    String teamJson = jsonEncode(team);
    
    if (!favoriteTeams.contains(teamJson)) {
      favoriteTeams.add(teamJson);
      await prefs.setStringList(_favoriteKey, favoriteTeams);
    }
  }

  /// ✅ Lấy danh sách đội bóng yêu thích
  static Future<List<Map<String, String>>> getFavoriteTeams() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favoriteTeams = prefs.getStringList(_favoriteKey) ?? [];

    // Chuyển từ JSON string sang danh sách Map
    return favoriteTeams.map((team) => Map<String, String>.from(jsonDecode(team))).toList();
  }

  /// ✅ Xóa một đội bóng khỏi danh sách yêu thích
  static Future<void> removeFavoriteTeam(Map<String, String> team) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favoriteTeams = prefs.getStringList(_favoriteKey) ?? [];

    favoriteTeams.remove(jsonEncode(team));
    await prefs.setStringList(_favoriteKey, favoriteTeams);
  }

  /// ✅ Kiểm tra xem đội bóng có trong danh sách yêu thích không
  static Future<bool> isFavoriteTeam(Map<String, String> team) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favoriteTeams = prefs.getStringList(_favoriteKey) ?? [];
    
    return favoriteTeams.contains(jsonEncode(team));
  }
}
