class NotificationModel {
  final String id;
  final String userId;
  final String type;
  final String message;
  final Map<String, dynamic> meta;
  final DateTime createdAt;
  final DateTime? readAt;

  NotificationModel({
    required this.id,
    required this.userId,
    required this.type,
    required this.message,
    required this.meta,
    required this.createdAt,
    this.readAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      userId: json['userId'],
      type: json['type'],
      message: json['message'],
      meta: json['meta'] ?? {},
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt']),
      readAt:
          json['readAt'] != null
              ? DateTime.fromMillisecondsSinceEpoch(json['readAt'])
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'type': type,
      'message': message,
      'meta': meta,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'readAt': readAt?.millisecondsSinceEpoch,
    };
  }

  bool get isRead => readAt != null;
}
