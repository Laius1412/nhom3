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
    "content": "Man City đã có một trận đấu xuất sắc khi đánh bại Arsenal với tỷ số 5-1 trong khuôn khổ Ngoại hạng Anh. Trận đấu diễn ra tại sân Etihad với sự áp đảo hoàn toàn của đội chủ nhà.\n\nHiệp 1: Man City kiểm soát thế trận\n\nNgay từ những phút đầu tiên, Man City đã thể hiện sức mạnh vượt trội bằng những pha phối hợp nhuần nhuyễn. Arsenal mặc dù cố gắng tổ chức phòng ngự chặt chẽ nhưng vẫn không thể chống đỡ sức ép đến từ các cầu thủ áo xanh.\n\nPhút thứ 12, Kevin De Bruyne có pha kiến tạo đẹp mắt để Erling Haaland dứt điểm chính xác, mở tỷ số 1-0 cho Man City. Sau bàn thắng, Arsenal nỗ lực phản công và có một vài tình huống nguy hiểm, nhưng hàng thủ Man City vẫn đứng vững.\n\nĐến phút 30, Bernardo Silva nhân đôi cách biệt cho Man City sau một pha đi bóng và dứt điểm tinh tế. Arsenal bắt đầu có dấu hiệu xuống tinh thần sau bàn thua này.\n\nHiệp 2: Man City bùng nổ\n\nBước sang hiệp hai, Arsenal tràn lên tấn công nhằm tìm kiếm bàn gỡ, nhưng hàng thủ của họ lại để lộ quá nhiều khoảng trống. Man City tận dụng triệt để điều này để ghi thêm bàn thắng.\n\nPhút 50, Jack Grealish có pha đi bóng xuất sắc bên cánh trái trước khi chuyền ngang để Phil Foden đệm bóng dễ dàng nâng"

  },

  {
  "title": "Man City đi vào lịch sử giải Ngoại hạng Anh",
  "image": "assets/A.jpg",
  "content": "Với chiến thắng này, Man City đã lập kỷ lục mới trong lịch sử giải đấu. Đội bóng của HLV Pep Guardiola tiếp tục thể hiện phong độ ấn tượng khi đánh bại đối thủ với một màn trình diễn xuất sắc.\n\nHành trình vươn tới đỉnh cao\nTrong suốt mùa giải, Man City đã duy trì phong độ ổn định, liên tục giành chiến thắng trước các đối thủ mạnh. Đặc biệt, những chiến thắng quan trọng trước các đội trong nhóm Big Six đã giúp họ tạo khoảng cách an toàn với các đối thủ cạnh tranh.\n\n**Những con số ấn tượng**\n- Số trận thắng liên tiếp: 12\n- Số bàn thắng ghi được: 85\n- Số trận giữ sạch lưới: 18\n\n**Ngôi sao sáng giá**\nKevin De Bruyne tiếp tục chứng minh đẳng cấp của mình với những đường kiến tạo xuất sắc, trong khi Erling Haaland dẫn đầu danh sách Vua phá lưới với 30 bàn thắng.\n\n**Nhận định**\nVới phong độ hiện tại, Man City không chỉ là ứng viên số một cho chức vô địch mà còn có thể lập thêm nhiều kỷ lục ấn tượng trong thời gian tới."
  },

  {
  "title": "GHI BÀN! Deportiva Minera 0-4 Real Madrid (Modric)",
  "image": "assets/3.png",
  "content": "Luka Modric đã tỏa sáng giúp Real Madrid giành chiến thắng áp đảo trước Deportiva Minera. Trận đấu diễn ra với thế trận một chiều khi đội bóng Hoàng gia Tây Ban Nha kiểm soát hoàn toàn thế trận.\n\nHiệp 1: Real Madrid sớm tạo lợi thế\nNgay từ những phút đầu tiên, Real Madrid đã thể hiện sự vượt trội khi tổ chức nhiều pha tấn công nguy hiểm. Phút 15, Modric mở tỷ số bằng một cú sút xa đẹp mắt, đưa đội khách vươn lên dẫn trước.\n\nHiệp 2: Sức mạnh vượt trội\nSau giờ nghỉ, Real Madrid tiếp tục dâng cao đội hình. Phút 55, Vinícius Jr nâng tỷ số lên 2-0 sau một pha phối hợp đẹp mắt. Đến phút 70, Rodrygo ghi bàn thứ ba, trước khi Bellingham ấn định chiến thắng 4-0 ở phút 85.\n\nTổng kết\nVới chiến thắng này, Real Madrid tiếp tục duy trì vị trí dẫn đầu trên bảng xếp hạng và khẳng định sức mạnh của mình trong cuộc đua vô địch mùa giải năm nay.\n\nCầu thủ xuất sắc nhất trận đấu: Luka Modric"
  },

  {
  "title": "Thắng đậm, Barcelona chỉ còn kém Real Madrid 2 điểm",
  "image": "assets/7.jpg",
  "content": "Barcelona vừa có chiến thắng quan trọng để rút ngắn khoảng cách với Real Madrid trong cuộc đua vô địch La Liga. Đội bóng xứ Catalan đã thể hiện phong độ ấn tượng với lối chơi tấn công áp đảo.\n\nHiệp 1: Barcelona kiểm soát hoàn toàn\nNgay từ đầu trận, Barcelona đã tạo sức ép lên khung thành đối phương. Phút 12, Robert Lewandowski mở tỷ số sau một pha phối hợp đẹp mắt với Gavi. Đến phút 30, Raphinha nhân đôi cách biệt với một cú sút xa đẳng cấp.\n\nHiệp 2: Chiến thắng thuyết phục\nSang hiệp hai, Barcelona tiếp tục duy trì thế trận tấn công. Phút 60, Joao Félix ghi bàn nâng tỷ số lên 3-0 sau pha đi bóng và dứt điểm tinh tế. Trước khi trận đấu khép lại, Pedri ghi bàn ấn định chiến thắng 4-0, giúp Barcelona giành trọn vẹn 3 điểm.\n\nTổng kết\nVới chiến thắng này, Barcelona chỉ còn kém Real Madrid 2 điểm trên bảng xếp hạng, tiếp tục nuôi hy vọng giành chức vô địch mùa giải năm nay.\n\nCầu thủ xuất sắc nhất trận đấu: Raphinha"
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
    _videoControllers.forEach((controller) { // Cấu hình video
      controller.setLooping(true); // lặp video
      controller.addListener(() { // theo dõi trạng thái
        setState(() {}); // cập nhật màn hình liên tục
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
        curve: Curves.easeInOut, // hiệu ứng mượt mà
      );
    });
  }
  // Giải phóng bộ nhớ
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
        scrollDirection: Axis.horizontal,// cuộn ngang
        itemCount: videoUrls.length,
        itemBuilder: (context, index) {
          return Container(
            width: 300,
            margin: EdgeInsets.symmetric(horizontal: 8),
            // chờ video laod trước khi hiển thị , chưa load xong sẽ quay vòng tròn
            child: FutureBuilder(
              future: _initializeVideoPlayerFutures[index],
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  // nhấn tạm dừng video
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (_videoControllers[index].value.isPlaying) {
                          _videoControllers[index].pause();
                        } else {
                          for (var controller in _videoControllers) {
                            controller.pause(); // tạm dừng các video khác
                          }
                          _videoControllers[index].play(); // phát video hiện tại
                        }
                      });
                    },
                    // Dùng để chồng ảnh , chồng chữ
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // video play
                        AspectRatio(
                          aspectRatio:
                              _videoControllers[index].value.aspectRatio,
                          child: VideoPlayer(_videoControllers[index]),
                        ),
                        // hiển thị tiêu đề
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
                        // hiển thị nút play
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
    shrinkWrap: true, // Giúp danh sách chiếm diện tích vừa đủ
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
                content: news["content"]!,
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Ảnh bài viết
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(news["image"]!, width: 120, height: 80, fit: BoxFit.cover),
              ),
              SizedBox(width: 10),

              // Phần tiêu đề và icon bình luận
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      news["title"]!,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    SizedBox(height: 4),

                    // Phần hiển thị số bình luận với icon
                    Row(
                      children: [
                        Icon(Icons.comment, size: 16, color: Colors.green),
                        SizedBox(width: 4),
                        Text(
                          news["comments"] ?? "0", // Lấy số bình luận từ dữ liệu
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        ),
                      ],
                    ),
                  ],
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
