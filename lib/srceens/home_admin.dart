import 'package:do_an_app/srceens/user_list_admin.dart';
import 'package:do_an_app/srceens/user_unlock_admin.dart';
import 'package:do_an_app/srceens/profile_screen.dart';
import 'package:flutter/material.dart';

class HomeAdminPage extends StatefulWidget {
  @override
  _HomeAdminPageState createState() => _HomeAdminPageState();
}

class _HomeAdminPageState extends State<HomeAdminPage> {
  bool _isUserManagementExpanded = false;
  bool _isPostManagementExpanded = false;
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 1) { // Index 1 tương ứng với "Cài đặt"
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProfileScreen()), // Điều hướng tới ProfileScreen
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trang Quản Trị Admin'),
        backgroundColor: Colors.blueGrey,
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
                        MaterialPageRoute(
                            builder: (context) => UserListPage()));
                  },
                ),
                ListTile(
                  title: Text('Khóa/Mở khóa tài khoản người dùng'),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LockUnlockUserPage()));
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
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Quản lý',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Cài đặt',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blueGrey,
        onTap: _onItemTapped,
      ),
    );
  }
}
