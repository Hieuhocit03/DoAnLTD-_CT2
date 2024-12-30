import 'package:flutter/material.dart';
import 'car_screen.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  // Controller cho thanh tìm kiếm
  final TextEditingController _searchController = TextEditingController();

  // Danh sách lịch sử tìm kiếm
  List<String> _searchHistory = [];

  // Danh sách xe để tìm kiếm
  final List<Map<String, dynamic>> _cars = [
    {
      'name': 'Toyota Camry',
      'brand': 'Toyota',
      'year': 2018,
      'price': '700 triệu',
      'image': 'https://giaxeoto.vn/admin/upload/images/resize/640-gia-xe-toyota-camry.jpg',
    },
    {
      'name': 'Mazda 3',
      'brand': 'Mazda',
      'year': 2020,
      'price': '600 triệu',
      'image': 'https://cms.anycar.vn/wp-content/uploads/2023/12/fe64ed52-20231221_033028.jpg',
    },
    // Thêm các xe khác
  ];

  // Danh sách xe được lọc
  List<Map<String, dynamic>> _filteredCars = [];

  @override
  void initState() {
    super.initState();
    _filteredCars = _cars;
  }

  // Phương thức tìm kiếm
  void _searchCars(String query) {
    setState(() {
      _filteredCars = _cars.where((car) {
        final nameLower = car['name'].toLowerCase();
        final brandLower = car['brand'].toLowerCase();
        final searchLower = query.toLowerCase();

        return nameLower.contains(searchLower) ||
            brandLower.contains(searchLower);
      }).toList();

      // Thêm từ khóa tìm kiếm vào lịch sử
      if (query.isNotEmpty && !_searchHistory.contains(query)) {
        _searchHistory.insert(0, query);
        // Giới hạn lịch sử 5 từ khóa gần nhất
        if (_searchHistory.length > 5) {
          _searchHistory.removeLast();
        }
      }
    });
  }

  // Xóa lịch sử tìm kiếm
  void _clearSearchHistory() {
    setState(() {
      _searchHistory.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tìm Kiếm Xe'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          // Thanh tìm kiếm
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Tìm kiếm xe...',
                prefixIcon: Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _searchCars('');
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: _searchCars,
            ),
          ),

          // Lịch sử tìm kiếm
          if (_searchHistory.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Lịch sử tìm kiếm',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  TextButton(
                    onPressed: _clearSearchHistory,
                    child: Text(
                      'Xóa',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            ),

          // Danh sách lịch sử tìm kiếm
          if (_searchHistory.isNotEmpty)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _searchHistory.map((query) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Chip(
                      label: Text(query),
                      onDeleted: () {
                        setState(() {
                          _searchHistory.remove(query);
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
            ),

          // Danh sách xe được lọc
          Expanded(
            child: _filteredCars.isEmpty
                ? Center(
              child: Text(
                'Không tìm thấy xe',
                style: TextStyle(color: Colors.grey),
              ),
            )
                : ListView.builder(
              itemCount: _filteredCars.length,
              itemBuilder: (context, index) {
                final car = _filteredCars[index];
                return ListTile(
                  leading: Image.network(
                    car['image'],
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                  title: Text(car['name']),
                  subtitle: Text('${car['brand']} - ${car['year']}'),
                  trailing: Text(car['price']),
                  onTap: () {
                    // Điều hướng đến chi tiết xe
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CarDetailScreen(car: car),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}