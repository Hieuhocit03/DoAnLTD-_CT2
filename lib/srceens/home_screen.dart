import 'package:do_an_app/srceens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'car_detail_screen.dart';
import 'add_car_screen.dart';
import 'search_screen.dart';

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

  final List<Map<String, dynamic>> cars = [
    {
      'name': 'Toyota Camry',
      'time': '20:30 | 25 tháng 12, 2024',
      'price': '700 triệu',

      'brand': 'Toyota',
      'year': 2018,
      'description': 'Xe gia đình, bảo dưỡng định kỳ, nội thất đẹp.',
      'model': 'Sedan',
      'color': 'Gray',
      'sellerName': 'Phát',
      'phone': '0334551345',
      'email': 'vuthanhphat2003@gmail.com',
      'location': '38 Đ. Thảo Điền, Thảo Điền, Quận 2, Hồ Chí Minh, Vietnam',
      'coverImage': 'https://giaxeoto.vn/admin/upload/images/resize/640-gia-xe-toyota-camry.jpg',
      'detailImage': [
         'https://giaxeoto.vn/admin/upload/images/resize/640-gia-xe-toyota-camry.jpg',
          'https://cms.anycar.vn/wp-content/uploads/2023/12/fe64ed52-20231221_033028.jpg',
      ],
      'sellerImage': 'https://www.austinclinic.com.au/wp-content/uploads/2023/02/What-Do-Men-Want-In-2023.webp'
    },
    {
      'name': 'Mazda 3',
      'time': '20:30 | 31 tháng 12, 2024',
      'price': '600 triệu',
      'brand': 'Mazda',
      'year': 2020,
      'description': 'Xe mới đi 20,000 km, không va chạm, bảo hành chính hãng.',
      'model': 'Sedan',
      'color': 'Black',
      'sellerName': 'Thinh',
      'phone': '0334551675',
      'email': 'thinh@gmail.com',
      'location': 'Linh Tây, Thủ Đức',
      'coverImage': 'https://cms.anycar.vn/wp-content/uploads/2023/12/fe64ed52-20231221_033028.jpg',
      'detailImage': [
        'https://giaxeoto.vn/admin/upload/images/resize/640-gia-xe-toyota-camry.jpg',
        'https://cms.anycar.vn/wp-content/uploads/2023/12/fe64ed52-20231221_033028.jpg',
      ],
      'sellerImage': 'https://www.austinclinic.com.au/wp-content/uploads/2023/02/What-Do-Men-Want-In-2023.webp'
    },

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEf8f9fd),
      appBar: currentIndex == 0
          ? AppBar(
        elevation: 0,
        backgroundColor: Color(0xFFf8f9fd),
        title: Text(
          'Trang chủ',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 24),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.lightBlueAccent,
          tabs: [
            Tab(text: 'Danh sách xe'),
            Tab(text: 'Xe chờ mua'),
          ],
        ),
      )
          : AppBar(
        title: Text('AutoCar'),
        backgroundColor: Colors.blueGrey,
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
          if (index == 1) { // Khi nhấn nút Thêm
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => SearchScreen(cars: cars)),
            );
          }else if (index == 2) { // Khi nhấn nút Thêm
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => AddCarScreen()),
            );
          // } else if (index == 3) { // Mục Cá nhân
          //   Navigator.push(
          //     context,
          //     MaterialPageRoute(builder: (_) => ProfileScreen()),
          //   );
          } else if (index == 4) { // Mục Cá nhân
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
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Thông báo'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Cá nhân'),
        ],
        backgroundColor: Colors.white,
        selectedItemColor: Colors.lightBlueAccent,
        unselectedItemColor: Colors.grey,
      ),
    );
  }

  Widget _buildCarList() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: cars.length,
            itemBuilder: (context, index) {
              final car = cars[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CarDetailScreen(car: car),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 16.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Hình ảnh lớn ở giữa
                      _buildLargeCarImage(car['coverImage']),

                      // Thông tin xe
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: ListTile(
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
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLargeCarImage(String imageUrl) {
    return Container(
      width: double.infinity,
      height: 250, // Tăng chiều cao của hình ảnh
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(15),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(15),
        ),
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
              child: Center(
                child: Icon(
                  Icons.directions_car,
                  color: Colors.grey[600],
                  size: 100,
                ),
              ),
            );
          },
        ),
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




