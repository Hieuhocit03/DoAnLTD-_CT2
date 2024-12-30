class Brand {
  final int? brandId;
  final String name;

  Brand({
    this.brandId,
    required this.name,
  });

  factory Brand.fromJson(Map<String, dynamic> json) {
    return Brand(
      brandId: json['brand_id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'brand_id': brandId,
      'name': name,
    };
  }
}
