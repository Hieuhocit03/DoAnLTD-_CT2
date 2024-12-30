class Appointment {
  final int? appointmentId;
  final int sellerId;
  final int buyerId;
  final int carId;
  final DateTime date;
  final DateTime time;
  final String location;
  final String status;
  final DateTime createdAt;

  Appointment({
    this.appointmentId,
    required this.sellerId,
    required this.buyerId,
    required this.carId,
    required this.date,
    required this.time,
    required this.location,
    required this.status,
    required this.createdAt,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      appointmentId: json['appointment_id'],
      sellerId: json['seller_id'],
      buyerId: json['buyer_id'],
      carId: json['car_id'],
      date: DateTime.parse(json['date']),
      time: DateTime.parse(json['time']),
      location: json['location'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'appointment_id': appointmentId,
      'seller_id': sellerId,
      'buyer_id': buyerId,
      'car_id': carId,
      'date': date.toIso8601String(),
      'time': time.toIso8601String(),
      'location': location,
      'status': status,
      'created_at': createdAt.toIso8601String(),
    };
  }
}