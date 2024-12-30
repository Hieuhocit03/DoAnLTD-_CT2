class Transaction {
  final int? transactionId;
  final int carId;
  final int buyerId;
  final String status;
  final DateTime createdAt;

  Transaction({
    this.transactionId,
    required this.carId,
    required this.buyerId,
    required this.status,
    required this.createdAt,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      transactionId: json['transaction_id'],
      carId: json['car_id'],
      buyerId: json['buyer_id'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'transaction_id': transactionId,
      'car_id': carId,
      'buyer_id': buyerId,
      'status': status,
      'created_at': createdAt.toIso8601String(),
    };
  }
}