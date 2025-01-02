import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/user.dart';
import 'register_screen.dart';
import 'home_screen.dart';
import 'forgotpass_screen.dart';

class LoginScreen extends StatelessWidget {
  final String apiUrl = "http://localhost:3000/api/users/login";

  Future<void> login(User user, BuildContext context) async {
    try {
      // Gửi request POST đến API
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': user.email,
          'password': user.password,
        }),
      );

      // Kiểm tra phản hồi từ API
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        print('Đăng nhập thành công: $data');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else {
        print('Đăng nhập thất bại: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Đăng nhập thất bại. Vui lòng kiểm tra lại thông tin')),
        );
      }
    } catch (e) {
      print('Lỗi kết nối: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi kết nối, vui lòng thử lại sau')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Scaffold(
      body: Stack(
        children: [
          // Hình nền
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/image/bg-login.png'),
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
                mainAxisAlignment: MainAxisAlignment.center,
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
                    'Đăng Nhập',
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
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
                  SizedBox(height: 20),
                  // Nút đăng nhập
                  ElevatedButton(
                    onPressed: () {
                      String email = emailController.text;
                      String password = passwordController.text;
                      User user = User(
                        email: email,
                        password: password,
                      );
                      // Gọi hàm xử lý đăng nhập
                      login(user, context);
                    },
                    child: Text('Đăng Nhập',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      textStyle: TextStyle(fontSize: 16),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ForgotPasswordScreen()),
                      );
                    },
                    child: Text('Quên mật khẩu?',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Chưa có tài khoản?',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegisterScreen()),
                          );
                        },
                        child: Text(
                          'Đăng ký ngay',
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
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
