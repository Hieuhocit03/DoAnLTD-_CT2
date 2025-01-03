
import 'package:do_an_app/srceens/login_screen.dart';
import 'package:do_an_app/srceens/main_profile.dart';
import 'package:flutter/material.dart';
//import 'home_screen.dart';
import 'car_detail_screen.dart';
class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Thông tin người dùng mẫu
  final Map<String, dynamic> userProfile = {
    'avatar': 'https://www.austinclinic.com.au/wp-content/uploads/2023/02/What-Do-Men-Want-In-2023.webp',
    'name': 'Hieu Nguyen',
    'email': 'nguyenhiu@gmail.com',
    'phone': '0334000345',
    'location': 'Hanoi, Vietnam',
  };

  // Danh sách xe đang bán
  final List<Map<String, dynamic>> sellingCars = [
    {
      'name': 'Toyota Camry',
      'price': '700 triệu',
      'brand': 'Toyota',
      'year': '2020',
      'coverImage': 'https://giaxeoto.vn/admin/upload/images/resize/640-gia-xe-toyota-camry.jpg',
    },
    {
      'name': 'Mazda 3',
      'price': '600 triệu',
      'brand': 'Mazda',
      'year': '2019',
      'coverImage': 'https://cms.anycar.vn/wp-content/uploads/2023/12/fe64ed52-20231221_033028.jpg',
    }
  ];

  // Danh sách xe đã bán
  final List<Map<String, dynamic>> soldCars = [
    {
      'name': 'Honda Civic',
      'price': '500 triệu',
      'brand': 'Honda',
      'year': '2018',
      'coverImage': 'https://https://cms.anycar.vn/wp-content/uploads/2023/12/fe64ed52-20231221_033028.jpg',
      'buyer': {
        'name': 'Trần Văn B',
        'avatar': 'https://example.com/avatar.jpg',
        'review': 'Xe rất tốt, đáp ứng đúng nhu cầu của tôi. Máy móc hoạt động êm ái và tiết kiệm nhiên liệu.',
        'rating': 4.5,
        'purchaseDate': '15/12/2023'
      }
    }
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _editProfile() {
    // Logic chỉnh sửa thông tin
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Chỉnh sửa thông tin'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: 'Tên',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Số điện thoại',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () {
                // Lưu thông tin
                Navigator.pop(context);
              },
              child: Text('Lưu'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Color(0xFFEf8f9fd),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Quay lại màn hình trước đó
          },
        ),
        title: Text('Hồ Sơ Cá Nhân',style:TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueGrey,
        actions: [
          IconButton(
            icon: Icon(Icons.edit, color: Colors.white),
            onPressed: _editProfile,
          ),
        ],
      ),
      body: Column(
        children: [
          // Phần thông tin cá nhân
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 85,
                  backgroundImage: NetworkImage(userProfile['avatar']),
                ),
                SizedBox(height: 10),
                Text(
                  userProfile['name'],
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  userProfile['email'],
                  style: TextStyle(color: Colors.grey),
                ),
                Text(
                  userProfile['phone'],
                  style: TextStyle(color: Colors.grey),
                ),
                Text(
                  userProfile['location'],
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),

          // TabBar
          TabBar(
            controller: _tabController,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.lightBlueAccent,
            tabs: [
              Tab(text: 'Xe Đang Bán'),
              Tab(text: 'Xe Đã Bán'),
            ],
          ),

          // Nội dung TabBarView
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Xe Đang Bán
                _buildCarList(sellingCars),

                // Xe Đã Bán
                _buildCarList2(soldCars),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCarList(List<Map<String, dynamic>> cars)  {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: cars.length, // Hiển thị tất cả các xe
            itemBuilder: (context, index) {
              final car = cars[index]; // Dùng trực tiếp danh sách cars
              return Container(
                margin: const EdgeInsets.only(bottom: 16.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12.0),
                  leading: _buildCarImage(car['coverImage']),
                  title: Text(
                    car['name'],
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  subtitle: Text('${car['brand']} - ${car['year']}'),
                  trailing: Text(
                    car['price'],
                    style:TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.lightBlueAccent),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CarDetailScreen(car: car),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
  Widget _buildCarList2(List<Map<String, dynamic>> cars) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: cars.length,
            itemBuilder: (context, index) {
              final car = cars[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 16.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Thông tin xe
                    ListTile(
                      contentPadding: const EdgeInsets.all(12.0),
                      leading: _buildCarImage(car['coverImage']),
                      title: Text(
                        car['name'],
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      subtitle: Text('${car['brand']} - ${car['year']}'),
                      trailing: Text(
                        car['price'],
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.lightBlueAccent
                        ),
                      ),
                    ),

                    // Thông tin người mua
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 25,
                            backgroundImage: NetworkImage(car['buyer']['avatar']),
                          ),
                          SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                car['buyer']['name'],
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16
                                ),
                              ),
                              Text(
                                'Ngày mua: ${car['purchaseDate']}',
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Nhận xét của người mua
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Nhận xét',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              car['buyer']['review'],
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 15
                              ),
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(Icons.star, color: Colors.amber, size: 20),
                                Text(
                                  ' ${car['buyer']['rating']}/5',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.amber
                                  ),
                                )
                              ],
                            )
                          ],
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
                      builder: (context) => MainScreen(),
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
        ),
      ],
    );
  }

  Widget _buildCarImage(String imageUrl) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes!
                    : null,
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey[300],
              child: Icon(
                Icons.directions_car,
                color: Colors.grey[600],
                size: 40,
              ),
            );
          },
        ),
      ),
    );
  }
}