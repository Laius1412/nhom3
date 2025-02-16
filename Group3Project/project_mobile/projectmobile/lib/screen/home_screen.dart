import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
    {
      "title": "Tin tức thể thao 10-2:Thắng đậm,Barcelona chỉ còn kém Real Madrid 2điểm",
      "image": "7.jpg",
    },
    {
      "title": "Báo cáo trận đấu:Man City 5-1 Arsenal ",
      "image": "A7.jpg",
    },
  ];

  final List<String> videoUrls = [
    'assets/videos/3.mp4',
    'assets/videos/4.mp4',
    'assets/videos/2.mp4',
  ];

  late List<VideoPlayerController> _videoControllers;
  late List<Future<void>> _initializeVideoPlayerFutures;

  @override
  void initState() {
    super.initState();
    _videoControllers = videoUrls
        .map((url) => VideoPlayerController.asset(url))
        .toList();
    _initializeVideoPlayerFutures = _videoControllers
        .map((controller) => controller.initialize())
        .toList();
    _videoControllers.forEach((controller) {
      controller.setLooping(true);
      controller.addListener(() {
        setState(() {});
      });
    });
  }

  @override
  void dispose() {
    _videoControllers.forEach((controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    PageController _pageController = PageController();
    int _currentPage = 0;

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
      ),
      body: ListView.builder(
        itemCount: newsList.length + 3,
        itemBuilder: (context, index) {
          if (index == 0) {
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
            return Container(
              margin: EdgeInsets.symmetric(vertical: 8),
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Icon(Icons.sports_soccer, color: Colors.blue),
                  SizedBox(width: 8),
                  Text(
                    'Highlight Bóng Đá',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          }


          if (index == 2) {
            final List<String> videoTitles = [
              "HIGHLIGHTS: MANCHESTER UNITED - LEICESTER | BÀN THẮNG GÂY TRANH CÃI, NGƯỢC DÒNG PHÚT CUỐI CÙNG",
              "HIGHLIGHTS: BRIGHTON - CHELSEA | CÚ SỐC BẤT NGỜ, NIỀM TỰ HÀO CHÂU Á TỎA SÁNG",
              "MBAPPE GHI LIỀN 2 BÀN CÂN BẰNG TỈ SỐ THẮP LẠI HI VỌNG CHO ĐT PHÁP",
            ];

            return Container(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: videoUrls.length,
                itemBuilder: (context, index) {
                  return Container(
                    width: 300,
                    margin: EdgeInsets.symmetric(horizontal: 8),
                    child: FutureBuilder(
                      future: _initializeVideoPlayerFutures[index],
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                if (_videoControllers[index].value.isPlaying) {
                                  _videoControllers[index].pause();
                                } else {
                                  for (var controller in _videoControllers) {
                                    controller.pause();
                                  }
                                  _videoControllers[index].play();
                                }
                              });
                            },
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                AspectRatio(
                                  aspectRatio: _videoControllers[index].value.aspectRatio,
                                  child: VideoPlayer(_videoControllers[index]),
                                ),
                                // Hiển thị tiêu đề khi video chưa phát
                                AnimatedOpacity(
                                  duration: Duration(milliseconds: 500),
                                  opacity: _videoControllers[index].value.isPlaying ? 0.0 : 1.0,
                                  child: Align(
                                    alignment: Alignment.bottomLeft,
                                    child: Container(
                                      // color: Colors.black.withOpacity(0.5),
                                      padding: EdgeInsets.all(13),
                                      child: Text(
                                        videoTitles[index],
                                        // textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                ),
                                // Icon phát/dừng video
                              // Icon phát/dừng video
                                AnimatedOpacity(
                                  duration: Duration(milliseconds: 500),
                                  opacity: _videoControllers[index].value.isPlaying ? 0.0 : 1.0,
                                  child: Icon(
                                    _videoControllers[index].value.isPlaying
                                        ? Icons.pause_circle_filled
                                        : Icons.play_circle_fill,
                                    size: 60,
                                    color: Colors.white.withOpacity(0.7),
                                  ),
                                ),

                              ],
                            ),
                          );
                        } else {
                          return Center(child: CircularProgressIndicator());
                        }
                      },
                    ),
                  );
                },
              ),
            );
          }


          if (index == 3) {
            return Container(
              margin: EdgeInsets.symmetric(vertical: 8),
              padding: EdgeInsets.symmetric(horizontal: 16),
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
          }

          final news = newsList[index - 3];

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
