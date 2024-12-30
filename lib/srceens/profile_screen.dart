import 'package:flutter/material.dart';
import '../srceens/test_login.dart';
class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cá Nhân'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          // Phần hình ảnh user
          Container(
            padding: EdgeInsets.all(16),
            color: Colors.blue.shade50,
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/user_avatar.png'), // Thay bằng đường dẫn ảnh đại diện
                ),
                SizedBox(height: 10),
                Text(
                  'Tên Người Dùng',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(
                  'email@example.com',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          // Các mục dạng danh sách
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text('Hồ sơ cá nhân'),
                  onTap: () {
                    // Điều hướng hoặc hành động khi nhấn
                  },
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.notifications),
                  title: Text('Thông báo'),
                  onTap: () {
                    // Điều hướng hoặc hành động khi nhấn
                  },
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.help),
                  title: Text('Trợ giúp'),
                  onTap: () {
                    // Điều hướng hoặc hành động khi nhấn
                  },
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.info),
                  title: Text('Giới thiệu'),
                  onTap: () {
                    // Điều hướng hoặc hành động khi nhấn
                  },
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.swap_horiz),
                  title: Text('Chuyển tài khoản'),
                  onTap: () {
                    // Điều hướng hoặc hành động khi nhấn
                  },
                ),
              ],
            ),
          ),
          // Nút Đăng Xuất
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => AuthChoiceScreen()),
                );
              },
              child: Text('Đăng Xuất'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade700, // Màu đỏ đậm
                padding: EdgeInsets.symmetric(vertical: 16),
                textStyle: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
