class CarCondition {
  int? conditionId;
  int carId;
  int? kmDriven;
  int? ownersCount;
  String? licenseType;
  String? accessories;
  DateTime? registrationExpiry;
  String? origin;
  String? status;
  String? warrantyPolicy;

  CarCondition({
    this.conditionId,
    required this.carId,
    this.kmDriven,
    this.ownersCount,
    this.licenseType,
    this.accessories,
    this.registrationExpiry,
    this.origin,
    this.status,
    this.warrantyPolicy,
  });

  // Chuyển đối tượng thành JSON (Map<String, dynamic>)
  Map<String, dynamic> toJson() {
    return {
      'condition_id': conditionId,
      'car_id': carId,
      'km_driven': kmDriven,
      'owners_count': ownersCount,
      'license_type': licenseType,
      'accessories': accessories,
      'registration_expiry': registrationExpiry?.toIso8601String(),
      'origin': origin,
      'status': status,
      'warranty_policy': warrantyPolicy,
    };
  }

  // Khởi tạo đối tượng từ JSON (Map<String, dynamic>)
  factory CarCondition.fromJson(Map<String, dynamic> json) {
    return CarCondition(
      conditionId: json['condition_id'],
      carId: json['car_id'],
      kmDriven: json['km_driven'],
      ownersCount: json['owners_count'],
      licenseType: json['license_type'],
      accessories: json['accessories'],
      registrationExpiry: json['registration_expiry'] != null
          ? DateTime.parse(json['registration_expiry'])
          : null,
      origin: json['origin'],
      status: json['status'],
      warrantyPolicy: json['warranty_policy'],
    );
  }
}
