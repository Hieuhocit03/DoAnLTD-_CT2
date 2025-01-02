import 'package:do_an_app/srceens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'car_detail_screen.dart';
import 'add_car_screen.dart';
import 'seach_screen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/car.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int currentIndex = 0;
  int currentPage = 1;
  int itemsPerPage = 2;

  List<Car> cars = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchCars();
  }

  Future<void> _fetchCars() async {
    try {
      final response =
          await http.get(Uri.parse('http://localhost:3000/api/cars'));
      if (response.statusCode == 200) {
        final List<dynamic> carData = json.decode(response.body);
        setState(() {
          cars = carData.map((json) => Car.fromJson(json)).toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load cars');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching cars: $e');
    }
  }

  // Phương thức để làm mới danh sách xe
  Future<void> _refreshCarList() async {
    // Giả lập việc tải lại dữ liệu
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      // Cập nhật danh sách xe (có thể gọi API ở đây)
      // Ví dụ: cars = fetchCarsFromApi();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: currentIndex == 0
          ? AppBar(
              elevation: 0,
              backgroundColor: Colors.white,
              title: Text(
                'Trang chủ',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 24),
              ),
              bottom: TabBar(
                controller: _tabController,
                labelColor: Colors.blue,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Colors.blue,
                tabs: [
                  Tab(text: 'Danh sách xe'),
                  Tab(text: 'Xe yêu thích'),
                ],
              ),
            )
          : AppBar(
              title: Text('AutoCar'),
              backgroundColor: Colors.blue,
            ),
      body: IndexedStack(
        index: currentIndex,
        children: [
          // Trang chủ với TabBar
          TabBarView(
            controller: _tabController,
            children: [
              _buildCarList(),
              Center(
                child: Text(
                  'Đây là nội dung của tab thứ hai\nCó thể hiển thị thông báo, gợi ý hoặc dữ liệu khác.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
            ],
          ),

          // Tìm kiếm
          Center(
            child: Text(
              'Đây là trang tìm kiếm mới',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ),

          // Thêm bài đăng
          Center(
            child: Text(
              'Đây là trang đăng bán xe',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ),

          // Cá nhân
          Center(
            child: Text(
              'Đây là trang cá nhân',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          if (index == 1) {
            // Khi nhấn nút Thêm
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (_) => SearchScreen(cars: cars)),
            // );
          } else if (index == 2) {
            // Khi nhấn nút Thêm
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => AddCarScreen()),
            );
          } else if (index == 3) {
            // Mục Cá nhân
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ProfileScreen()),
            );
          } else if (index == 4) {
            // Mục Cá nhân
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ProfileScreen()),
            );
          } else {
            setState(() {
              currentIndex = index;
            });
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Trang chủ'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Tìm kiếm'),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle), label: 'Thêm'),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications), label: 'Thông báo'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Cá nhân'),
        ],
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
      ),
    );
  }

  Widget _buildCarList() {
    // Sắp xếp theo thời gian mới nhất
    cars.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return ListView.builder(
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
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(12.0),
            leading: _buildCarImage(car.imageUrl), // Ảnh xe
            title: Row(
              children: [
                const Icon(Icons.directions_car, color: Colors.green),
                const SizedBox(width: 8),
                Text(
                  car.name,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.attach_money, color: Colors.blue),
                    const SizedBox(width: 8),
                    Text('${car.price}'),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.calendar_today, color: Colors.orange),
                    const SizedBox(width: 8),
                    Text('${car.year}'),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.red),
                    const SizedBox(width: 8),
                    Text('${car.location}'),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.date_range, color: Colors.purple),
                    const SizedBox(width: 8),
                    Text('${car.createdAt}'),
                  ],
                ),
              ],
            ),
            // Sự kiện click vào ListTile
            onTap: () {
              // Chuyển đến trang chi tiết và truyền car_id qua route
              if (car.carId != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CarDetailScreen(carId: car.carId!),
                  ),
                );
              } else {
                // Xử lý trường hợp car.id là null nếu cần
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Car ID is null')),
                );
              }
            },
          ),
        );
      },
    );
  }

  Widget _buildCarImage(String? imageUrl) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: imageUrl != null
            ? Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    _placeholderImage(),
              )
            : _placeholderImage(),
      ),
    );
  }

  Widget _placeholderImage() {
    return Container(
      color: Colors.grey[300],
      child: const Icon(
        Icons.directions_car,
        color: Colors.grey,
        size: 40,
      ),
    );
  }

  // Widget _buildPagination() {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //     children: [
  //       TextButton(
  //         onPressed: currentPage > 1
  //             ? () {
  //           setState(() {
  //             currentPage--;
  //           });
  //         }
  //             : null,
  //         child: Text('Trước'),
  //       ),
  //       Text('Trang $currentPage'),
  //       TextButton(
  //         onPressed: currentPage * itemsPerPage < cars.length
  //             ? () {
  //           setState(() {
  //             currentPage++;
  //           });
  //         }
  //             : null,
  //         child: Text('Sau'),
  //       ),
  //     ],
  //   );
  // }
}
