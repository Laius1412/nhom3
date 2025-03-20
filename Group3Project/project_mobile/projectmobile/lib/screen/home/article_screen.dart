import 'package:flutter/material.dart';
import 'package:projectmobile/screen/Match/comment_tab.dart';
import 'package:flutter/rendering.dart';

class ArticleScreen extends StatefulWidget {
  final String title;
  final String imageUrl;
  final String content;

  const ArticleScreen({
    required this.title,
    required this.imageUrl,
    required this.content,
    Key? key,
  }) : super(key: key);

  @override
  _ArticleScreenState createState() => _ArticleScreenState();
}

class _ArticleScreenState extends State<ArticleScreen> {
  bool _showComments = false; // Trạng thái hiển thị bình luận
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_handleScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _handleScroll() {
    if (_scrollController.position.userScrollDirection == ScrollDirection.forward) {
      // Khi cuộn lên thì ẩn bình luận
      if (_showComments) {
        setState(() {
          _showComments = false;
        });
      }
    } else if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 50) {
      // Khi cuộn đến gần cuối thì hiển thị bình luận
      if (!_showComments) {
        setState(() {
          _showComments = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Chi tiết bài viết",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color.fromARGB(255, 0, 0, 0), Color.fromARGB(255, 77, 16, 28)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              controller: _scrollController,
              padding: EdgeInsets.all(16),
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(widget.imageUrl, width: double.infinity, height: 200, fit: BoxFit.cover),
                ),
                SizedBox(height: 16),
                Text(
                  widget.title,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                SizedBox(height: 16),
                Text(
                  widget.content,
                  style: TextStyle(fontSize: 16, color: Colors.white70),
                ),
                SizedBox(height: 16),
                Divider(color: Colors.white70),
              ],
            ),
          ),
          if (_showComments) // Chỉ hiển thị bình luận khi _showComments = true
            SizedBox(
              height: 300,
              child: CommentTab(),
            ),
        ],
      ),
      backgroundColor: Colors.black,
    );
  }
}
