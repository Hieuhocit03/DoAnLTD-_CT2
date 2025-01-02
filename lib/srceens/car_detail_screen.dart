// lib/screens/car_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/car.dart';
import '../models/car_specifications.dart';
import '../models/car_condition.dart';
import '../models/brand.dart';
import '../models/car_models.dart';
import '../services/api_service.dart';

class CarDetailScreen extends StatelessWidget {
  final int carId;
  CarDetailScreen({required this.carId});

  final ApiService _apiService = ApiService(); // Tạo instance ApiService

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context); // Quay lại màn hình trước đó
            },
          ),
          title: Text('Car Details'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Hiển thị thông tin carDetails
              FutureBuilder<List<Brand>>(
                future: _apiService.fetchBrands(),
                builder: (context, brandSnapshot) {
                  if (brandSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (brandSnapshot.hasError) {
                    return Center(child: Text('Error: ${brandSnapshot.error}'));
                  }
                  if (!brandSnapshot.hasData || brandSnapshot.data!.isEmpty) {
                    return Center(child: Text('No brands available'));
                  }

                  final brands = brandSnapshot.data!;

                  return FutureBuilder<List<Car>>(
                    future: _apiService.fetchCarDetails(carId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(child: Text('No car details available'));
                      }

                      final carDetails = snapshot.data!;
                      return _buildSection(
                        title: "Car Details",
                        children: carDetails.map((car) {
                          // Tìm kiếm thương hiệu (brand) dựa trên brandId trong car
                          final brand = brands.firstWhere(
                            (brand) => brand.brandId == car.brandId,
                            orElse: () => Brand(brandId: -1, name: 'Unknown'),
                          );
                          // Truyền cả Car và Brand vào _buildCarDetailsItem
                          return _buildCarDetailsItem(car, brand);
                        }).toList(),
                      );
                    },
                  );
                },
              ),
              // Hiển thị thông tin carCondition
              FutureBuilder<List<CarCondition>>(
                future: _apiService.fetchCarCondition(carId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No car condition available'));
                  }

                  final carCondition = snapshot.data!;
                  return _buildSection(
                    title: "Car Condition",
                    children: carCondition
                        .map((condition) => _buildCarConditionItem(condition))
                        .toList(),
                  );
                },
              ),
              // Hiển thị thông tin carSpecifications
              FutureBuilder<List<CarSpecification>>(
                future: _apiService.fetchCarSpecifications(carId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                        child: Text('No car specifications available'));
                  }

                  final specifications = snapshot.data!;

                  return FutureBuilder<List<CarModel>>(
                    future: _apiService
                        .fetchCarModelNames(), // Fetch danh sách car models
                    builder: (context, modelSnapshot) {
                      if (modelSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (modelSnapshot.hasError) {
                        return Center(
                            child: Text('Error: ${modelSnapshot.error}'));
                      }
                      if (!modelSnapshot.hasData ||
                          modelSnapshot.data!.isEmpty) {
                        return Center(child: Text('No car models available'));
                      }

                      final carModels = modelSnapshot.data!;
                      // Tạo map id -> name từ danh sách car models
                      final carModelMap = {
                        for (var carModel in carModels)
                          carModel.id: carModel.name
                      };

                      return _buildSection(
                        title: "Car Specifications",
                        children: specifications.map((spec) {
                          final carModelName = carModelMap[spec.carModelId] ??
                              'Unknown'; // Lấy tên car model
                          return _buildCarSpecificationItem(spec, carModelName);
                        }).toList(),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ));
  }

  Widget _buildSection(
      {required String title, required List<Widget> children}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildCarDetailsItem(Car car, Brand brand) {
    return Card(
      margin: EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${car.name}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Brand: ${brand.name}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('Year: ${car.year}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('Price: \$${car.price}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('Status: ${car.status}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('Location: ${car.location}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('Description: ${car.description}',
                style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  Widget _buildCarConditionItem(CarCondition condition) {
    return ListTile(
      title: Text('Status: ${condition.status}'),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Km Driven: ${condition.kmDriven} km'),
          Text('Owners Count: ${condition.ownersCount}'),
          Text('License Type: ${condition.licenseType}'),
          Text('Accessories: ${condition.accessories}'),
          Text(
            'Registration Expiry: ${condition.registrationExpiry != null ? DateFormat.yMMMd().format(condition.registrationExpiry!) : 'N/A'}',
          ),
          Text('Origin: ${condition.origin}'),
          Text('Warranty Policy: ${condition.warrantyPolicy}'),
        ],
      ),
    );
  }

  Widget _buildCarSpecificationItem(
      CarSpecification spec, String carModelName) {
    return Card(
      margin: EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Version: ${spec.version ?? 'N/A'}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Car Model: $carModelName', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('Transmission: ${spec.transmission ?? 'N/A'}',
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('Fuel Type: ${spec.fuelType ?? 'N/A'}',
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('Body Style: ${spec.bodyStyle ?? 'N/A'}',
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('Seats: ${spec.seats ?? 'N/A'}',
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('Drivetrain: ${spec.drivetrain ?? 'N/A'}',
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('Engine Type: ${spec.engineType ?? 'N/A'}',
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('Horsepower: ${spec.horsepower ?? 'N/A'}',
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('Torque: ${spec.torque ?? 'N/A'}',
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('Engine Capacity: ${spec.engineCapacity ?? 'N/A'}',
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('Fuel Consumption: ${spec.fuelConsumption ?? 'N/A'}',
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('Airbags: ${spec.airbags ?? 'N/A'}',
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('Ground Clearance: ${spec.groundClearance ?? 'N/A'}',
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('Doors: ${spec.doors ?? 'N/A'}',
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('Weight: ${spec.weight ?? 'N/A'}',
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('Payload Capacity: ${spec.payloadCapacity ?? 'N/A'}',
                style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
