import 'package:flutter/material.dart';
import 'screen/home_screen.dart';
import 'screen/match_screen.dart';
import 'screen/news_screen.dart';
import 'screen/profile_screen.dart';
import 'screen/stats_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green, // Màu chủ đạo là xanh lá
          primary: Colors.green, // Màu chính là xanh lá
          secondary: Colors.greenAccent, // Màu phụ là xanh lá nhạt
        ),
        useMaterial3: true,
      ),
      home: const MyHomePage(
        title: 'FLASH SOCCER',
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 2;
  final List<Widget> _screens = <Widget>[
    NewsScreen(),
    MatchScreen(),
    HomeScreen(),
    StandingsScreen(),
    ProfileScreen(),
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Cập nhật chỉ số mục được chọn
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          widget.title,
          style: TextStyle(
            color: Colors.green,
          ),
        ),
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black, // Màu nền cho bottom bar
        type: BottomNavigationBarType.fixed, // Cho phép hiển thị tối đa 5 mục
        selectedItemColor: Colors.white, // Màu mục được chọn
        unselectedItemColor: Colors.green, // Màu mục chưa chọn
        currentIndex: _selectedIndex, // Vị trí mục đang được chọn
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment), // Icon cho menu Tin tức
            label: "Tin tức",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sports_soccer), // Icon cho menu Trận đấu
            label: "Trận đấu",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home), // Icon cho menu Trang chủ
            label: "Trang chủ",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.equalizer), // Icon cho menu Search
            label: "BXH",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person), // Icon cho menu chính
            label: "Cá nhân",
          ),
        ],
      ),
    );
  }
}
