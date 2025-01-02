import 'package:flutter/material.dart'; // Để sử dụng các widget của Flutter
import 'package:intl/intl.dart'; // Để định dạng ngày tháng
import '../models/car_condition.dart'; // Import class CarCondition
import '../services/api_service.dart';
import 'car_input_form_2.dart';

// Class CarConditionForm
class CarConditionForm extends StatefulWidget {
  final int carId; // Thêm biến carId để nhận dữ liệu

  // Khởi tạo CarConditionForm với carId
  CarConditionForm({required this.carId});

  @override
  _CarConditionFormState createState() => _CarConditionFormState();
}

class _CarConditionFormState extends State<CarConditionForm> {
  final _formKey = GlobalKey<FormState>();

  // Các biến lưu dữ liệu từ form
  final _kmDrivenController = TextEditingController();
  final _ownersCountController = TextEditingController();
  final _licenseTypeController = TextEditingController();
  final _accessoriesController = TextEditingController();
  final _originController = TextEditingController();
  final _statusController = TextEditingController();
  final _warrantyPolicyController = TextEditingController();
  DateTime? _registrationExpiry;

  // Dữ liệu mẫu cho status
  List<String> _statusOptions = ['Mới', 'Đã sử dụng'];
  String? _selectedStatus;
  ApiService _apiService = ApiService();

  // Hàm để gửi dữ liệu API
  Future<void> _submitCarCondition() async {
    if (_formKey.currentState!.validate()) {
      // Tạo đối tượng CarCondition và sử dụng carId từ widget
      CarCondition carCondition = CarCondition(
        carId: widget.carId, // Sử dụng carId từ widget
        kmDriven: int.tryParse(_kmDrivenController.text),
        ownersCount: int.tryParse(_ownersCountController.text),
        licenseType: _licenseTypeController.text,
        accessories: _accessoriesController.text,
        registrationExpiry: _registrationExpiry,
        origin: _originController.text,
        status: _selectedStatus,
        warrantyPolicy: _warrantyPolicyController.text,
      );

      try {
        // Gọi API để thêm tình trạng xe từ ApiService và đợi kết quả
        var response = await _apiService.postCarConditionData(carCondition);

        // Kiểm tra trạng thái trả về
        if (response.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Thêm tình trạng xe thành công')),
          );
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CarSpecificationsForm(carId: widget.carId),
            ),
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

  // Hiển thị DatePicker để chọn ngày
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _registrationExpiry)
      setState(() {
        _registrationExpiry = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Nhập Tình Trạng Xe')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _kmDrivenController,
                decoration: InputDecoration(labelText: 'Số Km đã đi'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập số km';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _ownersCountController,
                decoration: InputDecoration(labelText: 'Số đời chủ'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập số đời chủ';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _licenseTypeController,
                decoration: InputDecoration(labelText: 'Loại biển số'),
              ),
              TextFormField(
                controller: _accessoriesController,
                decoration: InputDecoration(labelText: 'Phụ kiện'),
              ),
              TextFormField(
                controller: _originController,
                decoration: InputDecoration(labelText: 'Xuất xứ'),
              ),
              DropdownButtonFormField<String>(
                value: _selectedStatus,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedStatus = newValue;
                  });
                },
                items: _statusOptions
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: InputDecoration(labelText: 'Tình trạng'),
              ),
              TextFormField(
                controller: _warrantyPolicyController,
                decoration: InputDecoration(labelText: 'Chính sách bảo hành'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_registrationExpiry == null
                      ? 'Chọn ngày hết hạn đăng kiểm'
                      : DateFormat('dd/MM/yyyy').format(_registrationExpiry!)),
                  IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context),
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitCarCondition,
                child: Text('Lưu Tình Trạng Xe'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
