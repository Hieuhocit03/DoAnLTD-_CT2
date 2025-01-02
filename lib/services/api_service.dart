// lib/services/api_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/car.dart';
import '../models/car_condition.dart';
import '../models/car_specifications.dart';
import '../models/brand.dart';
import '../models/car_models.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:3000/api/';

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
          await http.get(Uri.parse('http://localhost:3000/api/car-models'));

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
    final Uri url = Uri.parse('http://localhost:3000/api/car-conditions');

    var carConditionJson = carCondition.toJson();
    var response = await http.post(url,
        headers: {"Content-Type": "application/json"},
        body: json.encode(carConditionJson));

    return response;
  }

  Future<http.Response> postCarSpecifications(
      CarSpecification carSpecification) async {
    final Uri url = Uri.parse('http://localhost:3000/api/car-specifications');

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
}
