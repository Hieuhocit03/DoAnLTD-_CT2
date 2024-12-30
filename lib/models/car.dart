class Car {
  final int? carId;
  final String name;
  final String brand;
  final int year;
  final double price;
  final String status;
  final String? description;
  final String? imageUrl;
  final int sellerId;

  Car({
    this.carId,
    required this.name,
    required this.brand,
    required this.year,
    required this.price,
    required this.status,
    this.description,
    this.imageUrl,
    required this.sellerId,
  });

  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
      carId: json['car_id'],
      name: json['name'],
      brand: json['brand'],
      year: json['year'],
      price: json['price'],
      status: json['status'],
      description: json['description'],
      imageUrl: json['image_url'],
      sellerId: json['seller_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'car_id': carId,
      'name': name,
      'brand': brand,
      'year': year,
      'price': price,
      'status': status,
      'description': description,
      'image_url': imageUrl,
      'seller_id': sellerId,
    };
  }
}