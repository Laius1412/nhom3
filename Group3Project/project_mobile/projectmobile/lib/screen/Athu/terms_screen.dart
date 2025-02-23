import 'package:flutter/material.dart';

class TermsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Điều khoản và Dịch vụ",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white), // Màu nút back
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
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Phần tiêu đề chính
            Center(
              child: Text(
                "ĐIỀU KHOẢN VÀ DỊCH VỤ",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold,color: Colors.white),
              ),
            ),

            SizedBox(height: 8),
            Center(
              child: Text(
                "(Cập nhật lần cuối: [23/02/2025])",
                style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic,color: Colors.white),
              ),
            ),

            SizedBox(height: 16),
            _buildSectionContent(
              "Chào mừng bạn đến với ứng dụng FLASH SOCCER – nơi cung cấp tin tức, lịch thi đấu, kết quả, và các thông tin liên quan đến bóng đá. Khi sử dụng ứng dụng này, bạn đồng ý tuân thủ các điều khoản và dịch vụ dưới đây.",
            ),

            _buildSectionTitle("1. Chấp nhận điều khoản"),
            _buildSectionContent(
                "Bằng cách tải xuống, cài đặt và sử dụng ứng dụng FLASH SOCCER, "
                "Bạn đồng ý với tất cả các điều khoản được quy định tại đây. "
                "Nếu bạn không đồng ý với bất kỳ điều khoản nào, vui lòng ngừng sử dụng ứng dụng.\n\n"
                "Chúng tôi có quyền cập nhật hoặc thay đổi các điều khoản này bất cứ lúc nào. "
                "Khi tiếp tục sử dụng ứng dụng sau khi có thay đổi, bạn đồng ý chấp nhận các điều khoản mới. "
                "Bạn nên thường xuyên kiểm tra lại Điều khoản và Dịch vụ để cập nhật thông tin mới nhất.\n\n"
                "Lưu ý: Một số tính năng của ứng dụng có thể yêu cầu bạn đăng nhập hoặc cấp quyền truy cập (ví dụ: thông báo, định vị, quyền truy cập dữ liệu cá nhân). "
                "Bằng cách cho phép các quyền này, bạn xác nhận rằng mình hiểu và đồng ý với chính sách quyền riêng tư của chúng tôi."),

            _buildSectionTitle("2. Dịch vụ của chúng tôi"),
            _buildSectionContent(
                "• Cập nhật tin tức bóng đá.\n"
                "• Thông tin về giải đấu, đội bóng, cầu thủ.\n"
                "• Lịch thi đấu, kết quả và bảng xếp hạng.\n"
                "• Bình luận và tương tác với cộng đồng."),

            _buildSectionTitle("3. Quyền và trách nhiệm của người dùng"),
            _buildSectionTitle("Quyền của Người dùng"),
            _buildSectionContent(
                "• Truy cập và sử dụng các tính năng của ứng dụng miễn phí (hoặc theo gói dịch vụ nếu có).\n"
                "• Đóng góp ý kiến và phản hồi để giúp cải thiện ứng dụng."),
                
            _buildSectionTitle("Trách nhiệm của Người dùng"),
            _buildSectionContent(
                "• Không đăng tải nội dung vi phạm pháp luật, xúc phạm hoặc kích động bạo lực.\n"
                "• Không sử dụng ứng dụng để phát tán tin giả hoặc nội dung không liên quan đến bóng đá.\n"
                "• Không thực hiện hành vi gian lận, hack hoặc xâm nhập trái phép vào hệ thống.\n\n"
                "Nếu vi phạm, chúng tôi có quyền tạm ngừng hoặc khóa vĩnh viễn tài khoản của bạn."),
            _buildSectionTitle("4. Quyền sở hữu trí tuệ"),
            _buildSectionContent(
                "• Tất cả nội dung trên ứng dụng (tin tức, hình ảnh, dữ liệu, giao diện…) đều thuộc sở hữu của công ty PTTT hoặc được cấp phép sử dụng.\n"
                "• Bạn không được sao chép, phát tán hoặc sử dụng nội dung trong ứng dụng cho mục đích thương mại nếu không có sự đồng ý từ chúng tôi."),

            _buildSectionTitle("5. Bảo mật thông tin"),
            _buildSectionContent(
                "Chúng tôi cam kết bảo vệ thông tin cá nhân của bạn theo Chính sách bảo mật. Tuy nhiên, bạn cần tự bảo vệ tài khoản của mình và không chia sẻ thông tin đăng nhập với người khác."),
            _buildSectionTitle("6. Giới hạn trách nhiệm"),
            _buildSectionContent(
                "• Chúng tôi không chịu trách nhiệm nếu có sai sót trong tin tức, dữ liệu hoặc bất kỳ sự cố nào gây ra do lỗi kỹ thuật.\n"
                "• Chúng tôi không đảm bảo rằng ứng dụng sẽ hoạt động liên tục, không có lỗi hoặc không bị gián đoạn.\n"
                "• Việc sử dụng ứng dụng là hoàn toàn tự nguyện, bạn chịu trách nhiệm với các rủi ro phát sinh khi sử dụng ứng dụng."),
            _buildSectionTitle("7. Thay đổi điều khoản"),
            _buildSectionContent(
                "Chúng tôi có thể cập nhật Điều khoản và Dịch vụ bất cứ lúc nào. Nếu có thay đổi quan trọng, chúng tôi sẽ thông báo cho bạn qua ứng dụng hoặc email. Tiếp tục sử dụng ứng dụng sau khi cập nhật có nghĩa là bạn đồng ý với các thay đổi này."),
            _buildSectionTitle("8. Liên hệ"),
            _buildSectionContent(
              "Nếu bạn có bất kỳ câu hỏi hoặc khiếu nại nào liên quan đến điều khoản này, vui lòng liên hệ với chúng tôi qua:\n"
                "📧 Email: PTTT@gmail.com\n"
                "🌍 Website: www.PTTT.com"),
          ],
        ),
      ),
    );
  }

  // Widget tiêu đề từng mục
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
      child: Text(
        title,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.white),
      ),
    );
  }

  // Widget nội dung từng mục
  Widget _buildSectionContent(String content) {
    return Text(
      content,
      style: TextStyle(fontSize: 16, color: Colors.white70),
    );
  }
}
