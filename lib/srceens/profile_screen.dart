import 'package:flutter/material.dart';
import 'home_screen.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text(
          'Thông tin cá nhân',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Phần ảnh bìa và ảnh đại diện
          Stack(
            children: [
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/image/bg.png'), // Đường dẫn tới hình nền
                    fit: BoxFit.cover, // Bao phủ toàn bộ vùng
                    colorFilter: ColorFilter.mode(
                      Color.fromRGBO(255, 255, 255, 0.6), // Màu trắng với độ trong suốt 60%
                      BlendMode.srcOver, // Kết hợp lớp phủ với hình ảnh
                    ),
                  ),
                ),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Text(
                          'Tên Người dùng',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 48,
                          backgroundImage: AssetImage('assets/image/avatar.png'), // Đường dẫn ảnh đại diện
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 30),
          // Tên và email người dùng
          Text(
            'Tên Tài khoản',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
          Text(
            'email@example.com',
            style: TextStyle(fontSize: 16, color: Colors.grey[700]),
          ),
          SizedBox(height: 20),
          // Danh sách các mục
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildProfileOption(Icons.person, 'Hồ sơ cá nhân'),
                Divider(color: Colors.grey[300]),
                _buildProfileOption(Icons.notifications, 'Thông báo'),
                Divider(color: Colors.grey[300]),
                _buildProfileOption(Icons.help, 'Trợ giúp'),
                Divider(color: Colors.grey[300]),
                _buildProfileOption(Icons.info, 'Giới thiệu'),
                Divider(color: Colors.grey[300]),
                _buildProfileOption(Icons.swap_horiz, 'Chuyển tài khoản'),
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
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              },
              child: Text(
                'Đăng Xuất',
                style: TextStyle(
                  fontWeight: FontWeight.bold, // In đậm
                  color: Colors.white,         // Màu trắng
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromRGBO(0, 0, 0, 0.7), // Màu đỏ đậm
                padding: EdgeInsets.symmetric(vertical: 16),
                textStyle: TextStyle(fontSize: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                minimumSize: Size(200, 50),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileOption(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue[800]),
      title: Text(
        title,
        style: TextStyle(fontSize: 16),
      ),
      onTap: () {
        // Thêm hành động hoặc điều hướng tại đây
      },
    );
  }
}
