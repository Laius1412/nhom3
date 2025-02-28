import 'package:flutter/material.dart';

class CommentTab extends StatefulWidget {
  @override
  _CommentTabState createState() => _CommentTabState();
}

class _CommentTabState extends State<CommentTab> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Text(
      "Comment hiển thị ở đây",
      style: TextStyle(color: Colors.white),
    ));
  }
}
