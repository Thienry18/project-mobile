import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:projek_mobile/data/cart_data.dart';
import 'package:projek_mobile/data/my_course_data.dart';
import 'package:projek_mobile/models/explore_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckoutHandler {
  static Future<void> handleCheckout(
    BuildContext context,
    List<Course> selectedItems,
    double promoDiscount,
  ) async {
    for (final course in selectedItems) {
      myCourses.add(course);
    }

    cartCourses.removeWhere((item) => selectedItems.contains(item));

    final prefs = await SharedPreferences.getInstance();

    // Save to History
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

    // Save Notification
    final notifData = prefs.getString('notifications');
    List<Map<String, dynamic>> currentNotifs =
        notifData != null
            ? List<Map<String, dynamic>>.from(jsonDecode(notifData))
            : [];

    final newNotif = {
      'title': 'Order Completed!',
      'message':
          'Thanks for your purchase! Your course is now available in My Course. Take your time, start whenever you’re ready, and enjoy every step of your learning journey.',
      'image': selectedItems.first.images,
      'date': _getCurrentFormattedDateTime(),
      'unread': true,
      'isNetworkImage': true,
    };

    currentNotifs.insert(0, newNotif);
    await prefs.setString('notifications', jsonEncode(currentNotifs));
  }

  static String _getCurrentFormattedDateTime() {
    final now = DateTime.now();
    final hour = now.hour > 12 ? now.hour - 12 : now.hour;
    final amPm = now.hour >= 12 ? 'P.M.' : 'A.M.';
    return '${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}-${now.year} '
        '$hour:${now.minute.toString().padLeft(2, '0')} $amPm';
  }
}
