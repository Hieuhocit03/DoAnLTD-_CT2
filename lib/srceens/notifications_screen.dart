import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final notifications = [
      'Thông báo 1: Xe Toyota Camry đã được thêm vào danh sách yêu thích.',
      'Thông báo 2: Xe Mazda 3 đã có người liên hệ.',
      'Thông báo 3: Hello World.'
          'Thông báo 3: Hãy đăng kí kênh TITV nhé !!!!!'
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Thông báo'),
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16.0),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.only(bottom: 12),
            child: ListTile(
              title: Text(notifications[index]),
              leading: Icon(Icons.notifications, color: Colors.blue),
            ),
          );
        },
      ),
    );
  }
}
