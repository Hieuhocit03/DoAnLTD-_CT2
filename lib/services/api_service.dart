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
}
