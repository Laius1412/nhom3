import 'package:flutter/material.dart';
import 'package:projectmobile/screen/Match/comment_tab.dart';
import 'event_tab.dart';
import 'lineup_tab.dart';
import 'stats_tab.dart';

class InforMatchScreen extends StatelessWidget {
  final int fixtureId;

  InforMatchScreen({required this.fixtureId});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xFF1E1E1E),
            iconTheme: IconThemeData(color: Colors.white),
            title: Text(
              "Thống kê trận đấu",
              style: TextStyle(color: Colors.white),
            ),
            bottom: TabBar(
              tabs: [
                Tab(
                  text: "Sự kiện",
                ),
                Tab(
                  text: "Đội hình",
                ),
                Tab(
                  text: "Thống kê",
                ),
                Tab(
                  text: "Bình luận",
                ),
              ],
              labelColor: Colors.green[800],
              indicatorColor: Colors.green[800],
              unselectedLabelColor: Colors.white,
            ),
          ),
          body: TabBarView(
            children: [
              EventTab(fixtureId: fixtureId),
              LineupTab(
                fixtureId: fixtureId,
              ),
              StatsTab(
                fixtureId: fixtureId,
              ),
              CommentTab(),
            ],
          ),
        ),
      ),
    );
  }
}
