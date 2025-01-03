import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? userId;

  @override
  void initState() {
    super.initState();
    _getTokenAndDecode();
  }

  Future<void> _getTokenAndDecode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token =
        prefs.getString('token'); // Giả sử bạn đã lưu token với key là 'token'
    if (token != null) {
      print("Token: $token");
      try {
        // Giải mã token để lấy thông tin userId
        Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
        print("Token: $decodedToken");
        setState(() {
          // Kiểm tra xem có trường 'id' trong token không
          userId = decodedToken.containsKey('id')
              ? decodedToken['id'].toString() // Chuyển 'id' từ int sang String
              : '30';
        });
      } catch (e) {
        print("Lỗi khi giải mã token: $e");
        setState(() {
          userId = "20";
        });
      }
    } else {
      print('Token không tồn tại');
      setState(() {
        userId = null;
      });
    }
  }

  // API URL
  final String _baseUrl = 'http://10.0.122.239:3000/api/users/';

  // Hàm gửi yêu cầu PUT tới API để cập nhật thông tin người dùng
  Future<void> _updateUser() async {
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content:
            Text('Please fill in all required fields: Name, Email, and Phone'),
        backgroundColor: Colors.red,
      ));
      return; // Dừng lại nếu bất kỳ trường nào bị bỏ trống
    }
    setState(() {
      _isLoading = true;
    });

    final response = await http.put(
      Uri.parse('${_baseUrl}$userId'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'name': _nameController.text,
        'email': _emailController.text,
        'phone':
            _phoneController.text, // Có thể thay đổi thành 'locked' nếu cần
        'password': _passwordController.text.isNotEmpty
            ? _passwordController.text // Chỉ gửi mật khẩu nếu nó không trống
            : null,
      }),
    );

    setState(() {
      _isLoading = false;
    });

    if (response.statusCode == 200) {
      // Nếu cập nhật thành công
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('User updated successfully'),
        backgroundColor: Colors.green,
      ));
    } else {
      // Nếu có lỗi xảy ra
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to update user'),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: 'Phone'),
            ),
            TextField(
              controller: _passwordController, // Thêm trường mật khẩu
              obscureText: true, // Ẩn mật khẩu khi nhập
              decoration: InputDecoration(labelText: 'New Password'),
            ),
            SizedBox(height: 20),
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: _updateUser,
                    child: Text('Save'),
                  ),
          ],
        ),
      ),
    );
  }
}
