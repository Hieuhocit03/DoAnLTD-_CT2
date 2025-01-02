import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quên Mật Khẩu'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 20),
            Text(
              'Nhập email để nhận liên kết đặt lại mật khẩu.',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
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
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                String email = emailController.text.trim();
                if (email.isNotEmpty) {
                  // Gửi yêu cầu đặt lại mật khẩu
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Thành công'),
                      content: Text('Liên kết đặt lại mật khẩu đã được gửi đến email của bạn.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context); // Đóng dialog
                            Navigator.pop(context); // Quay lại trang đăng nhập
                          },
                          child: Text('OK'),
                        ),
                      ],
                    ),
                  );
                } else {
                  // Hiển thị thông báo lỗi
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Lỗi'),
                      content: Text('Vui lòng nhập email hợp lệ.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context); // Đóng dialog
                          },
                          child: Text('OK'),
                        ),
                      ],
                    ),
                  );
                }
              },
              child: Text('Gửi Yêu Cầu', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Quay lại trang đăng nhập
              },
              child: Text(
                'Quay lại đăng nhập',
                style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
