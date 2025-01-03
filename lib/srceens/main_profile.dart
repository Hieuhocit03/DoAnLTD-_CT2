import 'package:flutter/material.dart';
import 'edit_profile_screen.dart';
import 'management_car_personal.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController; // Khai báo TabController

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        length: 2, vsync: this); // Khởi tạo TabController với 2 tab
  }

  @override
  void dispose() {
    _tabController.dispose(); // Đảm bảo giải phóng tài nguyên khi widget bị hủy
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hồ sơ cá nhân'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Cập nhật thông tin'), // Tab 1: Edit Profile
            Tab(text: 'Xe đã đăng'), // Tab 2: Car List
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          EditProfileScreen(), // Nội dung của Tab 1: Edit Profile
          CarListScreen(), // Nội dung của Tab 2: Car List
        ],
      ),
    );
  }
}
