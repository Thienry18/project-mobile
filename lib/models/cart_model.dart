import 'course_model.dart';

class CartItemModel {
  final String id;
  final String userId;
  final int courseId;
  final DateTime addedAt;
  final CourseModel? course;

  CartItemModel({
    required this.id,
    required this.userId,
    required this.courseId,
    required this.addedAt,
    this.course,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: json['id'],
      userId: json['userId'],
      courseId: json['courseId'],
      addedAt: DateTime.fromMillisecondsSinceEpoch(json['addedAt']),
      course:
          json['course'] != null ? CourseModel.fromJson(json['course']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'courseId': courseId,
      'addedAt': addedAt.millisecondsSinceEpoch,
      if (course != null) 'course': course!.toJson(),
    };
  }
}

class PurchasedCourseModel {
  final String id;
  final String userId;
  final int courseId;
  final DateTime purchasedAt;
  final CourseModel? course;

  PurchasedCourseModel({
    required this.id,
    required this.userId,
    required this.courseId,
    required this.purchasedAt,
    this.course,
  });

  factory PurchasedCourseModel.fromJson(Map<String, dynamic> json) {
    return PurchasedCourseModel(
      id: json['id'],
      userId: json['userId'],
      courseId: json['courseId'],
      purchasedAt: DateTime.fromMillisecondsSinceEpoch(json['purchasedAt']),
      course:
          json['course'] != null ? CourseModel.fromJson(json['course']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'courseId': courseId,
      'purchasedAt': purchasedAt.millisecondsSinceEpoch,
      if (course != null) 'course': course!.toJson(),
    };
  }
}
