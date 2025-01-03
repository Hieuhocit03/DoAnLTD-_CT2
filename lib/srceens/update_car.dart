import 'package:flutter/material.dart';
import '../models/car.dart';
import '../models/car_condition.dart';
import '../models/car_specifications.dart';
import '../services/api_service.dart'; // Service để gọi API
import '../models/brand.dart';
import '../models/car_models.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class EditCarScreen extends StatefulWidget {
  final int carId;

  const EditCarScreen({Key? key, required this.carId}) : super(key: key);

  @override
  _EditCarScreenState createState() => _EditCarScreenState();
}

class _EditCarScreenState extends State<EditCarScreen> {
  final _formKey = GlobalKey<FormState>();
  final apiService = ApiService();
  String? selectedCarModelName;
  int? selectedCarModelId;
  List<CarModel> carModels = [];
  File? _image;

  Future<void> loadCarModels() async {
    carModels = await apiService.fetchCarModelNames();
    setState(() {}); // Cập nhật lại giao diện
  }

  // Tải danh sách car models khi widget được khởi tạo
  @override
  void initState() {
    super.initState();
    loadCarModels();
    _fetchCarDetails();
  }

  Car? _car;
  CarCondition? _carCondition;
  CarSpecification? _carSpecification;

  bool _isLoading = true;

  Future<void> _fetchCarDetails() async {
    try {
      final cars = await apiService.fetchCarDetails(widget.carId);
      final carCondition = await apiService.fetchCarCondition(widget.carId);
      final carSpecification =
      await apiService.fetchCarSpecifications(widget.carId);

      setState(() {
        _car = cars.isNotEmpty ? cars[0] : null; // Chỉ lấy xe đầu tiên nếu có
        _carCondition = carCondition.isNotEmpty ? carCondition[0] : null;
        _carSpecification = carSpecification.isNotEmpty ? carSpecification[0] : null;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching car details: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to load car details'),
        backgroundColor: Colors.red,
      ));
    }
  }

