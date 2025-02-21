import 'package:flutter/material.dart';
import 'dart:async';

class HomeScreen extends StatelessWidget {
  final List<String> imageUrls = [
    'assets/A1.jpg',
    'assets/A2.jpg',
    'assets/2.png',
    'assets/A3.jpg',
    'assets/A4.jpg',
    'assets/A5.jpg',
    'assets/3.png',
    'assets/4.png',
    'assets/A5.jpg'
  ];

  final List<Map<String, String>> newsList = [
    {
      "title": "Báo cáo trận đấu:Man City 5-1 Arsenal ",
      "image": "A7.jpg",
    },
    {
      "title": "Man City đi vào lịch sử giải Ngoại hạng Anh",
      "image": "A.jpg",
    },
    {
      "title": "GHI BÀN! Deportiva Minera 0-4 Real Madrid (Modric)",
      "image": "3.png",
    },
  ];

  @override
  Widget build(BuildContext context) {
    PageController _pageController = PageController();
    int _currentPage = 0;

    // Tự động chuyển ảnh sau mỗi 3 giây
    Timer.periodic(Duration(seconds: 3), (timer) {
      if (_currentPage < imageUrls.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Trang chủ', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        // centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: newsList.length + 2,
        itemBuilder: (context, index) {
          if (index == 0) {
            // Hiển thị slider ảnh ở đầu
            return Container(
              margin: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              height: 200,
              child: PageView.builder(
                controller: _pageController,
                itemCount: imageUrls.length,
                itemBuilder: (context, index) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      imageUrls[index],
                      fit: BoxFit.cover,
                    ),
                  );
                },
              ),
            );
          }

          if (index == 1) {
            // Thêm dòng tiêu đề "Latest News"
            return Container(
              margin: EdgeInsets.symmetric(vertical: 8),
              padding: EdgeInsets.symmetric(horizontal: 16),
              // color: Colors.black,
              child: Row(
                children: [
                  Icon(Icons.access_alarm, color: Colors.blue),
                  SizedBox(width: 8),
                  Text(
                    'Latest News',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          }final news = newsList[index - 2];

          // Hiển thị các tin tức phía dưới slider
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  blurRadius: 5,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    news["image"]!,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        news["title"] ?? "Không có tiêu đề",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.chat_bubble_outline, size: 16, color: Colors.green),
                          SizedBox(width: 4),
                          Text("2", style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
      backgroundColor: Colors.black,
    );
  }
}