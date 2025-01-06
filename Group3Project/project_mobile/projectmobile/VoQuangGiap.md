1.Chụp ảnh màn hình Mobile App (trên web hoặc trên ios hoặc trên Android)
![image](https://github.com/user-attachments/assets/470d8fb6-caee-4fda-bca7-38702eb2e0a6)
![image](https://github.com/user-attachments/assets/0775e564-c538-438d-b9ba-3df0bac9a02a)
![image](https://github.com/user-attachments/assets/cf0da5ea-c8f6-45e1-8712-52950407c26e)
![image](https://github.com/user-attachments/assets/5c5918ae-befb-46a4-a9bc-c469f9a3a877)
![image](https://github.com/user-attachments/assets/00b06930-104c-4e9c-a8a7-51bdc17faa4c)
![image](https://github.com/user-attachments/assets/134eb47c-2fc6-4f34-a88a-3d93d025f800)
![image](https://github.com/user-attachments/assets/bdbe788d-be67-42a4-a5bf-64d68ec9aece)



2.Code chính của class User, Object của class User, và main.dart của App.


#Code user.dart

class User {

  String username;
  
  String password;
  
  String role;

  User({required this.username, required this.password, required this.role});

  
  @override
  
  String toString() {
    return 'Username: $username, Role: $role';
  }
}
#code main.dart
import 'package:flutter/material.dart';
import 'class/user.dart'; 

void main() {
  runApp(UserApp());
}

class UserApp extends StatefulWidget {
  @override
  _UserAppState createState() => _UserAppState();
}

class _UserAppState extends State<UserApp> {
  final List<User> users = [];
  final _formKey = GlobalKey<FormState>();

  // Controllers for the input fields
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Variable for selected role
  String? _selectedRole;

  // Function to add a user
  void _addUser() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        users.add(
          User(
            username: _usernameController.text,
            password: _passwordController.text,
            role: _selectedRole ?? "Người dùng", 
          ),
        );
        // Clear input fields
        _usernameController.clear();
        _passwordController.clear();
        _selectedRole = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Quản lý người dùng",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            // Form for adding users
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Thêm Người Dùng",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _usernameController,
                          decoration: const InputDecoration(
                            labelText: 'Tên Đăng Nhập',
                            prefixIcon: Icon(Icons.person),
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Hãy nhập username';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _passwordController,
                          decoration: const InputDecoration(
                            labelText: 'Mật Khẩu',
                            prefixIcon: Icon(Icons.lock),
                            border: OutlineInputBorder(),
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Hãy nhập password';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            labelText: 'Vai Trò',
                            prefixIcon: Icon(Icons.security),
                            border: OutlineInputBorder(),
                          ),
                          value: _selectedRole,
                          items: [
                            'Admin',
                            'Người dùng',
                            'Khách',
                          ]
                              .map((role) => DropdownMenuItem(
                                    value: role,
                                    child: Text(role),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedRole = value;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Hãy chọn vai trò';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),
                        Center(
                          child: GestureDetector(
                          onTap: _addUser, // 
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Colors.teal, Colors.greenAccent],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  ),
                              borderRadius: BorderRadius.circular(30),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Icon(Icons.add, color: Colors.white),
                                  SizedBox(width: 8),
                                  Text(
                                    'Thêm người dùng',
                                  style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                              ),
                              ),
                             ],
                            ),
                        ),
                      ),
                    ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const Divider(thickness: 1.5),
            // Display users in a GridView
            Expanded(
              child: users.isEmpty
                  ? const Center(
                      child: Text(
                        'Chưa có người dùng nào!',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 3 / 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemCount: users.length,
                        itemBuilder: (context, index) {
                          return Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    radius: 30,
                                    backgroundColor: Colors.teal,
                                    child: Text(
                                      users[index].username[0].toUpperCase(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    users[index].username,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    'Role: ${users[index].role}',
                                    style: const TextStyle(fontSize: 14.0),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

3. Link Github đến repo của code vừa viết.
   https://github.com/Laius1412/nhom3