  Future<void> _updateCarDetails() async {
    if (_formKey.currentState!.validate()) {
      try {
        _formKey.currentState!.save();

        await ApiService.updateCar(_car!);
        await ApiService.updateCarCondition(_carCondition!);
        await ApiService.updateCarSpecification(_carSpecification!);

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Car details updated successfully'),
          backgroundColor: Colors.green,
        ));

        Navigator.pop(context);
      } catch (e) {
        print('Error updating car details: $e');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to update car details'),
          backgroundColor: Colors.red,
        ));
      }
    }
  }

  Future<String?> _saveImageToDevice(File imageFile) async {
    try {
      // Lấy thư mục lưu trữ hợp lệ trên bộ nhớ ngoài
      final directory = await getExternalStorageDirectory(); // Dùng getExternalStorageDirectory
      final customDirectoryPath = path.join(directory!.parent.path,
          'com.example.do_an_app', 'files'); // Đường dẫn của thư mục app
      final customDirectory = Directory(customDirectoryPath);

      // Nếu thư mục chưa tồn tại, tạo mới
      if (!await customDirectory.exists()) {
        await customDirectory.create(recursive: true);
      }

      // Đặt tên file và đường dẫn lưu ảnh (sử dụng thời gian hiện tại để đảm bảo tên file duy nhất)
      final imagePath = path.join(customDirectory.path,
          '${DateTime.now().millisecondsSinceEpoch}.jpg');

      // Sao chép ảnh vào thư mục chỉ định
      final savedImage = await imageFile.copy(imagePath);

      // Trả về đường dẫn ảnh đã lưu
      return savedImage.path;
    } catch (e) {
      print("Lỗi khi lưu ảnh: $e");
      return null;
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();

    // Mở một hộp thoại để chọn nguồn ảnh (thư viện hoặc camera)
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Chọn ảnh từ thư viện'),
                onTap: () async {
                  Navigator.of(context).pop(); // Đóng bottom sheet
                  final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
                  if (pickedFile != null) {
                    setState(() {
                      _image = File(pickedFile.path);
                    });
                    String? imagePath = await _saveImageToDevice(_image!);
                    if (imagePath != null) {
                      setState(() {
                        _car?.imageUrl = imagePath; // Cập nhật URL ảnh trong car object
                      });
                    }
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Chụp ảnh'),
                onTap: () async {
                  Navigator.of(context).pop(); // Đóng bottom sheet
                  final pickedFile = await _picker.pickImage(source: ImageSource.camera);
                  if (pickedFile != null) {
                    setState(() {
                      _image = File(pickedFile.path);
                    });
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sửa thông tin xe'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Car Information',
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                _buildCarForm(),
                SizedBox(height: 20),
                Text(
                  'Car Condition',
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                _buildCarConditionForm(),
                SizedBox(height: 20),
                Text(
                  'Car Specification',
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                _buildCarSpecificationForm(),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _updateCarDetails,
                  child: Text('Update'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCarForm() {
    return Column(
      children: [
        GestureDetector(
          onTap: _pickImage, // Nhấn vào ảnh để thay đổi
          child: _image == null
              ? Container(
            height: 200,
            width: double.infinity,
            color: Colors.grey[300],
            child: Center(child: Text('Tap to choose image')),
          )
              : Image.file(
            _image!,
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        // Name field
        TextFormField(
          initialValue: _car?.name ?? '',
          decoration: InputDecoration(labelText: 'Name'),
          onSaved: (value) {
            if (value != null) _car?.name = value;
          },
        ),

        // Year field
        TextFormField(
          initialValue: _car?.year?.toString() ?? '',
          decoration: InputDecoration(labelText: 'Year'),
          keyboardType: TextInputType.number,
          onSaved: (value) {
            if (value != null) _car?.year = int.tryParse(value)!;
          },
        ),

        // Price field
        TextFormField(
          initialValue: _car?.price?.toString() ?? '',
          decoration: InputDecoration(labelText: 'Price'),
          keyboardType: TextInputType.number,
          onSaved: (value) {
            if (value != null) _car?.price = double.tryParse(value) ?? 0;
          },
        ),

        // Description field
        TextFormField(
          initialValue: _car?.description ?? '',
          decoration: InputDecoration(labelText: 'Description'),
          onSaved: (value) {
            if (value != null) _car?.description = value;
          },
        ),

        // Location field
        TextFormField(
          initialValue: _car?.location ?? '',
          decoration: InputDecoration(labelText: 'Location'),
          onSaved: (value) {
            if (value != null) _car?.location = value;
          },
        ),

        // Brand dropdown
        FutureBuilder<List<Brand>>(

          future: apiService.fetchBrands(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error loading brands');
            } else if (snapshot.hasData) {
              List<Brand> brands = snapshot.data!;
              return DropdownButtonFormField<int>(
                value: _car?.brandId,
                decoration: InputDecoration(labelText: 'Brand'),
                items: brands.map((brand) {
                  return DropdownMenuItem<int>(
                    value: brand.brandId,
                    child: Text(brand.name),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _car?.brandId = value!;
                  });
                },
              );
            } else {
              return Text('No brands available');
            }
          },
        ),
      ],
    );
  }

  Future<DateTime?> _selectDate(BuildContext context) async {
    final initialDate = DateTime.now();
    final firstDate = DateTime(2000);
    final lastDate = DateTime(2101);

    return await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );
  }

  Widget _buildCarConditionForm() {
    final TextEditingController registrationExpiryController =
    TextEditingController(
      text: _carCondition?.registrationExpiry != null
          ? _carCondition!.registrationExpiry!.toLocal().toString().split(' ')[0]
          : '',
    );
    return Column(
      children: [
        // Kilometers Driven
        TextFormField(
          initialValue: _carCondition?.kmDriven?.toString() ?? '',
          decoration: InputDecoration(labelText: 'Kilometers Driven'),
          keyboardType: TextInputType.number,
          onSaved: (value) {
            if (value != null) _carCondition?.kmDriven = int.tryParse(value) ?? 0;
          },
        ),

        // Owners Count
        TextFormField(
          initialValue: _carCondition?.ownersCount?.toString() ?? '',
          decoration: InputDecoration(labelText: 'Owners Count'),
          keyboardType: TextInputType.number,
          onSaved: (value) {
            if (value != null) _carCondition?.ownersCount = int.tryParse(value) ?? 0;
          },
        ),

        // License Type
        TextFormField(
          initialValue: _carCondition?.licenseType ?? '',
          decoration: InputDecoration(labelText: 'License Type'),
          onSaved: (value) {
            if (value != null) _carCondition?.licenseType = value;
          },
        ),

        // Accessories
        TextFormField(
          initialValue: _carCondition?.accessories ?? '',
          decoration: InputDecoration(labelText: 'Accessories'),
          onSaved: (value) {
            if (value != null) _carCondition?.accessories = value;
          },
        ),

        // Registration Expiry (Date Picker)
        GestureDetector(
          onTap: () async {
            final selectedDate = await _selectDate(context);
            if (selectedDate != null) {
              setState(() {
                _carCondition?.registrationExpiry = selectedDate;
                registrationExpiryController.text =
                selectedDate.toLocal().toString().split(' ')[0];
              });
            }
          },
          child: AbsorbPointer(
            child: TextFormField(
              controller: registrationExpiryController,
              decoration: InputDecoration(labelText: 'Registration Expiry'),
              onSaved: (value) {
                if (value != null && value.isNotEmpty) {
                  // Convert to DateTime if needed
                  _carCondition?.registrationExpiry = DateTime.tryParse(value);
                }
              },
            ),
          ),
        ),

        // Origin
        TextFormField(
          initialValue: _carCondition?.origin ?? '',
          decoration: InputDecoration(labelText: 'Origin'),
          onSaved: (value) {
            if (value != null) _carCondition?.origin = value;
          },
        ),

        // Status
        TextFormField(
          initialValue: _carCondition?.status ?? '',
          decoration: InputDecoration(labelText: 'Condition Status'),
          onSaved: (value) {
            if (value != null) _carCondition?.status = value;
          },
        ),

        // Warranty Policy
        TextFormField(
          initialValue: _carCondition?.warrantyPolicy ?? '',
          decoration: InputDecoration(labelText: 'Warranty Policy'),
          onSaved: (value) {
            if (value != null) _carCondition?.warrantyPolicy = value;
          },
        ),
      ],
    );
  }



  Widget _buildCarSpecificationForm() {
    // Controller để lưu trữ tên của model được chọ

    return Column(
      children: [
        // Version
        TextFormField(
          initialValue: _carSpecification?.version ?? '',
          decoration: InputDecoration(labelText: 'Version'),
          onSaved: (value) {
            if (value != null) _carSpecification?.version = value;
          },
        ),

        // Transmission
        TextFormField(
          initialValue: _carSpecification?.transmission ?? '',
          decoration: InputDecoration(labelText: 'Transmission'),
          onSaved: (value) {
            if (value != null) _carSpecification?.transmission = value;
          },
        ),

        // Fuel Type
        TextFormField(
          initialValue: _carSpecification?.fuelType ?? '',
          decoration: InputDecoration(labelText: 'Fuel Type'),
          onSaved: (value) {
            if (value != null) _carSpecification?.fuelType = value;
          },
        ),

        // Body Style
        TextFormField(
          initialValue: _carSpecification?.bodyStyle ?? '',
          decoration: InputDecoration(labelText: 'Body Style'),
          onSaved: (value) {
            if (value != null) _carSpecification?.bodyStyle = value;
          },
        ),

        // Seats
        TextFormField(
          initialValue: _carSpecification?.seats?.toString() ?? '',
          decoration: InputDecoration(labelText: 'Seats'),
          keyboardType: TextInputType.number,
          onSaved: (value) {
            if (value != null) _carSpecification?.seats = int.tryParse(value);
          },
        ),

        // Drivetrain
        TextFormField(
          initialValue: _carSpecification?.drivetrain ?? '',
          decoration: InputDecoration(labelText: 'Drivetrain'),
          onSaved: (value) {
            if (value != null) _carSpecification?.drivetrain = value;
          },
        ),

        // Engine Type
        TextFormField(
          initialValue: _carSpecification?.engineType ?? '',
          decoration: InputDecoration(labelText: 'Engine Type'),
          onSaved: (value) {
            if (value != null) _carSpecification?.engineType = value;
          },
        ),

        // Horsepower
        TextFormField(
          initialValue: _carSpecification?.horsepower ?? '',
          decoration: InputDecoration(labelText: 'Horsepower'),
          onSaved: (value) {
            if (value != null) _carSpecification?.horsepower = value;
          },
        ),

        // Torque
        TextFormField(
          initialValue: _carSpecification?.torque ?? '',
          decoration: InputDecoration(labelText: 'Torque'),
          onSaved: (value) {
            if (value != null) _carSpecification?.torque = value;
          },
        ),

        // Engine Capacity
        TextFormField(
          initialValue: _carSpecification?.engineCapacity?.toString() ?? '',
          decoration: InputDecoration(labelText: 'Engine Capacity'),
          keyboardType: TextInputType.number,
          onSaved: (value) {
            if (value != null) _carSpecification?.engineCapacity = value;
          },
        ),

        // Fuel Consumption
        TextFormField(
          initialValue: _carSpecification?.fuelConsumption?.toString() ?? '',
          decoration: InputDecoration(labelText: 'Fuel Consumption'),
          keyboardType: TextInputType.number,
          onSaved: (value) {
            if (value != null) _carSpecification?.fuelConsumption = value;
          },
        ),

        // Airbags
        TextFormField(
          initialValue: _carSpecification?.airbags?.toString() ?? '',
          decoration: InputDecoration(labelText: 'Airbags'),
          keyboardType: TextInputType.number,
          onSaved: (value) {
            if (value != null) _carSpecification?.airbags = int.tryParse(value);
          },
        ),

        // Ground Clearance
        TextFormField(
          initialValue: _carSpecification?.groundClearance?.toString() ?? '',
          decoration: InputDecoration(labelText: 'Ground Clearance'),
          keyboardType: TextInputType.number,
          onSaved: (value) {
            if (value != null) _carSpecification?.groundClearance = value;
          },
        ),

        // Doors
        TextFormField(
          initialValue: _carSpecification?.doors?.toString() ?? '',
          decoration: InputDecoration(labelText: 'Doors'),
          keyboardType: TextInputType.number,
          onSaved: (value) {
            if (value != null) _carSpecification?.doors = int.tryParse(value);
          },
        ),

        // Weight
        TextFormField(
          initialValue: _carSpecification?.weight?.toString() ?? '',
          decoration: InputDecoration(labelText: 'Weight'),
          keyboardType: TextInputType.number,
          onSaved: (value) {
            if (value != null) _carSpecification?.weight = value;
          },
        ),

        // Payload Capacity
        TextFormField(
          initialValue: _carSpecification?.payloadCapacity?.toString() ?? '',
          decoration: InputDecoration(labelText: 'Payload Capacity'),
          keyboardType: TextInputType.number,
          onSaved: (value) {
            if (value != null) _carSpecification?.payloadCapacity = value;
          },
        ),

        // Car Model
        DropdownButtonFormField<String>(
          value: selectedCarModelName,
          decoration: InputDecoration(labelText: 'Car Model'),
          items: carModels.map((model) {
            return DropdownMenuItem<String>(
              value: model.name,
              child: Text(model.name),
            );
          }).toList(),
          onChanged: (value) {
            final selectedModel =
            carModels.firstWhere((model) => model.name == value);
            setState(() {
              selectedCarModelName = value;
              selectedCarModelId = selectedModel.id;
            });
          },
          onSaved: (_) {
            _carSpecification?.carModelId = selectedCarModelId;
          },
        ),
      ],
    );
  }
}

