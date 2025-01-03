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
        title: Text('Danh Sách Xe', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: FutureBuilder<List<Car>>(
        future: _cars,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: Colors.green));
          } else if (snapshot.hasError) {
            return Center(
                child: Text('Lỗi khi tải dữ liệu: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Không có xe nào.', style: TextStyle(fontSize: 18, color: Colors.grey)));
          } else {
            final cars = snapshot.data!;

            return ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
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
      elevation: 5,
      margin: EdgeInsets.only(bottom: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () {
          if (car.carId != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CarDetailScreen(carId: car.carId!),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Car ID is null')),
            );
          }
        },
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: car.imageUrl != null && car.imageUrl!.isNotEmpty
                  ? Image.file(
                File(car.imageUrl!),
                fit: BoxFit.cover,
                width: 120,
                height: 120,
              )
                  : Container(
                color: Colors.grey[200],
                width: 120,
                height: 120,
                child: Icon(
                  Icons.directions_car,
                  size: 50,
                  color: Colors.grey,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      car.name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      subtitle,
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
            ),
            IconButton(
              icon: Icon(
                car.status == 'Đang bán' ? Icons.sell : Icons.done,
                color: car.status == 'Đang bán' ? Colors.orange : Colors.green,
              ),
              onPressed: () async {
                await _updateCarStatus(car);
              },
            ),
          ],
        ),
      ),
    );
  }
}
