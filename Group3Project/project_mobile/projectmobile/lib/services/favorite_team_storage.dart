import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavoriteTeamStorage {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Kiểm tra xem đội bóng có trong danh sách yêu thích không
  static Future<bool> isFavoriteTeam(String teamId) async {
    final user = _auth.currentUser;
    if (user == null) return false;

    final doc = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('favorite_teams')
        .doc(teamId)
        .get();

    return doc.exists;
  }

  // Thêm đội bóng vào danh sách yêu thích
  static Future<void> addFavoriteTeam(Map<String, String> teamData) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('favorite_teams')
        .doc(teamData['id'])
        .set(teamData);
  }

  // Xóa đội bóng khỏi danh sách yêu thích
  static Future<void> removeFavoriteTeam(String teamId) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('favorite_teams')
        .doc(teamId)
        .delete();
  }

  // Lấy danh sách đội bóng yêu thích từ Firestore
  static Future<List<Map<String, dynamic>>> getFavoriteTeams() async {
    final user = _auth.currentUser;
    if (user == null) return [];

    final snapshot = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('favorite_teams')
        .get();

    return snapshot.docs.map((doc) => doc.data()).toList();
  }
}
