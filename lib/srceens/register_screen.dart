import 'package:flutter/material.dart';
import '../database/database_helper.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String email = '';
  String password = '';
  String phone = '';

  void _register() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Lưu thông tin vào SQLite
      DatabaseHelper dbHelper = DatabaseHelper.instance;
      try {
        await dbHelper.insertUser({
          'name': name,
          'email': email,
          'password': password,
          'phone': phone,
        });

        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Đăng ký thành công')));
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Email đã tồn tại')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Đăng ký'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Tên'),
                validator: (value) =>
                value!.isEmpty ? 'Vui lòng nhập tên' : null,
                onSaved: (value) => name = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) =>
                value!.isEmpty ? 'Vui lòng nhập email' : null,
                onSaved: (value) => email = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Mật khẩu'),
                obscureText: true,
                validator: (value) =>
                value!.isEmpty ? 'Vui lòng nhập mật khẩu' : null,
                onSaved: (value) => password = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Số điện thoại'),
                validator: (value) =>
                value!.isEmpty ? 'Vui lòng nhập số điện thoại' : null,
                onSaved: (value) => phone = value!,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _register,
                child: Text('Đăng ký'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
