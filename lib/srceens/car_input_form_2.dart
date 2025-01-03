import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart'; // Import ApiService của bạn
import '../models/car_specifications.dart'; // Import class CarSpecification
import '../models/car_models.dart'; // Import class CarModel

class CarSpecificationsForm extends StatefulWidget {
  final int carId;

  CarSpecificationsForm({required this.carId});

  @override
  _CarSpecificationsFormState createState() => _CarSpecificationsFormState();
}

class _CarSpecificationsFormState extends State<CarSpecificationsForm> {
  final _formKey = GlobalKey<FormState>();

  ApiService _apiService = ApiService();

  // Các controller cho input fields
  final _versionController = TextEditingController();
  final _transmissionController = TextEditingController();
  final _fuelTypeController = TextEditingController();
  final _bodyStyleController = TextEditingController();
  final _seatsController = TextEditingController();
  final _drivetrainController = TextEditingController();
  final _engineTypeController = TextEditingController();
  final _horsepowerController = TextEditingController();
  final _torqueController = TextEditingController();
  final _engineCapacityController = TextEditingController();
  final _fuelConsumptionController = TextEditingController();
  final _airbagsController = TextEditingController();
  final _groundClearanceController = TextEditingController();
  final _doorsController = TextEditingController();
  final _weightController = TextEditingController();
  final _payloadCapacityController = TextEditingController();

  // Biến lưu trữ car_model_id
  int? _selectedCarModelId;
  List<CarModel> _carModels = [];

  // Hàm lấy danh sách CarModels
  Future<void> _fetchCarModels() async {
    List<CarModel> carModels = await _apiService.fetchCarModelNames();
    setState(() {
      _carModels = carModels;
    });
  }

  // Hàm gửi dữ liệu thông số xe
  Future<void> _submitCarSpecifications() async {
    if (_formKey.currentState!.validate()) {
      // Tạo đối tượng CarSpecification từ các controller
      CarSpecification carSpecification = CarSpecification(
        carId: widget.carId, // carId từ widget
        version: _versionController.text,
        transmission: _transmissionController.text,
        fuelType: _fuelTypeController.text,
        bodyStyle: _bodyStyleController.text,
        seats: int.tryParse(_seatsController.text),
        drivetrain: _drivetrainController.text,
        engineType: _engineTypeController.text,
        horsepower: _horsepowerController.text,
        torque: _torqueController.text,
        engineCapacity: _engineCapacityController.text,
        fuelConsumption: _fuelConsumptionController.text,
        airbags: int.tryParse(_airbagsController.text),
        groundClearance: _groundClearanceController.text,
        doors: int.tryParse(_doorsController.text),
        weight: _weightController.text,
        payloadCapacity: _payloadCapacityController.text,
        carModelId: _selectedCarModelId, // Lưu car_model_id
      );

      try {
        // Gọi API để thêm thông số xe từ ApiService và đợi kết quả
        var response =
            await _apiService.postCarSpecifications(carSpecification);

        // Kiểm tra trạng thái trả về
        if (response.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Thêm thông số xe thành công')),
          );
        } else {
          // Xử lý khi có lỗi trong phản hồi
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Lỗi: ${response.body}')),
          );
        }
      } catch (e) {
        // Xử lý khi gọi API bị lỗi (ví dụ: không có kết nối internet)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi kết nối: $e')),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchCarModels(); // Gọi API để lấy danh sách car models khi widget khởi tạo
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Nhập Thông Số Xe')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _versionController,
                decoration: InputDecoration(labelText: 'Phiên bản xe'),
              ),
              TextFormField(
                controller: _transmissionController,
                decoration: InputDecoration(labelText: 'Hộp số'),
              ),
              TextFormField(
                controller: _fuelTypeController,
                decoration: InputDecoration(labelText: 'Nhiên liệu'),
              ),
              TextFormField(
                controller: _bodyStyleController,
                decoration: InputDecoration(labelText: 'Kiểu dáng'),
              ),
              TextFormField(
                controller: _seatsController,
                decoration: InputDecoration(labelText: 'Số chỗ ngồi'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập số chỗ ngồi';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _drivetrainController,
                decoration: InputDecoration(labelText: 'Hệ dẫn động'),
              ),
              TextFormField(
                controller: _engineTypeController,
                decoration: InputDecoration(labelText: 'Kiểu động cơ'),
              ),
              TextFormField(
                controller: _horsepowerController,
                decoration: InputDecoration(labelText: 'Công suất động cơ'),
              ),
              TextFormField(
                controller: _torqueController,
                decoration: InputDecoration(labelText: 'Momen xoắn'),
              ),
              TextFormField(
                controller: _engineCapacityController,
                decoration: InputDecoration(labelText: 'Dung tích động cơ'),
              ),
              TextFormField(
                controller: _fuelConsumptionController,
                decoration: InputDecoration(labelText: 'Nhiên liệu tiêu thụ'),
              ),
              TextFormField(
                controller: _airbagsController,
                decoration: InputDecoration(labelText: 'Số túi khí'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _groundClearanceController,
                decoration: InputDecoration(labelText: 'Khoảng sáng gầm xe'),
              ),
              TextFormField(
                controller: _doorsController,
                decoration: InputDecoration(labelText: 'Số cửa'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _weightController,
                decoration: InputDecoration(labelText: 'Trọng lượng'),
              ),
              TextFormField(
                controller: _payloadCapacityController,
                decoration: InputDecoration(labelText: 'Trọng tải'),
              ),
              DropdownButtonFormField<int>(
                decoration: InputDecoration(labelText: 'Chọn Model Xe'),
                value: _selectedCarModelId,
                onChanged: (int? newValue) {
                  setState(() {
                    _selectedCarModelId = newValue;
                  });
                },
                items: _carModels.map((CarModel carModel) {
                  return DropdownMenuItem<int>(
                    value: carModel.id,
                    child: Text(carModel.name), // Hiển thị tên model
                  );
                }).toList(),
                validator: (value) {
                  if (value == null) {
                    return 'Vui lòng chọn model xe';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitCarSpecifications,
                child: Text('Lưu Thông Số Xe'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
