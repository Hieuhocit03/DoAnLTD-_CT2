import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddCarScreen extends StatefulWidget {


  const AddCarScreen({Key? key}) : super(key: key);

  @override
  _AddCarScreenState createState() => _AddCarScreenState();
}

class _AddCarScreenState extends State<AddCarScreen> {
  // Controllers cho các trường nhập liệu
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // Biến lưu trữ hình ảnh
  File? _imageFile;

  // Danh sách các hãng xe
  final List<String> _carBrands = [
    'Toyota', 'Honda', 'Mazda', 'Hyundai',
    'Kia', 'Mercedes', 'BMW', 'Lexus'
  ];

  // Chọn hình ảnh từ nguồn
  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  // Hiển thị bottom sheet chọn ảnh
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

  // Xác nhận và gửi thông tin xe
  void _submitCarInfo() {
    // Validate dữ liệu
    if (_validateInputs()) {
      // Xử lý logic gửi thông tin xe
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đăng bán xe thành công!')),
      );
    }
  }

  // Kiểm tra tính hợp lệ của dữ liệu
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
    return true;
  }

  // Hiển thị dialog lỗi
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
            // Chọn ảnh xe
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
                    Text('Thêm ảnh xe', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),

            // Trường nhập tên xe
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Tên xe',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.car_rental),
              ),
            ),
            SizedBox(height: 16),

            // Dropdown chọn hãng xe
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Hãng xe',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.branding_watermark),
              ),
              items: _carBrands.map((String brand) {
                return DropdownMenuItem(
                  value: brand,
                  child: Text(brand),
                );
              }).toList(),
              onChanged: (value) {
                _brandController.text = value!;
              },
            ),
            SizedBox(height: 16),

            // Trường nhập năm sản xuất
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

            // Trường nhập giá xe
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

            // Trường mô tả
            TextField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Mô tả xe',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.description),
              ),
            ),
            SizedBox(height: 24),

            // Nút đăng bán
            ElevatedButton(
              onPressed: _submitCarInfo,
              style: ElevatedButton.styleFrom(
                backgroundColor : Colors.blue,
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text('Đăng Bán Xe'),
            ),
          ],
        ),
      ),
    );
  }
}