import 'package:flutter/material.dart';
import 'car_detail_screen.dart';
import 'home_screen.dart';
class SearchScreen extends StatefulWidget {
  final List<Map<String, dynamic>> cars;

  const SearchScreen({Key? key, required this.cars}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}
class _SearchScreenState extends State<SearchScreen> {

  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  List<String> _searchHistory = [];
  List<Map<String, dynamic>> _filteredCars = [];
  String _currentSearchQuery = '';

  @override
  void initState() {
    super.initState();
    _filteredCars = []; // Bắt đầu với danh sách rỗng

    // Lắng nghe sự kiện thay đổi từng ký tự
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    setState(() {
      _currentSearchQuery = _searchController.text;
      _filterCars(_currentSearchQuery);
    });
  }

  void _filterCars(String query) {
    if (query.isNotEmpty) {
      _filteredCars = widget.cars.where((car) {
        final nameLower = car['name'].toLowerCase();
        final brandLower = car['brand'].toLowerCase();
        final searchLower = query.toLowerCase();

        return nameLower.contains(searchLower) ||
            brandLower.contains(searchLower);
      }).toList();
    } else {
      _filteredCars.clear();
    }
  }

  // Phương thức tìm kiếm chính thức
  void _performSearch() {
    // Chỉ lưu và xử lý khi có nội dung tìm kiếm
    if (_currentSearchQuery.isNotEmpty) {
      setState(() {
        // Thêm từ khóa vào lịch sử
        if (!_searchHistory.contains(_currentSearchQuery)) {
          _searchHistory.insert(0, _currentSearchQuery);

          // Giới hạn lịch sử 5 từ khóa gần nhất
          if (_searchHistory.length > 5) {
            _searchHistory.removeLast();
          }
        }
      });

      // Ẩn bàn phím
      _searchFocusNode.unfocus();
    }
  }

  void _clearSearchHistory() {
    setState(() {
      _searchHistory.clear();
    });
  }

  // Sử dụng từ khóa trong lịch sử để tìm kiếm
  void _searchFromHistory(String query) {
    setState(() {
      _searchController.text = query;
      _currentSearchQuery = query;
      _filterCars(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEf8f9fd),
      appBar: AppBar(
        title: Text('Tìm Kiếm Xe', style:TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [

          // Thanh tìm kiếm
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              decoration: InputDecoration(
                hintText: 'Tìm kiếm xe...',
                prefixIcon: Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _currentSearchQuery = '';
                      _filteredCars.clear();
                    });
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              // Xử lý khi nhấn enter
              onSubmitted: (_) {
                _performSearch();
              },
            ),
          ),
          SizedBox(width: 10), // Khoảng cách giữa thanh tìm kiếm và nút
          ElevatedButton(
            onPressed: _performSearch,
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFE7393B3), // Màu nền nút
              foregroundColor: Colors.white, // Màu chữ
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20), // Bo góc giống thanh tìm kiếm
              ),
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
            ),
            child: Text('Tìm'),
          ),
          // Lịch sử tìm kiếm (chỉ hiện khi có lịch sử)
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
                    child: GestureDetector(
                      onTap: () => _searchFromHistory(query),
                      child: Chip(
                        label: Text(query),
                        onDeleted: () {
                          setState(() {
                            _searchHistory.remove(query);
                          });
                        },
                      ),
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
                'Nhập từ khóa để tìm kiếm xe',
                style: TextStyle(color: Colors.grey),
              ),
            )
                : ListView.builder(
              itemCount: _filteredCars.length,
              itemBuilder: (context, index) {
                final car = _filteredCars[index];
                return ListTile(
                  leading: Image.network(
                    car['coverImage'],
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.directions_car, size: 80);
                    },
                  ),
                  title: Text(car['name'],style:TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  subtitle: Text('${car['brand']} - ${car['year']}'),
                  trailing: Text(
                    car['price'],
                    style:TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  onTap: () {
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

  @override
  void dispose() {
    // Giải phóng các controller và focus node
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }
}