class Feedback {
  final int? feedbackId;
  final int userId;
  final String message;
  final DateTime createdAt;

  Feedback({
    this.feedbackId,
    required this.userId,
    required this.message,
    required this.createdAt,
  });

  factory Feedback.fromJson(Map<String, dynamic> json) {
    return Feedback(
      feedbackId: json['feedback_id'],
      userId: json['user_id'],
      message: json['message'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'feedback_id': feedbackId,
      'user_id': userId,
      'message': message,
      'created_at': createdAt.toIso8601String(),
    };
  }
}