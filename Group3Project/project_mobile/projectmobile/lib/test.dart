// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// void addTestUser() async {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   try {
//     // Tạo tài khoản người dùng
//     UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
//       email: 'test@example.com',
//       password: 'password123',
//     );

//     // Thêm thông tin người dùng vào Firestore
//     await _firestore.collection('users').doc(userCredential.user!.uid).set({
//       'role': 'admin', // hoặc 'user'
//     });

//     print('Tài khoản test đã được tạo thành công');
//   } catch (e) {
//     print('Lỗi khi tạo tài khoản test: $e');
//   }
// }