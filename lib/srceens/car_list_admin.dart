import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/car.dart';
import 'car_detail_screen.dart'; // Import màn hình chi tiết xe
import 'dart:io';

class CarListPage extends StatefulWidget {
  @override
  _CarListPageState createState() => _CarListPageState();
}

class _CarListPageState extends State<CarListPage> {
  late Future<List<Car>> _cars;
  final apiService = ApiService();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _cars = apiService.fetchCars();
  }

  // Hàm gọi API để lấy tên người bán
  Future<String> getSellerName(int sellerId) async {
    try {
      final apiService = ApiService();
      final sellerName = await apiService
          .fetchSellerName(sellerId); // Gọi API để lấy tên người bán
      return sellerName;
    } catch (e) {
      print('Error fetching seller name: $e');
      return 'Unknown';
    }
  }

  Future<void> _updateCarStatus(Car car) async {
    String newStatus = car.status == 'Đang bán' ? 'Đã bán' : 'Đang bán';
    try {
      final apiService = ApiService();
      await apiService.updateCarStatus(
          car.carId!, newStatus); // Cập nhật trạng thái
      setState(() {
        car.status = newStatus; // Cập nhật trạng thái mới vào giao diện
      });
    } catch (e) {
      print('Error updating car status: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không thể cập nhật trạng thái xe')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Danh Sách Xe'),
      ),
      body: FutureBuilder<List<Car>>(
        future: _cars,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: Text('Lỗi khi tải dữ liệu: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Không có xe nào.'));
          } else {
            final cars = snapshot.data!;

            return ListView.builder(
              itemCount: cars.length,
              itemBuilder: (context, index) {
                final car = cars[index];

                return FutureBuilder<String>(
                  future: getSellerName(car.sellerId), // Gọi tên người bán
                  builder: (context, sellerSnapshot) {
                    if (sellerSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return _buildCarItem(car, 'Đang tải người đăng...');
                    } else if (sellerSnapshot.hasError) {
                      return _buildCarItem(car, 'Lỗi tải tên người đăng');
                    } else {
                      final sellerName = sellerSnapshot.data ?? 'Unknown';
                      return _buildCarItem(
                        car,
                        'Người đăng: $sellerName\nTrạng thái: ${car.status}',
                      );
                    }
                  },
                );
              },
            );
          }
        },
      ),
    );
  }

  Widget _buildCarItem(Car car, String subtitle) {
    return Card(
      elevation: 5, // Thêm bóng cho khung
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // Bo tròn các góc
      ),
      child: ListTile(
        leading: car.imageUrl != null && car.imageUrl!.isNotEmpty
            ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  File(car.imageUrl!), // Sử dụng đường dẫn ảnh từ cơ sở dữ liệu
                  fit: BoxFit.cover,
                  width: 50,
                  height: 50,
                ),
              )
            : Icon(Icons.directions_car, size: 50),
        title: Text(car.name, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
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
        trailing: IconButton(
          icon: Icon(Icons.edit),
          onPressed: () async {
            await _updateCarStatus(
                car); // Gọi phương thức để cập nhật trạng thái
          },
        ),
      ),
    );
  }
}
