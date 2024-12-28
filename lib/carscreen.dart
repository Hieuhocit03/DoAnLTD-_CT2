import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CarDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
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
          image: NetworkImage('https://giaxeoto.vn/admin/upload/images/resize/640-gia-xe-toyota-camry.jpg'),
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
            'Toyota CAMRY',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Xe mới ra nên chạy ít lắm, bà con coi mua lek không hết xe nhé',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
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
          _buildSpecificationRow('Brand', 'Toyota'),
          _buildSpecificationRow('Model', 'Sedan'),
          _buildSpecificationRow('Color', 'Gray'),
          _buildSpecificationRow('Year', '2024'),
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

  Widget _buildBottomActionBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: ElevatedButton(
        onPressed: () => _showSellerInfoDialog(context),
        child: Text('Book Now'),
        style: ElevatedButton.styleFrom(
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
          title: Text('Seller Information'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage('seller_avatar_url'),
              ),
              SizedBox(height: 16),
              Text(
                'John Doe',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              _buildContactRow(
                icon: Icons.phone,
                text: '+1 (123) 456-7890',
                onTap: () => _launchPhone('+11234567890'),
              ),
              SizedBox(height: 8),
              _buildContactRow(
                icon: Icons.email,
                text: 'johndoe@example.com',
                onTap: () => _launchEmail('johndoe@example.com'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Close'),
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



}