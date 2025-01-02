import 'package:flutter/material.dart';

class CarInputForm extends StatefulWidget {
  @override
  _CarInputFormState createState() => _CarInputFormState();
}

class _CarInputFormState extends State<CarInputForm> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for text fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  final TextEditingController _sellerIdController = TextEditingController();

  // Dropdown values
  String? _selectedBrand;
  String _status = 'Chờ duyệt';
git
  // Mock data for brands
  final List<Map<String, dynamic>> _brands = [
    {'id': 1, 'name': 'Toyota'},
    {'id': 2, 'name': 'Honda'},
    {'id': 3, 'name': 'Ford'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thêm xe mới'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Name field
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Tên xe'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập tên xe';
                  }
                  return null;
                },
              ),

              // Brand dropdown
              DropdownButtonFormField<String>(
                value: _selectedBrand,
                decoration: InputDecoration(labelText: 'Hãng xe'),
                items: _brands.map((brand) {
                  return DropdownMenuItem<String>(
                    value: brand['id'].toString(),
                    child: Text(brand['name']),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedBrand = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng chọn hãng xe';
                  }
                  return null;
                },
              ),

              // Year field
              TextFormField(
                controller: _yearController,
                decoration: InputDecoration(labelText: 'Năm sản xuất'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập năm sản xuất';
                  }
                  return null;
                },
              ),

              // Price field
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(labelText: 'Giá bán'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập giá bán';
                  }
                  return null;
                },
              ),

              // Status dropdown
              DropdownButtonFormField<String>(
                value: _status,
                decoration: InputDecoration(labelText: 'Trạng thái'),
                items: ['Đang bán', 'Đã bán', 'Chờ duyệt'].map((status) {
                  return DropdownMenuItem<String>(
                    value: status,
                    child: Text(status),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _status = value!;
                  });
                },
              ),

              // Description field
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Mô tả chi tiết'),
                maxLines: 5,
              ),

              // Image URL field
              TextFormField(
                controller: _imageUrlController,
                decoration: InputDecoration(labelText: 'Link hình ảnh'),
                keyboardType: TextInputType.url,
              ),

              // Seller ID field
              TextFormField(
                controller: _sellerIdController,
                decoration: InputDecoration(labelText: 'ID người bán'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập ID người bán';
                  }
                  return null;
                },
              ),

              // Submit button
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Form is valid, handle submission
                    print('Tên xe: ${_nameController.text}');
                    print('Hãng xe: $_selectedBrand');
                    print('Năm sản xuất: ${_yearController.text}');
                    print('Giá bán: ${_priceController.text}');
                    print('Trạng thái: $_status');
                    print('Mô tả: ${_descriptionController.text}');
                    print('Link hình ảnh: ${_imageUrlController.text}');
                    print('ID người bán: ${_sellerIdController.text}');
                  }
                },
                child: Text('Lưu'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
