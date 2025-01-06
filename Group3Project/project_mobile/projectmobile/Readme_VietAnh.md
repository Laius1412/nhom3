1. Giao diện
![image](https://github.com/user-attachments/assets/18c8a217-1434-403f-86a2-8d5b22647d2a)

USER LIST
![image](https://github.com/user-attachments/assets/1b9d9f4b-e0af-48f0-aa7d-5528d6c79a17)
![image](https://github.com/user-attachments/assets/c3c12776-74f3-4a89-981c-d6be22d1dfcf)

2. Code
#Code clas User:

(
class User {
  String username;
  String password;
  String role;
  // Constructor
  User({required this.username, required this.password, required this.role});
}


#File profile_screen.dart: 
import 'package:flutter/material.dart';
import 'package:projectmobile/class/user.dart';

class ProfileScreen extends StatelessWidget {
  @override
  
  Widget build(BuildContext context) {
    return UserListScreen();
  }
}

class UserListScreen extends StatefulWidget {
  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  // Danh sách người dùng
  List<User> users = [];

  // Controllers để nhập thông tin
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Lựa chọn role
  String selectedRole = 'Admin'; // Giá trị mặc định là Admin

  // Thêm một người dùng vào danh sách
  void addUser() {
    if (usernameController.text.isEmpty || passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Tên đăng nhập và mật khẩu không được để trống!'),
      ));
      return;
    }
    if (users.length < 5) {
      setState(() {
        users.add(User(
        
          username: usernameController.text,
          password: passwordController.text,
          role: selectedRole,
        ));
        usernameController.clear();
        passwordController.clear();
        selectedRole = 'Admin'; // Reset lại giá trị mặc định
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Đã đạt tối đa 5 người dùng.'),
      ));
    }
  }
  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quản lý'),
      ),
      body: Column(
        children: [
          // Form nhập thông tin người dùng
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    labelText: 'Tên đăng nhập',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: 'Mật khẩu',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                  ),
                  obscureText: true,
                ),
                SizedBox(height: 10),
                // Dropdown để chọn role
                DropdownButtonFormField<String>(
                  value: selectedRole,
                  items: [
                    DropdownMenuItem(
                      value: 'Admin',
                      child: Row(
                        children: [
                          Icon(Icons.admin_panel_settings, color: Colors.blue),
                          SizedBox(width: 10),
                          Text('Admin'),
                        ],
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'Khách hàng',
                      child: Row(
                        children: [
                          Icon(Icons.people, color: Colors.green),
                          SizedBox(width: 10),
                          Text('Khách hàng'),
                        ],
                      ),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedRole = value!;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Chức vụ',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: addUser,
                  icon: Icon(Icons.add),
                  label: Text('Thêm Người Dùng'),
                ),
              ],
            ),
          ),
          Divider(),
          // Hiển thị danh sách người dùng dạng GridView
          users.isEmpty
              ? Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.warning_amber_rounded, size: 50, color: Colors.grey),
                        SizedBox(height: 10),
                        Text('Chưa có người dùng nào!'),
                      ],
                    ),
                  ),
                )
              : Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Số cột
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index];
                      return Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(color: Colors.grey, width: 1),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                user.role == 'Admin'
                                    ? Icons.admin_panel_settings
                                    : Icons.people,
                                size: 40,
                                color: user.role == 'Admin' ? Colors.blue : Colors.green,
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Username: ${user.username}',
                                style: TextStyle(fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 5),
                              Text(
                                'Role: ${user.role}',
                                textAlign: TextAlign.center,
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
'''
#Flie main.dart
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
      debugShowCheckedModeBanner: false,
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

#Link Repo code: https://github.com/Laius1412/nhom3
