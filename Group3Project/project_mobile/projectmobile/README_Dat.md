# Flash Football App

## 1. Ảnh chụp màn hình

Giao diện trang chủ:

![image](https://github.com/user-attachments/assets/f0cb1686-630b-4a3f-a62d-fd52d208640b)

Dưới đây là giao diện hiển thị 5 bản ghi người dùng trên ứng dụng:

![image](https://github.com/user-attachments/assets/3b25e558-6696-43ac-a358-c80d0466f7b7)

## 2. Mã chính

### Class User

class User {

  String username;
  
  String password;
  
  String role;

  User({
  
    required this.username,
    
    required this.password,
    
    required this.role,
    
  });

  @override
  
  String toString() {
  
    return 'Username: $username, Role: $role';
    
  }  
}

### Cập nhật tại profile_screen.dart

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


## 3. Liên kết GitHub

https://github.com/Laius1412/nhom3

### Link file ReadMe:

https://github.com/Laius1412/nhom3/blob/main/Group3Project/project_mobile/projectmobile/README_Dat.md

## 4. Ghi chú

Do mạng yếu nên em chưa commit code lên được.
