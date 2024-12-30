import 'package:flutter/material.dart';
import '../srceens/register_screen.dart';
import '../srceens/home_screen.dart';
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
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 50),
              // Logo của shop
              Center(
                child: Image.network(
                  'https://via.placeholder.com/150',
                  width: 150,
                  height: 150,
                ),
              ),
              SizedBox(height: 30),
              Text(
                'Đăng Nhập',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
                ),
              ),
              SizedBox(height: 20),
              // Nút đăng nhập
              ElevatedButton(
                onPressed: () {
                  // Xử lý đăng nhập ở đây
                  String email = emailController.text;
                  String password = passwordController.text;
                  // Gọi hàm đăng nhập khi người dùng nhấn nút
                  login(email, password, context);
                },
                child: Text('Đăng Nhập'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  textStyle: TextStyle(fontSize: 16),
                ),
              ),
              SizedBox(height: 10),
              // Liên kết đến trang quên mật khẩu
              TextButton(
                onPressed: () {
                  // Điều hướng đến trang quên mật khẩu
                  Navigator.push(context, MaterialPageRoute(builder: (_) => ForgotPasswordScreen()));
                },
                child: Text('Quên mật khẩu?'),
              ),
              SizedBox(height: 10),
              // Liên kết đến trang đăng ký
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Chưa có tài khoản?'),
                  TextButton(
                    onPressed: () {
                      // Điều hướng đến trang đăng ký
                      Navigator.push(context, MaterialPageRoute(builder: (_) => RegisterScreen()));
                    },
                    child: Text('Đăng ký ngay'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}



class ForgotPasswordScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Quên Mật Khẩu')),
      body: Center(
        child: Text('Trang quên mật khẩu'),
      ),
    );
  }
}
