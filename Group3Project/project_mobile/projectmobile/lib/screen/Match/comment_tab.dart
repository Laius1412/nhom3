import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:projectmobile/services/comment_service.dart';

class CommentTab extends StatefulWidget {
  @override
  _CommentTabState createState() => _CommentTabState();
}

class _CommentTabState extends State<CommentTab> {
  final TextEditingController _commentController = TextEditingController();
  final CommentService _commentService = CommentService();
  String _currentUserAvatar = '';
  String _currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';

  void _postComment() async {
    await _commentService.addComment(_commentController.text);
    _commentController.clear();
  }

  void _deleteComment(String commentId) async {
    await _commentService.deleteComment(commentId);
  }

  @override
  void initState() {
    super.initState();
    _fetchCurrentUserAvatar();
  }

  void _fetchCurrentUserAvatar() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (userDoc.exists) {
      setState(() {
        _currentUserAvatar = userDoc.data()?['avatar'] ?? '';
      });
    }
  }

  String _formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) return "Chưa có thời gian";
    final DateTime date = timestamp.toDate();
    return DateFormat('HH:mm - dd/MM/yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _commentService.getCommentsStream(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                      child: CircularProgressIndicator(color: Colors.white));
                }
                final comments = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    var comment =
                        comments[index].data() as Map<String, dynamic>;
                    String commentId = comments[index].id;
                    bool isCurrentUser = comment['userId'] == _currentUserId;

                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: comment['avatarUrl'] != ''
                            ? NetworkImage(comment['avatarUrl'])
                            : null,
                        child: comment['avatarUrl'] == ''
                            ? Icon(Icons.person, color: Colors.white)
                            : null,
                      ),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            comment['userName'],
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            _formatTimestamp(comment['timestamp']),
                            style:
                                TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                        ],
                      ),
                      subtitle: Text(
                        comment['commentText'],
                        style: TextStyle(color: Colors.white70),
                      ),
                      trailing: isCurrentUser
                          ? IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteComment(commentId),
                            )
                          : null,
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: _currentUserAvatar.isNotEmpty
                      ? NetworkImage(_currentUserAvatar)
                      : null,
                  child: _currentUserAvatar.isEmpty
                      ? Icon(Icons.person, color: Colors.white)
                      : null,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Nhập bình luận...",
                      hintStyle: TextStyle(color: Colors.white70),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.white),
                  onPressed: _postComment,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
