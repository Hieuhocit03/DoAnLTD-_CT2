class User {
  final int? userId;
  final String role;
  final String name;
  final String email;
  final String password;
  final String? phone;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    this.userId,
    required this.role,
    required this.name,
    required this.email,
    required this.password,
    this.phone,
    this.status = 'active',
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['user_id'],
      role: json['role'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
      phone: json['phone'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'role': role,
      'name': name,
      'email': email,
      'password': password,
      'phone': phone,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}