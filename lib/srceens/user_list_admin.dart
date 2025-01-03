import 'package:flutter/material.dart';
import '../models/user.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../services/api_service.dart';
import 'car_list_admin.dart';

class UserListPage extends StatefulWidget {
  @override
  _UserListPageState createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  late Future<List<User>> _users;

  @override
  void initState() {
    super.initState();
    _users = ApiService.fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Danh sách người dùng'),
      ),
      body: FutureBuilder<List<User>>(
        future: _users,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Có lỗi xảy ra: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Không có người dùng nào'));
          }

          final users = snapshot.data!;
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: ListTile(
                  leading: Icon(Icons.person),
                  title: Text(user.name ?? 'Không rõ'),
                  subtitle: Text(user.email),
                  trailing: Text(
                    user.status == 'active' ? 'Hoạt động' : 'Bị khóa',
                    style: TextStyle(
                      color:
                          user.status == 'active' ? Colors.green : Colors.red,
                    ),
                  ),
                  onTap: () {
                    // Handle user detail or action
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class HomeAdminPage extends StatefulWidget {
  @override
  _HomeAdminPageState createState() => _HomeAdminPageState();
}

class _HomeAdminPageState extends State<HomeAdminPage> {
  bool _isUserManagementExpanded = false;
  bool _isPostManagementExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trang Quản Trị Admin'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          // User Management
          Card(
            child: ExpansionTile(
              title: Text('Quản lý người dùng',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              initiallyExpanded: _isUserManagementExpanded,
              onExpansionChanged: (expanded) {
                setState(() {
                  _isUserManagementExpanded = expanded;
                });
              },
              children: [
                ListTile(
                  title: Text('Xem danh sách người dùng'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => UserListPage()),
                    );
                  },
                ),
                ListTile(
                  title: Text('Khóa/Mở khóa tài khoản người dùng'),
                  onTap: () {
                    // Navigate to user status management page
                  },
                ),
              ],
            ),
          ),

          // Post Management
          Card(
            child: ExpansionTile(
              title: Text('Quản lý bài viết',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              initiallyExpanded: _isPostManagementExpanded,
              onExpansionChanged: (expanded) {
                setState(() {
                  _isPostManagementExpanded = expanded;
                });
              },
              children: [
                ListTile(
                  title: Text('Duyệt bài viết'),
                  onTap: () {
                    // Navigate to post approval page
                  },
                ),
                ListTile(
                  title: Text('Duyệt trạng thái bài viết'),
                  onTap: () {
                    // Navigate to post status management page
                  },
                ),
                ListTile(
                  title: Text('Bài viết đã duyệt'),
                  onTap: () {
                    // Navigate to approved posts page
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
