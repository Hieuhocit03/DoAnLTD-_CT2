class CarModel {
  final int id;
  final int brandId;
  final String name;

  CarModel({
    required this.id,
    required this.brandId,
    required this.name,
  });

  // Factory method để tạo một instance từ JSON
  factory CarModel.fromJson(Map<String, dynamic> json) {
    return CarModel(
      id: json['id'],
      brandId: json['brand_id'],
      name: json['name'],
    );
  }

  // Hàm chuyển đổi instance sang JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'brand_id': brandId,
      'name': name,
    };
  }
}
