import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'dart:convert';
import '../models/car.dart';
import '../models/brand.dart';
import '../services/api_service.dart';
import 'car_input_form.dart';

class AddCarScreen extends StatefulWidget {
  const AddCarScreen({Key? key}) : super(key: key);

  @override
  _AddCarScreenState createState() => _AddCarScreenState();
}

class _AddCarScreenState extends State<AddCarScreen> {
  String? userId;
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
          // Kiểm tra xem có trường 'id' trong token không
          userId = decodedToken.containsKey('id')
              ? decodedToken['id'].toString() // Chuyển 'id' từ int sang String
              : '30';
        });
      } catch (e) {
        print("Lỗi khi giải mã token: $e");
        setState(() {
          userId = "20";
        });
      }
    } else {
      print('Token không tồn tại');
      setState(() {
        userId = null;
      });
    }
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
    try {
      // Chọn ảnh
      final pickedFile = await ImagePicker().pickImage(source: source);
      if (pickedFile != null) {
        File imageFile = File(pickedFile.path);

        // Lưu ảnh vào thư mục ứng dụng
        final savedPath = await _saveImageToDevice(imageFile);
        if (savedPath != null) {
          setState(() {
            _imageFile = File(savedPath); // Cập nhật trạng thái với ảnh đã lưu
          });
        }
      }
    } catch (e) {
      print("Lỗi khi chọn hoặc lưu ảnh: $e");
    }
  }

  Future<List<File>> _getImagesFromStorage() async {
    try {
      // Lấy thư mục chứa ảnh của ứng dụng
      final directory = await getExternalStorageDirectory();
      final customDirectoryPath =
          path.join(directory!.parent.path, 'com.example.do_an_app', 'files');
      final customDirectory = Directory(customDirectoryPath);

      // Lấy tất cả các file trong thư mục
      final List<FileSystemEntity> files = customDirectory.listSync();

      // Lọc ra các file ảnh (có đuôi .jpg, .png, .jpeg, .gif, v.v...)
      List<File> images = [];
      for (var file in files) {
        if (file is File &&
            (file.path.endsWith('.jpg') ||
                file.path.endsWith('.png') ||
                file.path.endsWith('.jpeg'))) {
          images.add(file);
        }
      }

      return images; // Trả về danh sách file ảnh
    } catch (e) {
      print("Lỗi khi lấy danh sách ảnh: $e");
      return [];
    }
  }

  void _showImagePicker(List<File> images) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Chọn ảnh'),
          content: SingleChildScrollView(
            child: Column(
              children: images.map((image) {
                return GestureDetector(
                  onTap: () {
                    // Lựa chọn ảnh và làm gì đó với ảnh đã chọn
                    setState(() {
                      _imageFile = image;
                    });
                    Navigator.of(context).pop();
                  },
                  child: Image.file(
                    image,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
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
                onTap: () async {
                  Navigator.of(context).pop(); // Đóng bottom sheet
                  // Lấy tất cả các ảnh từ thư mục đã lưu
                  List<File> images = await _getImagesFromStorage();
                  // Hiển thị các ảnh đã lấy được
                  _showImagePicker(images);
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
    print('userId: $userId');
    if (_validateInputs()) {
      // Lưu ảnh vào thư mục trong thiết bị
      String? imagePath;
      if (_imageFile != null) {
        imagePath = await _saveImageToDevice(_imageFile!);
      }

      Car car = Car(
        name: _nameController.text,
        brandId: int.parse(_brandController.text),
        year: int.parse(_yearController.text),
        price: double.parse(_priceController.text),
        status: 'Chờ duyệt',
        description: _descriptionController.text,
        imageUrl: imagePath, // Lưu đường dẫn ảnh vào car
        sellerId: int.tryParse(userId ?? '0') ?? 1, // Giả sử seller_id là 1
        location: _locationController.text,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      var response = await _apiService.postCarData(car);

      if (response.statusCode == 201) {
        var responseData = json.decode(response.body);
        var carId = responseData['carId'];
        print('Car ID: $carId');

        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Đăng bán xe thành công!')));

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CarConditionForm(carId: carId),
          ),
        );
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Lỗi: ${response.body}')));
      }
    }
  }

  Future<String?> _saveImageToDevice(File imageFile) async {
    try {
      // Lấy thư mục lưu trữ hợp lệ
      final directory =
          await getExternalStorageDirectory(); // Dùng getExternalStorageDirectory
      final customDirectoryPath = path.join(directory!.parent.path,
          'com.example.do_an_app', 'files'); // Đường dẫn của thư mục app
      final customDirectory = Directory(customDirectoryPath);

      // Nếu thư mục chưa tồn tại, tạo mới
      if (!await customDirectory.exists()) {
        await customDirectory.create(recursive: true);
      }

      // Đặt tên file và đường dẫn lưu ảnh
      final imagePath = path.join(
          customDirectory.path, '${DateTime.now().millisecondsSinceEpoch}.jpg');

      // Sao chép ảnh vào thư mục chỉ định
      final savedImage = await imageFile.copy(imagePath);
      return savedImage.path; // Trả về đường dẫn ảnh đã lưu
    } catch (e) {
      print("Lỗi khi lưu ảnh: $e");
      return null;
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
                    ? kIsWeb
                        ? Image.network(
                            _imageFile!.path) // Nếu là Web, dùng Image.network
                        : Image.file(_imageFile!,
                            fit: BoxFit.cover) // Nếu là Mobile, dùng Image.file
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
              controller: _locationController,
              decoration: InputDecoration(
                labelText: 'Địa chỉ',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.location_on),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Mô tả',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.description),
              ),
            ),
            SizedBox(height: 16),
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
