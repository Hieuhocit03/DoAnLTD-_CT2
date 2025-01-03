import 'package:flutter/material.dart';
import '../models/car.dart'; // Import lớp Car
import '../services/api_service.dart'; // Import lớp dịch vụ để lấy danh sách xe
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'dart:io';
import 'update_car.dart';

class CarListScreen extends StatefulWidget {
  @override
  _CarListScreenState createState() => _CarListScreenState();
}

class _CarListScreenState extends State<CarListScreen> {
  late Future<List<Car>> _carsFuture = Future.value([]);
  String? sellerId;

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
          sellerId = decodedToken['id'].toString() ?? "30";
          // Gọi API để lấy danh sách xe
          _carsFuture = ApiService.getCarsBySellerId(sellerId!);
        });
        // Nếu không có 'id', dùng giá trị mặc định là 0
      } catch (e) {
        print("Lỗi khi giải mã token: $e");
        setState(() {
          sellerId = "20";
        });
      }
    } else {
      print('Token không tồn tại');
      setState(() {
        sellerId = "0";
      });
    }
  }

  Future<void> _deleteCar(int carId) async {
    print("$carId");
    try {
      final response = await ApiService.deleteCar(carId);
      print("$response");
      if (response) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Car deleted successfully'),
          backgroundColor: Colors.green,
        ));
        setState(() {
          // Cập nhật lại danh sách xe sau khi xóa
          _carsFuture = ApiService.getCarsBySellerId(sellerId!);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to delete car'),
          backgroundColor: Colors.red,
        ));
      }
    } catch (e) {
      print('Error deleting car: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Car>>(
        future: _carsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            // Hiển thị khi có lỗi
            return Center(
              child: Text(
                'Error loading cars: ${snapshot.error}',
                style: TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No cars found.'));
          }

          // Hiển thị danh sách xe
          List<Car> cars = snapshot.data!;
          return ListView.builder(
            itemCount: cars.length,
            itemBuilder: (context, index) {
              final car = cars[index];
              return _buildCarItem(car);
            },
          );
        },
      ),
    );
  }

  Widget _buildCarItem(Car car) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.only(bottom: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () {
          // Chuyển đến màn hình chi tiết xe
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
                      'Trạng thái: ${car.status}',
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.delete,
                color: Colors.red,
              ),
              onPressed: () async {
                await _deleteCar(car.carId!);
              },
            ),
            IconButton(
              icon: Icon(
                Icons.edit,
                color: Colors.blue,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditCarScreen(carId: car.carId!),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
