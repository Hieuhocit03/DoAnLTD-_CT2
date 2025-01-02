// lib/screens/add_car_screen.dart

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../models/car.dart';
import '../models/brand.dart';
import '../services/api_service.dart';
import 'dart:convert';
import 'car_input_form.dart';

class AddCarScreen extends StatefulWidget {
  const AddCarScreen({Key? key}) : super(key: key);

  @override
  _AddCarScreenState createState() => _AddCarScreenState();
}

class _AddCarScreenState extends State<AddCarScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  File? _imageFile;

  List<Brand> _carBrands = [];
  bool _isLoading = true;

  ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _fetchCarBrands();
  }

  Future<void> _fetchCarBrands() async {
    try {
      List<Brand> brands = await _apiService.fetchCarBrands();
      setState(() {
        _carBrands = brands;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      _showErrorDialog(error.toString());
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Thư viện ảnh'),
                onTap: () {
                  _pickImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Chụp ảnh'),
                onTap: () {
                  _pickImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _submitCarInfo() async {
    if (_validateInputs()) {
      Car car = Car(
        name: _nameController.text,
        brandId: int.parse(_brandController.text),
        year: int.parse(_yearController.text),
        price: double.parse(_priceController.text),
        status: 'Chờ duyệt',
        description: _descriptionController.text,
        imageUrl: _imageFile?.path,
        sellerId: 1, // Giả sử seller_id là 1
        location: _locationController.text,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      var response = await _apiService.postCarData(car);

      if (response.statusCode == 201) {
        // Lấy carId từ body của response
        var responseData = json.decode(response.body);
        var carId = responseData['carId'];
        print('Car ID: $carId');
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Đăng bán xe thành công!')));

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CarConditionForm(
                carId: carId), // Truyền carId vào CarConditionForm
          ),
        );
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Lỗi: ${response.body}')));
      }
    }
  }

  bool _validateInputs() {
    if (_nameController.text.isEmpty) {
      _showErrorDialog('Vui lòng nhập tên xe');
      return false;
    }
    if (_brandController.text.isEmpty) {
      _showErrorDialog('Vui lòng chọn hãng xe');
      return false;
    }
    if (_yearController.text.isEmpty) {
      _showErrorDialog('Vui lòng nhập năm sản xuất');
      return false;
    }
    if (_priceController.text.isEmpty) {
      _showErrorDialog('Vui lòng nhập giá xe');
      return false;
    }
    if (_locationController.text.isEmpty) {
      _showErrorDialog('Vui lòng nhập địa chỉ');
      return false;
    }
    return true;
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Lỗi'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('Đóng'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Đăng Bán Xe'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GestureDetector(
              onTap: _showImageSourceDialog,
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: _imageFile != null
                    ? Image.file(_imageFile!, fit: BoxFit.cover)
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.camera_alt, size: 50, color: Colors.grey),
                          Text('Thêm ảnh xe',
                              style: TextStyle(color: Colors.grey)),
                        ],
                      ),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Tên xe',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.car_rental),
              ),
            ),
            SizedBox(height: 16),
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : DropdownButtonFormField<int>(
                    decoration: InputDecoration(
                      labelText: 'Hãng xe',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.branding_watermark),
                    ),
                    items: _carBrands.map((Brand brand) {
                      return DropdownMenuItem<int>(
                        value: brand.brandId,
                        child: Text(brand.name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      _brandController.text = value.toString();
                    },
                  ),
            SizedBox(height: 16),
            TextField(
              controller: _yearController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Năm sản xuất',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.calendar_today),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Giá xe (VNĐ)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.attach_money),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Mô tả xe',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.description),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _locationController,
              decoration: InputDecoration(
                labelText: 'Địa chỉ',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.location_on),
              ),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: _submitCarInfo,
              child: Text('Đăng bán xe'),
            ),
          ],
        ),
      ),
    );
  }
}
