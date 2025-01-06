# User Grid App

Ứng dụng Flutter hiển thị danh sách người dùng dưới dạng `GridView`. Dữ liệu người dùng bao gồm `username`, `password`, và `role`. Ứng dụng cho phép nhập tối đa 5 bản ghi và hiển thị chúng một cách trực quan.

---

## 1. Cách chạy ứng dụng

### Bước 1: Clone repository
Sử dụng lệnh sau để clone repo:
```bash
git clone <link_repo_github>

### Bước 2: Cài đặt Flutter

Đảm bảo bạn đã cài đặt Flutter SDK trên máy tính của mình.

### Bước 3: Cài đặt thư viện
Chạy lệnh sau trong thư mục dự án:

flutter pub get

### Bước 4: Chạy ứng dụng

Sử dụng lệnh:
flutter run

## 2. Ảnh chụp màn hình

Dưới đây là giao diện hiển thị 5 bản ghi người dùng trên ứng dụng:

## 3. Mã chính

class User {
  String username;
  String password;
  String role;

  User({
    required this.username,
    required this.password,
    required this.role,
  });
}
Object của Class User
Dưới đây là đoạn mã tạo danh sách người dùng trong ứng dụng:

final List<User> users = [];
Mã trong main.dart
dart
Sao chép mã
import 'package:flutter/material.dart';

class User {
  String username;
  String password;
  String role;

  User({
    required this.username,
    required this.password,
    required this.role,
  });
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: UserGridScreen(),
    );
  }
}

class UserGridScreen extends StatefulWidget {
  @override
  _UserGridScreenState createState() => _UserGridScreenState();
}

class _UserGridScreenState extends State<UserGridScreen> {
  final List<User> users = [];

  // Hàm để thêm dữ liệu người dùng
  void _addUser() {
    setState(() {
      if (users.length < 5) {
        users.add(User(
          username: 'user${users.length + 1}',
          password: 'pass${users.length + 1}',
          role: 'role${users.length + 1}',
        ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Grid'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: _addUser,
            child: const Text('Thêm người dùng'),
          ),
          Expanded(
            child: users.isEmpty
                ? const Center(child: Text('Chưa có dữ liệu người dùng!'))
                : GridView.builder(
                    padding: const EdgeInsets.all(10),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Số cột trong GridView
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 3 / 2,
                    ),
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index];
                      return Card(
                        color: Colors.blueAccent,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Username: ${user.username}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                'Role: ${user.role}',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

## 4. Liên kết GitHub

Repository GitHub

## 5. Ghi chú

Mã nguồn được viết và kiểm thử trên Flutter 3.0+.
Đảm bảo ảnh chụp màn hình (tệp screenshot.png) nằm trong thư mục gốc của dự án.
