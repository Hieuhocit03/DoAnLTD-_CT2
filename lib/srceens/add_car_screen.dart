import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../models/car.dart';
import '../models/brand.dart';

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
  final TextEditingController _locationController =
      TextEditingController(); // Controller for location

  // Biến lưu trữ hình ảnh
  File? _imageFile;

  List<Brand> _carBrands = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCarBrands(); // Gọi API khi màn hình được khởi tạo
  }

  Future<void> _fetchCarBrands() async {
    try {
      final response =
          await http.get(Uri.parse('http://localhost:3000/api/brands'));

      if (response.statusCode == 200) {
        // Nếu thành công, parse dữ liệu từ API
        List<dynamic> data = json.decode(response.body);
        setState(() {
          // Chuyển đổi dữ liệu JSON thành danh sách các đối tượng Brand
          _carBrands =
              data.map((brandJson) => Brand.fromJson(brandJson)).toList();
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        _showErrorDialog('Không thể tải danh sách hãng xe.');
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      _showErrorDialog('Đã xảy ra lỗi khi tải dữ liệu.');
    }
  }

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
  Future<void> _submitCarInfo() async {
    if (_validateInputs()) {
      Car car = Car(
        name: _nameController.text,
        brandId: int.parse(
            _brandController.text), // Lấy brand_id từ _brandController
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

      // Gửi dữ liệu lên API
      var response = await _postCarData(car);

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Đăng bán xe thành công!')));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Lỗi: ${response.body}')));
      }
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
    if (_locationController.text.isEmpty) {
      _showErrorDialog('Vui lòng nhập địa chỉ');
      return false;
    }
    if (_brandController.text.isEmpty) {
      _showErrorDialog('Vui lòng chọn hãng xe');
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

  // Gửi yêu cầu POST để thêm xe
  Future<http.Response> _postCarData(Car car) async {
    final Uri url = Uri.parse('http://localhost:3000/api/cars');

    // Tạo đối tượng MultipartRequest để gửi dữ liệu, bao gồm ảnh nếu có
    var carJson = car.toJson();

    var response = await http.post(url,
        headers: {"Content-Type": "application/json"},
        body: json.encode(carJson));

    return response;
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
                          Text('Thêm ảnh xe',
                              style: TextStyle(color: Colors.grey)),
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
            _isLoading
                ? Center(
                    child:
                        CircularProgressIndicator()) // Hiển thị loading khi đang tải
                : DropdownButtonFormField<int>(
                    decoration: InputDecoration(
                      labelText: 'Hãng xe',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.branding_watermark),
                    ),
                    items: _carBrands.map((Brand brand) {
                      return DropdownMenuItem<int>(
                        value: brand.brandId, // Lưu giá trị id của hãng xe
                        child: Text(brand.name), // Hiển thị tên hãng xe
                      );
                    }).toList(),
                    onChanged: (value) {
                      // Lưu giá trị id hãng xe vào _brandController
                      _brandController.text = value.toString();
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
            SizedBox(height: 16),

            // Trường nhập địa chỉ
            TextField(
              controller: _locationController,
              decoration: InputDecoration(
                labelText: 'Địa chỉ',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.location_on),
              ),
            ),
            SizedBox(height: 16),

            // Nút đăng bán
            ElevatedButton(
              onPressed: _submitCarInfo,
              child: Text('Đăng Bán Xe'),
            ),
          ],
        ),
      ),
    );
  }
}
