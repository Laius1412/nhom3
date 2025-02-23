import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Giới thiệu",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
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
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle(Icons.info, "Giới thiệu về ứng dụng"),
            _buildSectionContent(
              "⚽ FLASH SOCCER là ứng dụng tin tức bóng đá toàn diện, giúp bạn cập nhật nhanh chóng về kết quả trận đấu, lịch thi đấu, "
              "thông tin cầu thủ, đội bóng và các giải đấu lớn trên thế giới."
            ),
            const SizedBox(height: 16),

            _buildSectionTitle(Icons.star, "Tính năng nổi bật"),
            _buildFeatureItem(Icons.sports_soccer, "Cập nhật tin tức bóng đá mới nhất."),
            _buildFeatureItem(Icons.schedule, "Theo dõi kết quả, lịch thi đấu, bảng xếp hạng."),
            _buildFeatureItem(Icons.groups, "Thông tin chi tiết về đội bóng, cầu thủ."),
            _buildFeatureItem(Icons.chat, "Bình luận và thảo luận cùng cộng đồng người hâm mộ."),
            const SizedBox(height: 16),

            _buildSectionTitle(Icons.download, "Tải ngay ứng dụng!"),
            _buildSectionContent(
              "📲 Hãy tải ngay FLASH SOCCER để không bỏ lỡ bất kỳ thông tin bóng đá hấp dẫn nào! "
              "Cùng hòa mình vào không khí sôi động của bóng đá ngay hôm nay!"
            ),
          ],
        ),
      ),
    );
  }

  // Widget tiêu đề từng mục kèm icon
  Widget _buildSectionTitle(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, color: Colors.redAccent, size: 24), // Màu sắc nổi bật
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ],
    );
  }

  // Widget nội dung từng mục
  Widget _buildSectionContent(String content) {
    return Text(
      content,
      style: const TextStyle(fontSize: 16, color: Colors.white70),
    );
  }

  // Widget hiển thị tính năng nổi bật với icon
  Widget _buildFeatureItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.greenAccent, size: 20), // Icon màu xanh nổi bật
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 16, color: Colors.white70),
            ),
          ),
        ],
      ),
    );
  }
}
