import 'package:flutter/material.dart';

class UserListPage extends StatelessWidget {
  final List<Map<String, String>> users = [
    {'name': 'Nguyễn Văn A', 'email': 'vana@example.com', 'status': 'Hoạt động'},
    {'name': 'Trần Thị B', 'email': 'thib@example.com', 'status': 'Bị khóa'},
    {'name': 'Lê Văn C', 'email': 'vanc@example.com', 'status': 'Hoạt động'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Danh sách người dùng'),
      ),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: ListTile(
              leading: Icon(Icons.person),
              title: Text(user['name']!),
              subtitle: Text(user['email']!),
              trailing: Text(
                user['status']!,
                style: TextStyle(
                  color: user['status'] == 'Hoạt động' ? Colors.green : Colors.red,
                ),
              ),
              onTap: () {
                // Handle user detail or action
              },
            ),
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
