import 'package:flutter/material.dart';
import '../srceens/register_screen.dart';
import '../srceens/home_screen.dart';
import '../srceens/forgotpass_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginScreen extends StatelessWidget {

  final String apiUrl = "http://10.0.2.2:3000/api/users/login";

  Future<void> login(String email, String password, BuildContext context) async {
    try {
      // Gửi request POST đến API
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      // Kiểm tra phản hồi từ API
      if (response.statusCode == 200) {
        // Nếu đăng nhập thành công, bạn có thể xử lý dữ liệu ở đây
        var data = jsonDecode(response.body);
        print('Đăng nhập thành công: $data');
        // Chuyển hướng đến màn hình chính hoặc nơi bạn muốn sau khi đăng nhập thành công
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else {
        // Nếu đăng nhập thất bại
        print('Đăng nhập thất bại: ${response.body}');
        // Hiển thị thông báo lỗi cho người dùng
      }
    } catch (e) {
      print('Lỗi kết nối: $e');
      // Hiển thị thông báo lỗi nếu gặp vấn đề khi gọi API
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
                image: AssetImage('assets/image/bg-login.png'), // Đường dẫn tới hình nền
                fit: BoxFit.cover, // Bao phủ toàn bộ vùng
                colorFilter: ColorFilter.mode(
                  Color.fromRGBO(255, 255, 255, 0.4), // Màu trắng với độ trong suốt 60%
                  BlendMode.srcOver, // Kết hợp lớp phủ với hình ảnh
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
                      radius: 75, // Kích thước hình đại diện
                      backgroundImage: AssetImage('assets/image/bg-dn.png'),
                      backgroundColor: Colors.transparent, // Đảm bảo không có nền đè
                    ),
                  ),
                  SizedBox(height: 30),
                  Text(
                    'Đăng Nhập',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black),
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
                    ),
                  ),
                  SizedBox(height: 20),
                  // Nút đăng nhập
                  ElevatedButton(
                    onPressed: () {
                      String email = emailController.text;
                      String password = passwordController.text;
                      // Gọi hàm xử lý đăng nhập
                    },
                    child: Text('Đăng Nhập',style: TextStyle(fontWeight: FontWeight.bold)),
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
                        MaterialPageRoute(builder: (context) => ForgotPasswordScreen()),
                        );
                    },
                    child: Text('Quên mật khẩu?', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Chưa có tài khoản?', style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold)),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => RegisterScreen()),
                          );
                        },
                        child: Text('Đăng ký ngay',style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),

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



