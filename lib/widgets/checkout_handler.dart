import 'package:flutter/material.dart';
import 'package:projek_mobile/data/cart_data.dart';
import 'package:projek_mobile/models/explore_model.dart';
import 'package:projek_mobile/database/database_service.dart';
import 'package:projek_mobile/database/database_mycourse.dart';
import 'package:projek_mobile/database/database_user.dart';
import 'package:projek_mobile/database/database_notification.dart';
import 'package:projek_mobile/utils/notification_helper.dart';
import 'package:projek_mobile/database/database_history.dart';
import 'package:projek_mobile/database/database_cart.dart';
import 'package:provider/provider.dart';
import 'package:projek_mobile/providers/history_provider.dart';

class CheckoutHandler {
  static Future<void> handleCheckout(
    BuildContext context,
    List<Course> selectedItems,
    double promoDiscount,
  ) async {
    cartCourses.removeWhere((item) => selectedItems.contains(item));
    // Persist purchase info into DB tables. We intentionally no longer use
    // SharedPreferences for purchase history or notifications.

    // Also insert a notification row into app_database.notifications for the demo user
    try {
      final userId = await DatabaseUser.getOrCreateDemoUserIdForApp();
      final db = await DatabaseService.instance.database;
      await DatabaseNotification.insertNotification(db, {
        'user_id': userId,
        'course_id':
            selectedItems.isNotEmpty ? selectedItems.first.index : null,
        'title': 'Order Completed!',
        'message':
            'Thanks for your purchase! Your course is now available in My Course.',
        'course_title':
            selectedItems.isNotEmpty ? selectedItems.first.title : null,
        'course_image':
            selectedItems.isNotEmpty ? selectedItems.first.images : null,
        'course_price':
            selectedItems.isNotEmpty ? selectedItems.first.price : null,
        'is_read': 0,
        'created_at': DateTime.now().millisecondsSinceEpoch,
      });
      try {
        // also show a local notification for demo
        await NotificationHelper.showNotification(
          id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
          title: 'Purchase complete',
          body: 'Your purchase was successful',
        );
      } catch (_) {}
    } catch (e) {
      // ignore: avoid_print
      print('Could not insert notification into DB: $e');
    }

    // No in-prefs my_courses; DB 'mycourse' table is the source of truth.
    // Also insert purchased courses into app_database.mycourse for the current/demo user
    try {
      final userId = await DatabaseUser.getOrCreateDemoUserIdForApp();
      final db = await DatabaseService.instance.database;
      for (final course in selectedItems) {
        await DatabaseMyCourse.addMyCourse(db, {
          'user_id': userId,
          'course_id': course.index,
          'title': course.title,
          'instructor': course.instructor,
          'image': course.images,
          'price': course.price,
          'purchased_at': DateTime.now().millisecondsSinceEpoch,
          'progress': 0.0,
        });
        // Also write an entry to the history table indicating a successful purchase
        try {
          await DatabaseHistory.addHistory(db, {
            'user_id': userId,
            'course_id': course.index,
            'title': course.title,
            'image': course.images,
            'price': course.price,
            'status': 'completed',
            'source': 'purchase',
            'occurred_at': DateTime.now().millisecondsSinceEpoch,
          });
          // notify listeners so HistoryScreen updates if open
          try {
            Provider.of<HistoryNotifier>(
              context,
              listen: false,
            ).notifyUpdated();
          } catch (_) {
            // ignore if provider not available in this context
          }
        } catch (e) {
          // ignore: avoid_print
          print('Could not insert history row for purchase: $e');
        }
        // Remove purchased course from cart (if present) for this user
        try {
          await DatabaseCart.removeByUserCourseForUser(userId, course.index);
        } catch (e) {
          // ignore: avoid_print
          print('Could not remove purchased course from cart: $e');
        }
      }
    } catch (e) {
      // ignore: avoid_print
      print('Could not insert into mycourse table: $e');
    }
  }

  // no-op: notifications and mycourse persisted in DB; legacy prefs removed
}
