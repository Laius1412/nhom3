import 'package:flutter/material.dart';
import 'package:projectmobile/screen/home_screen.dart';
import 'package:projectmobile/screen/math_screen.dart';
import 'package:projectmobile/screen/news_screen.dart';
import 'package:projectmobile/screen/profile_screen.dart';
import 'package:projectmobile/screen/stats_screen.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 0, 60, 0), // Màu xanh đậm hơn
          primary: const Color.fromARGB(255, 0, 50, 0), // Màu chính đậm hơn
          secondary: Colors.green, // Màu phụ là xanh lá
        ),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'FLASH SOCCER'),
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
    MathScreen(),
    HomeScreen(),
    StatsScreen(),
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
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
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
              label: "Thống kê",
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
