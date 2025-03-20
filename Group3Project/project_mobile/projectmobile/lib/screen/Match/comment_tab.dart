import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
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
  String _currentUserId = '';

  @override
  void initState() {
    super.initState();
    _fetchCurrentUserDetails();
  }

  void _fetchCurrentUserDetails() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (userDoc.exists) {
      setState(() {
        _currentUserAvatar = userDoc.data()?['avatar'] ?? '';
        _currentUserId = user.uid;
      });
    }
  }

  void _postComment() async {
    await _commentService.addComment(_commentController.text);
    _commentController.clear();
  }

  void _deleteComment(String commentId) async {
    await _commentService.deleteComment(commentId);
  }

  void _copyComment(String text) {
    Clipboard.setData(ClipboardData(text: text));
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
                    String userId = comment['userId'];

                    bool isLiked =
                        comment['likes']?.contains(_currentUserId) ?? false;
                    bool isDisliked =
                        comment['dislikes']?.contains(_currentUserId) ?? false;

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
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            comment['commentText'],
                            style: TextStyle(color: Colors.white70),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.thumb_up,
                                  color: isLiked ? Colors.blue : Colors.white,
                                ),
                                onPressed: () {
                                  _commentService.toggleLikeDislike(
                                      commentId, _currentUserId, true, false);
                                },
                              ),
                              Text(
                                "${comment['likes']?.length ?? 0}",
                                style: TextStyle(color: Colors.white),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.thumb_down,
                                  color: isDisliked ? Colors.red : Colors.white,
                                ),
                                onPressed: () {
                                  _commentService.toggleLikeDislike(
                                      commentId, _currentUserId, false, true);
                                },
                              ),
                              Text(
                                "${comment['dislikes']?.length ?? 0}",
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ],
                      ),
                      trailing: PopupMenuButton<String>(
                        icon: Icon(
                          Icons.more_vert,
                          color: Colors.white,
                        ),
                        onSelected: (value) {
                          if (value == 'delete') {
                            _deleteComment(commentId);
                          } else if (value == 'copy') {
                            _copyComment(comment['commentText']);
                          } else if (value == 'reply') {
                            // Thêm xử lý trả lời ở đây nếu cần
                          }
                        },
                        itemBuilder: (BuildContext context) {
                          return userId == _currentUserId
                              ? [
                                  PopupMenuItem(
                                    value: 'delete',
                                    height: 20,
                                    child: Text(
                                      'Xóa bình luận',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: 'copy',
                                    height: 20,
                                    child: Text(
                                      'Sao chép',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ]
                              : [
                                  PopupMenuItem(
                                    value: 'reply',
                                    height: 20,
                                    child: Text(
                                      'Trả lời',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: 'copy',
                                    height: 20,
                                    child: Text(
                                      'Sao chép',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ];
                        },
                      ),
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
