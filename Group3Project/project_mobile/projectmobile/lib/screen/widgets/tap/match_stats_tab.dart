import 'package:flutter/material.dart';
import '/model/livescore_model.dart';

class MatchStatsTab extends StatelessWidget {
  final LiveScore match;

  const MatchStatsTab({Key? key, required this.match}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            "Thống kê trận đấu",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          // TODO: Thêm thống kê ở đây
        ],
      ),
    );
  }
}