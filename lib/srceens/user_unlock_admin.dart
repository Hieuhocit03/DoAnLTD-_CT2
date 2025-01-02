import 'package:flutter/material.dart';

class LockUnlockUserPage extends StatelessWidget {
  final List<Map<String, String>> users = [
    {'name': 'Nguyễn Văn A', 'email': 'vana@example.com', 'status': 'Hoạt động'},
    {'name': 'Trần Thị B', 'email': 'thib@example.com', 'status': 'Bị khóa'},
    {'name': 'Lê Văn C', 'email': 'vanc@example.com', 'status': 'Hoạt động'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Khóa/Mở khóa tài khoản người dùng'),
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
              trailing: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                  user['status'] == 'Hoạt động' ? Colors.red : Colors.green,
                ),
                onPressed: () {
                  // Logic for toggling user status
                },
                child: Text(user['status'] == 'Hoạt động' ? 'Khóa' : 'Mở khóa'),
              ),
            ),
          );
        },
      ),
    );
  }
}
