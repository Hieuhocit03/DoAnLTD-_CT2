import 'package:flutter/material.dart';
import '../srceens/register_screen.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
