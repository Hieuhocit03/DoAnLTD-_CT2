import 'package:flutter/material.dart';

class PostApprovalScreen extends StatefulWidget {
  @override
  _PostApprovalScreenState createState() => _PostApprovalScreenState();
}

class _PostApprovalScreenState extends State<PostApprovalScreen> {
  final List<Map<String, dynamic>> pendingPosts = [
    {
      'title': 'Xe Toyota Camry 2022',
      'author': 'Nguyễn Văn A',
      'content': 'Xe mới 90%, giá tốt...',
      'imageUrl': 'https://files01.danhgiaxe.com/KXTFEP1g8UamhxlZblSJhVrZWsw=/fit-in/1280x0/20220824/_mg_8579-145636.jpg',
      'status': 'Chờ duyệt'
    },
    {
      'title': 'Xe Honda Civic 2021',
      'author': 'Trần Thị B',
      'content': 'Xe gia đình, sử dụng kỹ...',
      'imageUrl': 'https://otohondabacgiang.com/wp-content/uploads/2021/05/uu-diem-cua-honda-civic-2021-trong-phan-khuc-cua-minh-phan-2-2.jpg',
      'status': 'Chờ duyệt'
    }
  ];

  void _showPostDetailDialog(Map<String, dynamic> post) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Chi Tiết Bài Viết'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(post['imageUrl'], height: 200),
                SizedBox(height: 10),
                Text('Tiêu đề: ${post['title']}',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text('Tác giả: ${post['author']}'),
                Text('Nội dung: ${post['content']}'),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('Duyệt'),
              onPressed: () {
                // Logic duyệt bài
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Từ chối'),
              onPressed: () {
                // Logic từ chối bài
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Duyệt Bài Viết')),
      body: ListView.builder(
        itemCount: pendingPosts.length,
        itemBuilder: (context, index) {
          final post = pendingPosts[index];
          return Card(
            child: ListTile(
              leading: Image.network(post['imageUrl'], width: 80),
              title: Text(post['title']),
              subtitle: Text(post['author']),
              trailing: Text(post['status'],
                  style: TextStyle(color: Colors.orange)),
              onTap: () => _showPostDetailDialog(post),
            ),
          );
        },
      ),
    );
  }
}