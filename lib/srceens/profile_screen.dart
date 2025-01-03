import 'package:do_an_app/srceens/login_screen.dart';
import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../models/user.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? _user; // Lưu trữ thông tin người dùng
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
        _fetchUserData(userId);
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

  Future<void> _fetchUserData(String? userId) async {
    if (userId != null) {
      // Chuyển userId từ String thành int
      int? userIdInt = int.tryParse(userId);
      print("$userIdInt");

      // Kiểm tra xem chuyển đổi có thành công không
      if (userIdInt != null) {
        try {
          final response = await http.get(
            Uri.parse(
                'http://10.0.122.239:3000/api/users/users/$userId'), // Sử dụng userIdInt đã chuyển đổi
          );

          // Kiểm tra mã trạng thái phản hồi từ API
          if (response.statusCode == 200) {
            final Map<String, dynamic> responseData = jsonDecode(response.body);

            // Kiểm tra xem có dữ liệu 'user' khôn
            if (responseData.containsKey('user') &&
                responseData['user'] != null) {
              final userData =
                  responseData['user']; // Lấy đối tượng user từ API

              // Cập nhật trạng thái với dữ liệu người dùng
              setState(() {
                _user = User.fromJson(
                    userData); // Chuyển đối tượng 'user' thành đối tượng User
              });
            } else {
              print('Không có dữ liệu người dùng hoặc dữ liệu không hợp lệ');
            }
          } else {
            print(
                'Không thể lấy dữ liệu người dùng. Mã lỗi: ${response.statusCode}');
          }
        } catch (e) {
          print('Lỗi khi gọi API: $e');
        }
      } else {
        print('userId không hợp lệ'); // Nếu không thể chuyển đổi thành int
      }
    }
  }

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
                    image: AssetImage(
                        'assets/image/bg.png'), // Đường dẫn tới hình nền
                    fit: BoxFit.cover, // Bao phủ toàn bộ vùng
                    colorFilter: ColorFilter.mode(
                      Color.fromRGBO(255, 255, 255,
                          0.6), // Màu trắng với độ trong suốt 60%
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
                          _user?.name ?? 'Tên Người dùng',
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
                          backgroundImage: AssetImage(
                              'assets/image/avatar.png'), // Đường dẫn ảnh đại diện
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
            _user?.email ?? 'Tên Tài khoản',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
          Text(
            _user?.phone ?? 'email@example.com',
            style: TextStyle(fontSize: 16, color: Colors.grey[700]),
          ),
          SizedBox(height: 20),
          // Danh sách các mục
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildProfileOption(Icons.person, 'Hồ sơ cá nhân', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditProfileScreen(),
                    ),
                  );
                }),
                Divider(color: Colors.grey[300]),
                _buildProfileOption(Icons.notifications, 'Thông báo', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditProfileScreen(),
                    ),
                  );
                }),
                Divider(color: Colors.grey[300]),
                _buildProfileOption(Icons.help, 'Trợ giúp', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditProfileScreen(),
                    ),
                  );
                }),
                Divider(color: Colors.grey[300]),
                _buildProfileOption(Icons.info, 'Giới thiệu', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditProfileScreen(),
                    ),
                  );
                }),
                Divider(color: Colors.grey[300]),
                _buildProfileOption(Icons.swap_horiz, 'Chuyển tài khoản', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditProfileScreen(),
                    ),
                  );
                }),
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
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              child: Text(
                'Đăng Xuất',
                style: TextStyle(
                  fontWeight: FontWeight.bold, // In đậm
                  color: Colors.white, // Màu trắng
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

  Widget _buildProfileOption(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue[800]),
      title: Text(
        title,
        style: TextStyle(fontSize: 16),
      ),
      onTap: onTap, // Thêm hàm onTap để chuyển đến trang chỉnh sửa
    );
  }
}
