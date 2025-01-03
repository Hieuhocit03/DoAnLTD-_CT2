import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/user.dart';

class LockUnlockUserPage extends StatefulWidget {
  @override
  _LockUnlockUserPageState createState() => _LockUnlockUserPageState();
}

class _LockUnlockUserPageState extends State<LockUnlockUserPage> {
  List<User> users = []; // Danh sách người dùng
  bool isLoading = true;

  // Lấy danh sách người dùng từ API
  Future<void> fetchUsers() async {
    const url = 'http://10.0.122.239:3000/api/users/users';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['data'];
        setState(() {
          users = data.map((user) => User.fromJson(user)).toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load users');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching users: $e');
    }
  }

  // Cập nhật trạng thái người dùng (khóa/mở khóa)
  Future<void> toggleUserStatus(User user) async {
    final newStatus = user.status == 'active' ? 'locked' : 'active';
    final url = 'http://10.0.122.239:3000/api/users/users/${user.userId}';
    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'status': newStatus, 'userId': user.userId}),
      );

      if (response.statusCode == 200) {
        setState(() {
          user.status = newStatus; // Cập nhật trạng thái trong danh sách
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Cập nhật trạng thái thành công!'),
        ));
      } else {
        throw Exception('Failed to update status');
      }
    } catch (e) {
      print('Error updating user status: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Cập nhật trạng thái thất bại!'),
      ));
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUsers(); // Gọi API để lấy danh sách người dùng
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Khóa/Mở khóa tài khoản người dùng'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: ListTile(
                    leading: Icon(Icons.person),
                    title: Text(user.name ?? 'No Name'),
                    subtitle: Text(user.email),
                    trailing: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            user.status == 'active' ? Colors.red : Colors.green,
                      ),
                      onPressed: () => toggleUserStatus(user),
                      child: Text(user.status == 'active' ? 'Khóa' : 'Mở khóa'),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
