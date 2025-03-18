import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CommentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> addComment(String text) async {
    final user = _auth.currentUser;
    if (user == null || text.isEmpty) return;

    final userDoc = await _firestore.collection('users').doc(user.uid).get();
    if (!userDoc.exists) return;

    final userData = userDoc.data()!;
    await _firestore.collection('comments').add({
      'userId': user.uid,
      'userName': userData['username'] ?? 'Người dùng ẩn danh',
      'avatarUrl': userData['avatar'] ?? '',
      'commentText': text,
      'timestamp': FieldValue.serverTimestamp(),
      'likes': [],
      'dislikes': [],
    });
  }

  Future<void> deleteComment(String commentId) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final doc = await _firestore.collection('comments').doc(commentId).get();
    if (doc.exists && doc.data()?['userId'] == user.uid) {
      await _firestore.collection('comments').doc(commentId).delete();
    }
  }

  Future<void> toggleLikeDislike(
      String commentId, String userId, bool like, bool dislike) async {
    final docRef = _firestore.collection('comments').doc(commentId);
    final doc = await docRef.get();
    if (!doc.exists) return;

    List likes = List.from(doc.data()?['likes'] ?? []);
    List dislikes = List.from(doc.data()?['dislikes'] ?? []);

    if (like) {
      if (likes.contains(userId)) {
        likes.remove(userId);
      } else {
        likes.add(userId);
        dislikes.remove(userId);
      }
    } else if (dislike) {
      if (dislikes.contains(userId)) {
        dislikes.remove(userId);
      } else {
        dislikes.add(userId);
        likes.remove(userId);
      }
    }

    await docRef.update({'likes': likes, 'dislikes': dislikes});
  }

  Stream<QuerySnapshot> getCommentsStream() {
    return _firestore
        .collection('comments')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }
}
