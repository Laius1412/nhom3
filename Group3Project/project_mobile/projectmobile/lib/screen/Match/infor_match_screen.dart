import 'package:flutter/material.dart';

class InforMatchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 3,
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
                  text: "Overview",
                ),
                Tab(
                  text: "Line-up",
                ),
                Tab(
                  text: "Stats",
                ),
              ],
              labelColor: Colors.green[800],
              indicatorColor: Colors.green[800],
              unselectedLabelColor: Colors.white,
            ),
          ),
          body: TabBarView(children: []),
        ),
      ),
    );
  }
}
