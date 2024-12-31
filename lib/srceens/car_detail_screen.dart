import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'home_screen.dart';
class CarDetailScreen extends StatelessWidget {
  @override
  final Map<String, dynamic> car;
  CarDetailScreen({required this.car});

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Quay lại màn hình trước đó
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {},
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCarImageSection(),
            _buildCarDetailsSection(),

            _buildSpecificationsSection(),
            _buildCarImageSection2(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomActionBar(context),
    );
  }

  Widget _buildCarImageSection() {
    return Container(
      height: 250,
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage('${car['coverImage']}'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildCarDetailsSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            car['name'],
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5),
          Text(
            '20:30 | 25 tháng 12, 2024',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.blueGrey,
            ),
          ),
          SizedBox(height: 8),
          Text(
            car['description'],
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 25),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              car['price'],
              style: TextStyle(
                fontSize: 20,
                color: Colors.blueGrey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecificationsSection() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          _buildSpecificationRow('Hãng', '${car['brand']}'),
          _buildSpecificationRow('Dòng', '${car['model']}'),
          _buildSpecificationRow('Màu', '${car['color']}'),
          _buildSpecificationRow('Năm sản xuất', '${car['year']}'),
        ],
      ),
    );
  }


  Widget _buildSpecificationRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  void _showEnlargedImage(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.8),
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.all(10),
          child: Stack(
            alignment: Alignment.center,
            children: [
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: InteractiveViewer(
                  panEnabled: true,
                  boundaryMargin: EdgeInsets.all(80),
                  minScale: 0.5,
                  maxScale: 4.0,
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.9,
                      maxHeight: MediaQuery.of(context).size.height * 0.8,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      image: DecorationImage(
                        image: NetworkImage(imageUrl),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),
              // Nút đóng (tùy chọn)
              Positioned(
                top: 0,
                left: 20,
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blueGrey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 10,
                        offset: Offset(0, 3), // Đổ bóng theo hướng x và y
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: Icon(Icons.close, color: Colors.white, size: 30),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }


  Widget _buildCarImageSection2() {
    if (car['detailImage'] != null && car['detailImage'].isNotEmpty) {
      return Container(
        height: 250,
        width: double.infinity,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: car['detailImage'].length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () => _showEnlargedImage(context, car['detailImage'][index]),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 8.0),
                width: 250,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  image: DecorationImage(
                    image: NetworkImage(car['detailImage'][index]),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            );
          },
        ),
      );
    } else {
      return Container();
    }
  }

  Widget _buildBottomActionBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: ElevatedButton(
        onPressed: () => _showSellerInfoDialog(context),
        child: Text(
          'MUA NGAY',
          style: TextStyle(
            //fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueGrey,
          minimumSize: Size(double.infinity, 50),
        ),
      ),
    );
  }

  void _showSellerInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            textAlign: TextAlign.center,
            'Seller Information',
            style: TextStyle(
              fontSize: 20,
            ),

          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage('${car['sellerImage']}'),
              ),
              SizedBox(height: 16),
              Text(
                car['sellerName'],
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              _buildContactRow(
                icon: Icons.phone,
                text: car['phone'],
                onTap: () => _launchPhone(car['phone']),
              ),
              SizedBox(height: 8),
              _buildContactRow(
                icon: Icons.email,
                text: car['email'].length > 25 ? car['email'].substring(0, 25) + '...' : car['email'],
                onTap: () => _launchEmail(car['email']),
              ),
              SizedBox(height: 8),
              _buildContactRow(
                icon: Icons.location_on,
                text: car['location'].length > 25 ? car['location'].substring(0, 25) + '...' : car['location'],
                onTap: () => _launchLocation(car['location']),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Đóng',
                style: TextStyle(
                  color: Colors.blueGrey,
                  fontWeight: FontWeight.bold,
                ),
              ),

            ),
          ],
        );
      },
    );
  }

// Phương thức tạo dòng thông tin liên hệ
  Widget _buildContactRow({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, color: Colors.blue),
          SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              color: Colors.blue,
              decoration: TextDecoration.underline,
            ),
          ),
        ],
      ),
    );
  }


// Phương thức gọi điện thoại
  void _launchPhone(String phoneNumber) async {
    final Uri phoneUri = Uri.parse('tel:$phoneNumber');
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      print('Could not launch phone app');
    }
  }

// Phương thức gửi email
  void _launchEmail(String email) async {
    final Uri emailUri = Uri.parse('mailto:$email');
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      print('Could not launch email app');
    }
  }

  void _launchLocation(String location) async {
    // Mã hóa địa chỉ để sử dụng trong URL
    String encodedLocation = Uri.encodeComponent(location);

    // URL của Google Maps
    final Uri mapUri = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=$encodedLocation'
    );

    try {
      // Kiểm tra và mở URL
      if (await canLaunchUrl(mapUri)) {
        await launchUrl(
          mapUri,
          mode: LaunchMode.externalApplication, // Mở trực tiếp trong ứng dụng Google Maps
        );
      } else {
        // Xử lý khi không thể mở Maps
        print('Không thể mở bản đồ. Vui lòng kiểm tra ứng dụng Google Maps');
      }
    } catch (e) {
      // Xử lý lỗi
      print('Lỗi khi mở bản đồ: $e');

    }
  }

}