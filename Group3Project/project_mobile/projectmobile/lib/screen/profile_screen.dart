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
