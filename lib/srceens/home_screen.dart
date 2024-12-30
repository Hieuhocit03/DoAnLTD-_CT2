import 'package:do_an_app/srceens/profile_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int currentIndex = 0;
  int currentPage = 1;
  int itemsPerPage = 2;

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

  final List<Map<String, dynamic>> cars = [
    {
      'name': 'Toyota Camry',
      'price': '700 triệu',
      'brand': 'Toyota',
      'year': 2018,
      'description': 'Xe gia đình, bảo dưỡng định kỳ, nội thất đẹp.',
    },
    {
      'name': 'Mazda 3',
      'price': '600 triệu',
      'brand': 'Mazda',
      'year': 2020,
      'description': 'Xe mới đi 20,000 km, không va chạm, bảo hành chính hãng.',
    },
    {
      'name': 'Kia Morning',
      'price': '400 triệu',
      'brand': 'Kia',
      'year': 2019,
      'description': 'Xe nhỏ gọn, tiết kiệm nhiên liệu, phù hợp với gia đình nhỏ.',
    },
    {
      'name': 'Honda Civic',
      'price': '800 triệu',
      'brand': 'Honda',
      'year': 2021,
      'description': 'Xe mới tinh, không có va chạm, bảo hành đầy đủ.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: currentIndex == 0
          ? AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'Trang chủ',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 24),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.blue,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.blue,
          tabs: [
            Tab(text: 'Danh sách xe'),
            Tab(text: 'Liên hệ cửa hàng'),
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
              'Đây là trang tìm kiếm',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ),

          // Thêm bài đăng
          _buildAddOptions(),

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
          if (index == 2) { // Khi nhấn nút Thêm
            showModalBottomSheet(
              context: context,
              builder: (context) {
                return Container(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: Icon(Icons.person),
                        title: Text('Đăng bài bán xe mọi người'),
                        onTap: () {
                          Navigator.pop(context); // Đóng modal
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => AddPostScreen(type: 'Mọi người')),
                          );
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.store),
                        title: Text('Đăng bài bán xe cho chủ cửa hàng'),
                        onTap: () {
                          Navigator.pop(context); // Đóng modal
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => AddPostScreen(type: 'Chủ cửa hàng')),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          } else if (index == 3) { // Mục Cá nhân
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
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Cá nhân'),
        ],
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
      ),
    );
  }

  Widget _buildCarList() {
    final paginatedCars = cars.skip((currentPage - 1) * itemsPerPage).take(itemsPerPage).toList();

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: paginatedCars.length,
            itemBuilder: (context, index) {
              final car = paginatedCars[index];
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
                  leading: Icon(Icons.directions_car, size: 40, color: Colors.blue),
                  title: Text(
                    car['name'],
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  subtitle: Text('Giá: ${car['price']} - Năm: ${car['year']}'),
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
        _buildPagination(),
      ],
    );
  }

  Widget _buildPagination() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: currentPage > 1
              ? () {
            setState(() {
              currentPage--;
            });
          }
              : null,
          child: Text('Trước'),
        ),
        Text('Trang $currentPage'),
        TextButton(
          onPressed: currentPage * itemsPerPage < cars.length
              ? () {
            setState(() {
              currentPage++;
            });
          }
              : null,
          child: Text('Sau'),
        ),
      ],
    );
  }

  Widget _buildAddOptions() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => AddPostScreen(type: 'Mọi người')));
            },
            child: Text('Đăng bài bán xe mọi người'),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => AddPostScreen(type: 'Chủ cửa hàng')));
            },
            child: Text('Đăng bài bán xe cho chủ cửa hàng'),
          ),
        ],
      ),
    );
  }
}

class AddPostScreen extends StatelessWidget {
  final String type;

  AddPostScreen({required this.type});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Đăng bài ($type)')),
      body: Center(
        child: Text(
          'Trang đăng bài ($type)',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

class CarDetailScreen extends StatelessWidget {
  final Map<String, dynamic> car;

  CarDetailScreen({required this.car});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(car['name'])),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(car['name'], style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Giá: ${car['price']}'),
            Text('Hãng: ${car['brand']}'),
            Text('Năm: ${car['year']}'),
            SizedBox(height: 16),
            Text('Mô tả: ${car['description']}'),
          ],
        ),
      ),
    );
  }
}
