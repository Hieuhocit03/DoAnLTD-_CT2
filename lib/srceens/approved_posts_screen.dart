import 'package:flutter/material.dart';
class ApprovedPostsScreen extends StatefulWidget {
  @override
  _ApprovedPostsScreenState createState() => _ApprovedPostsScreenState();
}

class _ApprovedPostsScreenState extends State<ApprovedPostsScreen> {
  final List<Map<String, dynamic>> approvedPosts = [
    {
      'title': 'Xe Mercedes C200 2020',
      'author': 'Lê Văn C',
      'approvalDate': '15/06/2023',
      'imageUrl': 'https://images.clickdealer.co.uk/vehicles/5758/5758645/large2/135106309.jpg'
    },
    {
      'title': 'Xe BMW 320i 2019',
      'author': 'Phạm Thị D',
      'approvalDate': '10/06/2023',
      'imageUrl': 'https://img1.oto.com.vn/2019/06/03/4Cs5VWrI/danh-gia-xe-bmw-320i-2019-oto-com-1-db59.jpg'
    }
  ];

  void _showPostDetailsDialog(Map<String, dynamic> post) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Chi Tiết Bài Viết Đã Duyệt'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.network(post['imageUrl'], height: 200),
              SizedBox(height: 10),
              Text('Tiêu đề: ${post['title']}'),
              Text('Tác giả: ${post['author']}'),
              Text('Ngày duyệt: ${post['approvalDate']}'),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Đóng'),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Bài Viết Đã Duyệt')),
      body: ListView.builder(
        itemCount: approvedPosts.length,
        itemBuilder: (context, index) {
          final post = approvedPosts[index];
          return Card(
            child: ListTile(
              leading: Image.network(post['imageUrl'], width: 80),
              title: Text(post['title']),
              subtitle: Text('Ngày duyệt: ${post['approvalDate']}'),
              onTap: () => _showPostDetailsDialog(post),
            ),
          );
        },
      ),
    );
  }
}