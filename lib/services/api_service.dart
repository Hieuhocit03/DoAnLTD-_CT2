// lib/services/api_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/car.dart';
import '../models/car_condition.dart';
import '../models/car_specifications.dart';
import '../models/brand.dart';
import '../models/car_models.dart';
import '../models/user.dart';

class ApiService {
  static const String baseUrl = 'http://10.0.122.239:3000/api/';

  Future<List<Car>> fetchCars() async {
    final url = Uri.parse('${baseUrl}cars');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> carData = json.decode(response.body);
        return carData.map((json) => Car.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load cars');
      }
    } catch (e) {
      throw Exception('Error fetching cars: $e');
    }
  }

  // Hàm gọi API để lấy tên người bán
  Future<String> fetchSellerName(int sellerId) async {
    final url = Uri.parse('${baseUrl}users/users'); // URL API
    try {
      final response = await http.get(url); // Gửi yêu cầu GET

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData =
            json.decode(response.body); // Parse JSON
        final List<dynamic> users =
            jsonData['data']; // Lấy danh sách người dùng từ "data"

        final user = users.firstWhere((user) => user['user_id'] == sellerId,
            orElse: () => null);

        return user != null
            ? user['name']
            : 'Unknown'; // Trả về tên người bán nếu tìm thấy, ngược lại trả về 'Unknown'
      } else {
        throw Exception('Failed to load users');
      }
    } catch (e) {
      throw Exception('Error fetching seller name: $e');
    }
  }

  Future<Map<String, String>> fetchContactInfo(int sellerId) async {
    final url = Uri.parse('${baseUrl}users/users'); // URL API
    try {
      final response = await http.get(url); // Gửi yêu cầu GET

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData =
            json.decode(response.body); // Parse JSON
        final List<dynamic> users =
            jsonData['data']; // Lấy danh sách người dùng từ "data"

        final user = users.firstWhere((user) => user['user_id'] == sellerId,
            orElse: () => null);

        if (user != null) {
          // Trả về thông tin email và số điện thoại dưới dạng Map
          return {
            'email': user['email'] ?? 'N/A',
            'phone': user['phone'] ?? 'N/A',
          };
        } else {
          return {
            'email': 'N/A',
            'phone': 'N/A',
          };
        }
      } else {
        throw Exception('Failed to load users');
      }
    } catch (e) {
      throw Exception('Error fetching contact info: $e');
    }
  }

  Future<void> updateCarStatus(int carId, String status) async {
    final url = Uri.parse('${baseUrl}cars/cars/status');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'car_id': carId,
        'status': status,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update car status');
    }
  }

  // Fetch Car Details
  Future<List<Car>> fetchCarDetails(int carId) async {
    try {
      final response = await http.get(Uri.parse('${baseUrl}cars/$carId'));
      if (response.statusCode != 200) {
        throw Exception('Failed to load car details');
      }
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Car.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching car details: $e');
      throw Exception('Failed to load car details');
    }
  }

  // Fetch Car Conditions
  Future<List<CarCondition>> fetchCarCondition(int carId) async {
    try {
      final response =
          await http.get(Uri.parse('${baseUrl}car-conditions/$carId'));
      if (response.statusCode != 200) {
        throw Exception('Failed to load car condition');
      }
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => CarCondition.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching car condition: $e');
      throw Exception('Failed to load car condition');
    }
  }

  // Fetch Car Specifications
  Future<List<CarSpecification>> fetchCarSpecifications(int carId) async {
    try {
      final response =
          await http.get(Uri.parse('${baseUrl}car-specifications/$carId'));
      if (response.statusCode != 200) {
        throw Exception('Failed to load car specifications');
      }
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => CarSpecification.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching car specifications: $e');
      throw Exception('Failed to load car specifications');
    }
  }

  // Fetch Brands
  Future<List<Brand>> fetchBrands() async {
    try {
      final response = await http.get(Uri.parse('${baseUrl}brands'));
      if (response.statusCode != 200) {
        throw Exception('Failed to load brands');
      }
      final data = json.decode(response.body) as List;
      return data.map((brandJson) => Brand.fromJson(brandJson)).toList();
    } catch (e) {
      print('Error fetching brands: $e');
      throw Exception('Failed to load brands');
    }
  }

  Future<List<CarModel>> fetchCarModelNames() async {
    try {
      final response =
          await http.get(Uri.parse('http://10.0.122.239:3000/api/car-models'));

      if (response.statusCode != 200) {
        throw Exception('Failed to load car models');
      }

      final data = json.decode(response.body)['data'] as List;

      // Chuyển đổi danh sách JSON thành danh sách CarModel
      return data.map((item) => CarModel.fromJson(item)).toList();
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }

  Future<List<Brand>> fetchCarBrands() async {
    try {
      final response = await http.get(Uri.parse('${baseUrl}brands'));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((brandJson) => Brand.fromJson(brandJson)).toList();
      } else {
        throw Exception('Không thể tải danh sách hãng xe.');
      }
    } catch (error) {
      throw Exception('Đã xảy ra lỗi khi tải dữ liệu: $error');
    }
  }

  // Gửi yêu cầu đăng bán xe
  Future<http.Response> postCarData(Car car) async {
    final Uri url = Uri.parse('${baseUrl}cars');

    var carJson = car.toJson();
    var response = await http.post(url,
        headers: {"Content-Type": "application/json"},
        body: json.encode(carJson));

    if (response.statusCode == 201) {
      // Nếu thành công, trả về response
      return response;
    } else {
      // Nếu có lỗi, trả về một response với mã lỗi và thông báo lỗi
      return http.Response('Lỗi khi thêm xe', response.statusCode);
    }
  }

  Future<http.Response> postCarConditionData(CarCondition carCondition) async {
    final Uri url = Uri.parse('http://10.0.122.239:3000/api/car-conditions');

    var carConditionJson = carCondition.toJson();
    var response = await http.post(url,
        headers: {"Content-Type": "application/json"},
        body: json.encode(carConditionJson));

    return response;
  }

  Future<http.Response> postCarSpecifications(
      CarSpecification carSpecification) async {
    final Uri url =
        Uri.parse('http://10.0.122.239:3000/api/car-specifications');

    // Chuyển đổi đối tượng CarSpecification thành JSON
    var carSpecificationJson = carSpecification.toJson();

    // Gửi yêu cầu POST đến API
    var response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode(carSpecificationJson),
    );

    // Trả về phản hồi
    return response;
  }

  static Future<List<User>> fetchUsers() async {
    final response = await http.get(Uri.parse('${baseUrl}users/users'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body)['data'];
      return data.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }
}
