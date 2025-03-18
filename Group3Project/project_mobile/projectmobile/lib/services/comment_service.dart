import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CommentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> addComment(String text) async {
    final user = _auth.currentUser;
    if (user == null || text.isEmpty) return;

    // Lấy thông tin người dùng từ collection "users"
    final userDoc = await _firestore.collection('users').doc(user.uid).get();

    if (!userDoc.exists) return; // Nếu không có user, thoát

    final userData = userDoc.data()!;

    await _firestore.collection('comments').add({
      'userId': user.uid,
      'userName': userData['username'] ?? 'Người dùng ẩn danh',
      'avatarUrl': userData['avatar'] ?? '', // Lấy avatar từ Cloudinary
      'commentText': text,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteComment(String commentId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final doc = await _firestore.collection('comments').doc(commentId).get();

    if (doc.exists && doc.data()?['userId'] == user.uid) {
      await _firestore.collection('comments').doc(commentId).delete();
    }
  }

  Stream<QuerySnapshot> getCommentsStream() {
    return _firestore
        .collection('comments')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }
}
