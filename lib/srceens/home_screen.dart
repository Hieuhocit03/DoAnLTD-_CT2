import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Danh sách xe mẫu
  List<Map<String, dynamic>> cars = [
    {'name': 'Toyota Camry', 'price': '700 triệu', 'brand': 'Toyota', 'year': 2018},
    {'name': 'Mazda 3', 'price': '600 triệu', 'brand': 'Mazda', 'year': 2020},
    {'name': 'Kia Morning', 'price': '400 triệu', 'brand': 'Kia', 'year': 2019},
  ];

  // Thanh tìm kiếm
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    // Lọc danh sách xe theo từ khóa
    List<Map<String, dynamic>> filteredCars = cars
        .where((car) => car['name'].toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Quản lý mua bán xe'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Thanh tìm kiếm
            TextField(
              decoration: InputDecoration(
                hintText: 'Tìm kiếm xe...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
            SizedBox(height: 16),
            // Danh sách xe
            Expanded(
              child: filteredCars.isEmpty
                  ? Center(child: Text('Không có xe nào phù hợp.'))
                  : ListView.builder(
                itemCount: filteredCars.length,
                itemBuilder: (context, index) {
                  final car = filteredCars[index];
                  return Card(
                    elevation: 3,
                    child: ListTile(
                      leading: Icon(Icons.directions_car, size: 40),
                      title: Text(car['name']),
                      subtitle: Text(
                          'Giá: ${car['price']} - Năm: ${car['year']} - Hãng: ${car['brand']}'),
                      onTap: () {
                        // Chuyển tới trang chi tiết xe
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Trang chủ'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Lịch hẹn'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Cài đặt'),
        ],
        currentIndex: 0, // Trang đang được chọn
        onTap: (index) {
          // Chuyển đổi giữa các trang
        },
      ),
    );
  }
}
