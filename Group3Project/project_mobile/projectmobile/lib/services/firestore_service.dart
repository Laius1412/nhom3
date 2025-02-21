import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projectmobile/Model/user_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Lấy dữ liệu người dùng từ Firestore theo [userId].
  Future<AppUser> fetchUserData(String userId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> doc =
          await _firestore.collection('users').doc(userId).get();

      if (doc.exists && doc.data() != null) {
        return AppUser.fromFirestore(doc);
      } else {
        throw Exception("Người dùng không tồn tại");
      }
    } catch (e) {
      print("Lỗi lấy dữ liệu người dùng: $e");
      throw e;
    }
  }

  /// Cập nhật dữ liệu người dùng (avatar, username, v.v...)
  /// [data] là Map<String, dynamic> chứa các field cần update.
  Future<void> updateUserProfile(String userId, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('users').doc(userId).update(data);
    } catch (e) {
      print("Lỗi cập nhật profile: $e");
      throw e;
    }
  }
}
