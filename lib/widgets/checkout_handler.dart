import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:projek_mobile/data/cart_data.dart';
import 'package:projek_mobile/models/explore_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckoutHandler {
  static Future<void> handleCheckout(
    BuildContext context,
    List<Course> selectedItems,
    double promoDiscount,
  ) async {
    cartCourses.removeWhere((item) => selectedItems.contains(item));

    final prefs = await SharedPreferences.getInstance();

    final data = prefs.getString('purchase_history');
    List<Map<String, dynamic>> history =
        data != null ? List<Map<String, dynamic>>.from(jsonDecode(data)) : [];

    for (final course in selectedItems) {
      history.add({
        'image': course.images,
        'title': course.title,
        'rating': course.rating,
        'price':
            double.tryParse(course.price.replaceAll(RegExp(r'[^\d.]'), '')) ??
            0.0,
        'isBestseller': course.isBestseller,
        'duration': course.duration,
        'category': course.category,
        'status': 'completed',
      });
    }
    await prefs.setString('purchase_history', jsonEncode(history));

    final notifData = prefs.getString('notifications');
    List<Map<String, dynamic>> currentNotifs =
        notifData != null
            ? List<Map<String, dynamic>>.from(jsonDecode(notifData))
            : [];

    final newNotif = {
      'title': 'Order Completed!',
      'message':
          'Thanks for your purchase! Your course is now available in My Course.',
      'image': selectedItems.first.images,
      'date': _getCurrentFormattedDateTime(),
      'unread': true,
      'isNetworkImage': true,
    };
    currentNotifs.insert(0, newNotif);
    await prefs.setString('notifications', jsonEncode(currentNotifs));

    final existingCourseData = prefs.getString('my_courses');
    List<Map<String, dynamic>> currentCourses =
        existingCourseData != null
            ? List<Map<String, dynamic>>.from(jsonDecode(existingCourseData))
            : [];

    for (final course in selectedItems) {
      if (!currentCourses.any((c) => c['title'] == course.title)) {
        currentCourses.add({
          'index': course.index,
          'title': course.title,
          'price': course.price,
          'images': course.images,
          'category': course.category,
          'rating': course.rating,
          'duration': course.duration,
          'isBestseller': course.isBestseller,
          'instructor': course.instructor,
          'language': course.language,
          'subtitle': course.subtitle,
        });
      }
    }

    await prefs.setString('my_courses', jsonEncode(currentCourses));
  }

  static String _getCurrentFormattedDateTime() {
    final now = DateTime.now();
    final hour = now.hour > 12 ? now.hour - 12 : now.hour;
    final amPm = now.hour >= 12 ? 'P.M.' : 'A.M.';
    return '${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}-${now.year} '
        '$hour:${now.minute.toString().padLeft(2, '0')} $amPm';
  }
}
