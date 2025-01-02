class CarSpecification {
  int? specificationId;
  int carId;
  String? version;
  String? transmission;
  String? fuelType;
  String? bodyStyle;
  int? seats;
  String? drivetrain;
  String? engineType;
  String? horsepower;
  String? torque;
  String? engineCapacity;
  String? fuelConsumption;
  int? airbags;
  String? groundClearance;
  int? doors;
  String? weight;
  String? payloadCapacity;
  int? carModelId;

  CarSpecification({
    this.specificationId,
    required this.carId,
    this.version,
    this.transmission,
    this.fuelType,
    this.bodyStyle,
    this.seats,
    this.drivetrain,
    this.engineType,
    this.horsepower,
    this.torque,
    this.engineCapacity,
    this.fuelConsumption,
    this.airbags,
    this.groundClearance,
    this.doors,
    this.weight,
    this.payloadCapacity,
    this.carModelId,
  });

  // Chuyển đối tượng thành JSON (Map<String, dynamic>)
  Map<String, dynamic> toJson() {
    return {
      'specification_id': specificationId,
      'car_id': carId,
      'version': version,
      'transmission': transmission,
      'fuel_type': fuelType,
      'body_style': bodyStyle,
      'seats': seats,
      'drivetrain': drivetrain,
      'engine_type': engineType,
      'horsepower': horsepower,
      'torque': torque,
      'engine_capacity': engineCapacity,
      'fuel_consumption': fuelConsumption,
      'airbags': airbags,
      'ground_clearance': groundClearance,
      'doors': doors,
      'weight': weight,
      'payload_capacity': payloadCapacity,
      'car_model_id': carModelId,
    };
  }

  // Khởi tạo đối tượng từ JSON (Map<String, dynamic>)
  factory CarSpecification.fromJson(Map<String, dynamic> json) {
    return CarSpecification(
      specificationId: json['specification_id'],
      carId: json['car_id'],
      version: json['version'],
      transmission: json['transmission'],
      fuelType: json['fuel_type'],
      bodyStyle: json['body_style'],
      seats: json['seats'],
      drivetrain: json['drivetrain'],
      engineType: json['engine_type'],
      horsepower: json['horsepower'],
      torque: json['torque'],
      engineCapacity: json['engine_capacity'],
      fuelConsumption: json['fuel_consumption'],
      airbags: json['airbags'],
      groundClearance: json['ground_clearance'],
      doors: json['doors'],
      weight: json['weight'],
      payloadCapacity: json['payload_capacity'],
      carModelId: json['car_model_id'],
    );
  }
}
