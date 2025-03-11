import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'dart:async';
import 'home/article_screen.dart'; // Import trang chi tiết bài viết
import 'widgets/live_matches_slider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> imageUrls = [
    'assets/A1.jpg',
    'assets/A2.jpg',
    'assets/B12.jpg',
    'assets/B1.jpg',
    'assets/B2.jpg',
    'assets/B3.jpg',
    'assets/B10.jpg',
    'assets/B4.jpg',
    'assets/B5.jpg',
    'assets/B6.jpg',
    'assets/B7.jpg',
    'assets/B8.jpg',
    'assets/B9.jpg',
    'assets/B10.jpg',
    'assets/B11.jpg',
    'assets/B13.jpg',
    'assets/B14.jpg',
    'assets/2.png',
    'assets/A3.jpg',
    'assets/A4.jpg',
  ];

final List<Map<String, String>> newsList = [
  {
    "title": "Báo cáo trận đấu: Man City 5-1 Arsenal",
    "image": "assets/A7.jpg",
    "content": "Man City đã có một trận đấu xuất sắc khi đánh bại Arsenal với tỷ số 5-1..."
  },
  {
    "title": "Man City đi vào lịch sử giải Ngoại hạng Anh",
    "image": "assets/A.jpg",
    "content": "Với chiến thắng này, Man City đã lập kỷ lục mới trong lịch sử giải đấu..."
  },
  {
    "title": "GHI BÀN! Deportiva Minera 0-4 Real Madrid (Modric)",
    "image": "assets/3.png",
    "content": "Luka Modric đã tỏa sáng giúp Real Madrid giành chiến thắng áp đảo..."
  },
  {
    "title": "Thắng đậm, Barcelona chỉ còn kém Real Madrid 2 điểm",
    "image": "assets/7.jpg",
    "content": "Barcelona vừa có chiến thắng quan trọng để rút ngắn khoảng cách với Real Madrid..."
  },
];


  final List<String> videoUrls = [
    'assets/videos/3.mp4',
    'assets/videos/4.mp4',
    'assets/videos/2.mp4',
  ];

  late List<VideoPlayerController> _videoControllers;
  late List<Future<void>> _initializeVideoPlayerFutures;
  PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _videoControllers =
        videoUrls.map((url) => VideoPlayerController.asset(url)).toList();
    _initializeVideoPlayerFutures =
        _videoControllers.map((controller) => controller.initialize()).toList();
    _videoControllers.forEach((controller) {
      controller.setLooping(true);
      controller.addListener(() {
        setState(() {});
      });
    });

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
  }

  @override
  void dispose() {
    _videoControllers.forEach((controller) => controller.dispose());
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trang chủ', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
      body: ListView(
        children: [
          _buildImageCarousel(),
          _buildSectionTitle('Highlight Bóng Đá', Icons.sports_soccer),
          _buildVideoHighlights(),
          _buildSectionTitle('Latest News', Icons.article),
          _buildNewsList(),
           _buildSectionTitle('Live Score', Icons.sports), // Tiêu đề Live Score
          LiveMatchesSlider(), // Hiển thị danh sách trận đấu đang diễn ra
        ],
      ),
      backgroundColor: Colors.black,
    );
  }

  /// Widget: Băng chuyền ảnh
  Widget _buildImageCarousel() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      height: 200,
      child: PageView.builder(
        controller: _pageController,
        itemCount: imageUrls.length,
        itemBuilder: (context, index) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(imageUrls[index], fit: BoxFit.cover),
          );
        },
      ),
    );
  }

  /// Widget: Tiêu đề từng phần
  Widget _buildSectionTitle(String title, IconData icon) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue),
          SizedBox(width: 8),
          Text(
            title,
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

  /// Widget: Video Highlights
  Widget _buildVideoHighlights() {
    final List<String> videoTitles = [
      "HIGHLIGHTS: MANCHESTER UNITED - LEICESTER",
      "HIGHLIGHTS: BRIGHTON - CHELSEA",
      "MBAPPE GHI LIỀN 2 BÀN CÂN BẰNG TỈ SỐ",
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
                          aspectRatio:
                              _videoControllers[index].value.aspectRatio,
                          child: VideoPlayer(_videoControllers[index]),
                        ),
                        AnimatedOpacity(
                          duration: Duration(milliseconds: 500),
                          opacity:
                              _videoControllers[index].value.isPlaying ? 0.0 : 1.0,
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Container(
                              padding: EdgeInsets.all(13),
                              child: Text(
                                videoTitles[index],
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        AnimatedOpacity(
                          duration: Duration(milliseconds: 500),
                          opacity:
                              _videoControllers[index].value.isPlaying ? 0.0 : 1.0,
                          child: Icon(
                            Icons.play_circle_fill,
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

  /// Widget: Danh sách tin tức
  Widget _buildNewsList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: newsList.length,
      itemBuilder: (context, index) {
        final news = newsList[index];

        return GestureDetector(
         onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ArticleScreen(
                  title: news["title"]!,
                  imageUrl: news["image"]!,
                  content: news["content"]!, // Truyền nội dung vào
                ),
              ),
            );
          },

          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(news["image"]!, width: 80, height: 80, fit: BoxFit.cover),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    news["title"]!,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
