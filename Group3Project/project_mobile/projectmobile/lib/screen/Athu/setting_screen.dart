import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
                title: Text(
                "Cài đặt",
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
      backgroundColor: Colors.black, // Màu nền tối
      body: ListView(
        children: [
          _buildSettingItem(Icons.notifications, "Cài đặt thông báo"),
          _buildSettingItem(Icons.sports_soccer, "Trình nhắc tỷ số"),
          _buildSettingItem(Icons.volume_up, "Âm thanh thông báo"),
          const Divider(color: Colors.grey), // Đường kẻ ngăn cách
          _buildSettingItem(Icons.language, "Ngôn ngữ"),
          _buildSettingItem(Icons.percent, "Định dạng tỷ lệ", subtitle: "EU (1.50)"),
          _buildSettingItem(Icons.tab, "Tab chính", subtitle: "Chọn tab đầu tiên sau khi bắt đầu ứng dụng"),
          _buildSettingItem(Icons.view_list, "Trật tự thể thao", subtitle: "Thay đổi thứ tự thể thao trong menu"),
          _buildSettingItem(Icons.brush, "Chủ đề", subtitle: "Mặc định hệ thống"),
          const Divider(color: Colors.grey), // Đường kẻ ngăn cách
          _buildSettingItem(Icons.info, "Giới thiệu FLASH SOCCER", iconColor: Colors.blueAccent),
        ],
      ),
    );
  }

  // Widget để tạo một mục cài đặt
  Widget _buildSettingItem(IconData icon, String title, {String? subtitle, Color? iconColor}) {
    return ListTile(
      leading: Icon(icon, color: iconColor ?? Colors.greenAccent), // Icon màu xanh lá mặc định
      title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 16)),
      subtitle: subtitle != null ? Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 14)) : null,
      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 18), // Mũi tên điều hướng
      onTap: () {
        // Xử lý khi nhấn vào mục (điều hướng hoặc mở modal)
      },
    );
  }
}
