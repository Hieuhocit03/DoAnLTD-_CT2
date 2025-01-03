import 'package:flutter/material.dart';

class PostStatusManagementScreen extends StatefulWidget {
  @override
  _PostStatusManagementScreenState createState() => _PostStatusManagementScreenState();
}

class _PostStatusManagementScreenState extends State<PostStatusManagementScreen> {
  final List<Map<String, dynamic>> postStatuses = [
    {
      'title': 'Xe Toyota Camry',
      'currentStatus': 'Hoạt Động',
      'statusOptions': ['Hoạt Động', 'Tạm Ẩn', 'Khóa']
    },
    {
      'title': 'Xe Honda Civic',
      'currentStatus': 'Tạm Ẩn',
      'statusOptions': ['Hoạt Động', 'Tạm Ẩn', 'Khóa']
    }
  ];

  void _showStatusChangeDialog(Map<String, dynamic> post) {
    String selectedStatus = post['currentStatus'];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Thay Đổi Trạng Thái Bài Viết'),
              content: DropdownButton<String>(
                value: selectedStatus,
                items: post['statusOptions']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedStatus = newValue!;
                  });
                },
              ),
              actions: [
                TextButton(
                  child: Text(' Lưu'),
                  onPressed: () {
                    // Logic lưu trạng thái mới
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text('Hủy'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Quản Lý Trạng Thái Bài Viết')),
      body: ListView.builder(
        itemCount: postStatuses.length,
        itemBuilder: (context, index) {
          final post = postStatuses[index];
          return Card(
            child: ListTile(
              title: Text(post['title']),
              subtitle: Text('Trạng thái hiện tại: ${post['currentStatus']}'),
              onTap: () => _showStatusChangeDialog(post),
            ),
          );
        },
      ),
    );
  }
}