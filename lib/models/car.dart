class Car {
  int? carId;
  String name;
  int brandId;
  int year;
  double price;
  String status;
  String? description;
  String? imageUrl;
  int sellerId;
  String location;
  DateTime createdAt;
  DateTime updatedAt;

  Car({
    this.carId,
    required this.name,
    required this.brandId,
    required this.year,
    required this.price,
    required this.status,
    this.description,
    this.imageUrl,
    required this.sellerId,
    required this.location,
    required this.createdAt,
    required this.updatedAt,
  });

  // Chuyển đổi đối tượng thành JSON (Map<String, dynamic>)
  Map<String, dynamic> toJson() {
    return {
      'car_id': carId,
      'name': name,
      'brand_id': brandId,
      'year': year,
      'price': price,
      'status': status,
      'description': description,
      'image_url': imageUrl,
      'seller_id': sellerId,
      'location': location,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  // Khởi tạo đối tượng từ JSON (Map<String, dynamic>)
  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
      carId: json['car_id'],
      name: json['name'],
      brandId: json['brand_id'],
      year: json['year'],
      price: (json['price'] as num).toDouble(),
      status: json['status'],
      description: json['description'],
      imageUrl: json['image_url'],
      sellerId: json['seller_id'],
      location: json['location'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
