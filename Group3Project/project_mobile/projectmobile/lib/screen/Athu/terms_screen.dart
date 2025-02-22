import 'package:flutter/material.dart';

class TermsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Điều khoản & Dịch vụ"),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Điều khoản sử dụng",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 10),
              const Text(
                "1. Khi sử dụng ứng dụng, bạn đồng ý với các điều khoản sau đây.",
                style: TextStyle(fontSize: 16, color: Colors.white70),
              ),
              const SizedBox(height: 10),
              const Text(
                "2. Chúng tôi có quyền thay đổi điều khoản bất cứ lúc nào mà không cần thông báo trước.",
                style: TextStyle(fontSize: 16, color: Colors.white70),
              ),
              const SizedBox(height: 10),
              const Text(
                "3. Dữ liệu cá nhân của bạn sẽ được bảo mật theo chính sách bảo mật của chúng tôi.",
                style: TextStyle(fontSize: 16, color: Colors.white70),
              ),
              const SizedBox(height: 20),
              const Text(
                "Chính sách bảo mật",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 10),
              const Text(
                "1. Chúng tôi cam kết bảo vệ thông tin cá nhân của người dùng.",
                style: TextStyle(fontSize: 16, color: Colors.white70),
              ),
              const SizedBox(height: 10),
              const Text(
                "2. Dữ liệu cá nhân của bạn sẽ không được chia sẻ với bên thứ ba nếu không có sự đồng ý của bạn.",
                style: TextStyle(fontSize: 16, color: Colors.white70),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Đồng ý"),
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.black,
    );
  }
}
