import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/course_model.dart';
import '../models/cart_model.dart';
import '../models/notification_model.dart';

class ApiService {
  final String baseUrl;
  ApiService({required this.baseUrl});

  Future<Map<String, dynamic>> post(
    String path,
    Map<String, dynamic> body, {
    String? token,
  }) async {
    final res = await http.post(
      Uri.parse('$baseUrl$path'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );
    return _handle(res);
  }

  Future<Map<String, dynamic>> get(String path, {String? token}) async {
    final res = await http.get(
      Uri.parse('$baseUrl$path'),
      headers: {if (token != null) 'Authorization': 'Bearer $token'},
    );
    return _handle(res);
  }

  Map<String, dynamic> _handle(http.Response res) {
    final body = res.body.isEmpty ? '{}' : jsonDecode(res.body);
    if (res.statusCode >= 200 && res.statusCode < 300)
      return {'status': res.statusCode, 'body': body};
    throw Exception(
      'API ${res.statusCode}: ${body is Map && body['error'] != null ? body['error'] : res.body}',
    );
  }

  // Courses
  Future<List<CourseModel>> getCourses({
    String? category,
    String? search,
  }) async {
    final queryParams = <String, String>{};
    if (category != null) queryParams['category'] = category;
    if (search != null) queryParams['search'] = search;

    final response = await get('/courses', token: null);
    final List<dynamic> data = response['body'];
    return data.map((json) => CourseModel.fromJson(json)).toList();
  }

  Future<CourseModel> getCourse(int id) async {
    final response = await get('/courses/$id', token: null);
    return CourseModel.fromJson(response['body']);
  }

  // Cart
  Future<List<CartItemModel>> getCart(String token) async {
    final response = await get('/cart', token: token);
    final List<dynamic> data = response['body'];
    return data.map((json) => CartItemModel.fromJson(json)).toList();
  }

  Future<CartItemModel> addToCart(int courseId, String token) async {
    final response = await post('/cart', {'courseId': courseId}, token: token);
    return CartItemModel.fromJson(response['body']);
  }

  Future<void> removeFromCart(int courseId, String token) async {
    await http.delete(
      Uri.parse('$baseUrl/cart/$courseId'),
      headers: {'Authorization': 'Bearer $token'},
    );
  }

  // MyCourses
  Future<List<PurchasedCourseModel>> getMyCourses(String token) async {
    final response = await get('/mycourses', token: token);
    final List<dynamic> data = response['body'];
    return data.map((json) => PurchasedCourseModel.fromJson(json)).toList();
  }

  // Checkout
  Future<List<PurchasedCourseModel>> checkout(String token) async {
    final response = await post('/checkout', {}, token: token);
    final List<dynamic> data = response['body'];
    return data.map((json) => PurchasedCourseModel.fromJson(json)).toList();
  }

  // Notifications
  Future<List<NotificationModel>> getNotifications(String token) async {
    final response = await get('/notifications', token: token);
    final List<dynamic> data = response['body'];
    return data.map((json) => NotificationModel.fromJson(json)).toList();
  }

  Future<NotificationModel> markNotificationRead(
    String notificationId,
    String token,
  ) async {
    final response = await post('/notifications/read', {
      'notificationId': notificationId,
    }, token: token);
    return NotificationModel.fromJson(response['body']);
  }
}
