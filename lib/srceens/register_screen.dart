import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'login_screen.dart';
import '../models/user.dart';

class RegisterScreen extends StatelessWidget {
  final String apiUrl = "http://localhost:3000/api/users/register";

  Future<void> register(User user, BuildContext context) async {
    try {
      // Gửi request POST đến API
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(user.toJson()),
      );

      // Kiểm tra phản hồi từ API
      if (response.statusCode == 201) {
        var data = jsonDecode(response.body);
        print('Đăng ký thành công: $data');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Đăng ký thành công!')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        ); // Quay lại màn hình login
      } else {
        print('Đăng ký thất bại: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Đăng ký thất bại: ${response.body}')),
        );
      }
    } catch (e) {
      print('Lỗi kết nối: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không thể kết nối tới máy chủ')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Khởi tạo các TextEditingController
    final TextEditingController nameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController phoneController = TextEditingController();

    return Scaffold(
      body: Stack(
        children: [
          // Hình nền
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/image/bg-register.png'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Color.fromRGBO(255, 255, 255, 0.4),
                  BlendMode.srcOver,
                ),
              ),
            ),
          ),
          // Nội dung chính
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 100),
                  // Hình đại diện
                  Center(
                    child: CircleAvatar(
                      radius: 75,
                      backgroundImage: AssetImage('assets/image/bg-dn.png'),
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                  SizedBox(height: 30),
                  Text(
                    'Đăng Ký',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  // Trường nhập tên người dùng
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Tên người dùng',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.9),
                    ),
                  ),
                  SizedBox(height: 16),
                  // Trường nhập email
                  TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.9),
                    ),
                  ),
                  SizedBox(height: 16),
                  // Trường nhập mật khẩu
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Mật khẩu',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.9),
                    ),
                  ),
                  SizedBox(height: 16),
                  // Trường nhập số điện thoại
                  TextField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'Số điện thoại',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.phone),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.9),
                    ),
                  ),
                  SizedBox(height: 20),
                  // Nút đăng ký
                  ElevatedButton(
                    onPressed: () {
                      String name = nameController.text;
                      String email = emailController.text;
                      String password = passwordController.text;
                      String phone = phoneController.text;

                      // Kiểm tra nếu thông tin trống thì không đăng ký
                      if (name.isEmpty ||
                          email.isEmpty ||
                          password.isEmpty ||
                          phone.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('Vui lòng điền đầy đủ thông tin')),
                        );
                        return;
                      }

                      // Xử lý logic đăng ký
                      User newUser = User(
                        name: name,
                        email: email,
                        password: password,
                        phone: phone,
                        role: 'user',
                        createdAt: DateTime.now(),
                        updatedAt: DateTime.now(),
                      );
                      register(newUser, context);
                    },
                    child: Text('Đăng Ký'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      textStyle: TextStyle(fontSize: 16),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); // Quay lại trang đăng nhập
                    },
                    child: Text('Đã có tài khoản? Đăng nhập',
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
