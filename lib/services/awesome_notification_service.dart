import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

class AwesomeNotificationService {
  static const String welcomeChannelKey = 'welcome_channel';
  static const String reminderChannelKey = 'reminder_channel';
  static const String certificateChannelKey = 'certificate_channel';
  static const String updateChannelKey = 'update_channel';
  static const String promoChannelKey = 'promo_channel';

  static Future<void> initialize() async {
    await AwesomeNotifications().initialize(
      null, // default icon
      [
        NotificationChannel(
          channelKey: welcomeChannelKey,
          channelName: 'Welcome Notifications',
          channelDescription: 'Notifications for welcoming new users',
          defaultColor: const Color(0xFF324EAF),
          ledColor: const Color(0xFF324EAF),
          importance: NotificationImportance.High,
          channelShowBadge: true,
          playSound: true,
          enableVibration: true,
        ),
        NotificationChannel(
          channelKey: reminderChannelKey,
          channelName: 'Course Reminders',
          channelDescription: 'Reminders for unfinished courses',
          defaultColor: const Color(0xFFFFA500),
          ledColor: const Color(0xFFFFA500),
          importance: NotificationImportance.High,
          channelShowBadge: true,
          playSound: true,
          enableVibration: true,
        ),
        NotificationChannel(
          channelKey: certificateChannelKey,
          channelName: 'Certificates',
          channelDescription: 'Notifications for earned certificates',
          defaultColor: const Color(0xFF32CD32),
          ledColor: const Color(0xFF32CD32),
          importance: NotificationImportance.High,
          channelShowBadge: true,
          playSound: true,
          enableVibration: true,
        ),
        NotificationChannel(
          channelKey: updateChannelKey,
          channelName: 'Updates',
          channelDescription: 'Notifications for new courses and updates',
          defaultColor: const Color(0xFF1E90FF),
          ledColor: const Color(0xFF1E90FF),
          importance: NotificationImportance.Default,
          channelShowBadge: true,
          playSound: true,
          enableVibration: true,
        ),
        NotificationChannel(
          channelKey: promoChannelKey,
          channelName: 'Promotions',
          channelDescription: 'Promotional offers and deals',
          defaultColor: const Color(0xFFFF1493),
          ledColor: const Color(0xFFFF1493),
          importance: NotificationImportance.Default,
          channelShowBadge: true,
          playSound: true,
          enableVibration: true,
        ),
      ],
    );

    // Request permission
    await AwesomeNotifications().requestPermissionToSendNotifications();
  }

  // 1. Welcome notification on first login
  static Future<void> showWelcomeNotification(String userName) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
        channelKey: welcomeChannelKey,
        title: 'Welcome to Our App, $userName! 🎉',
        body:
            'Thank you for joining us. Explore amazing courses and start learning today!',
        notificationLayout: NotificationLayout.BigText,
      ),
    );
  }

  // 2. Course reminder for unfinished courses
  static Future<void> showCourseReminder(
    String courseTitle,
    int progressPercent,
  ) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
        channelKey: reminderChannelKey,
        title: 'Continue Your Course! 📚',
        body: 'You\'re $progressPercent% through "$courseTitle". Keep going!',
        notificationLayout: NotificationLayout.Default,
      ),
      actionButtons: [
        NotificationActionButton(
          key: 'CONTINUE_COURSE',
          label: 'Continue',
          actionType: ActionType.Default,
        ),
      ],
    );
  }

  // 3. Certificate earned on completion
  static Future<void> showCertificateNotification(String courseTitle) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
        channelKey: certificateChannelKey,
        title: 'Congratulations! 🎓',
        body: 'You\'ve completed "$courseTitle" and earned your certificate!',
        notificationLayout: NotificationLayout.BigText,
      ),
      actionButtons: [
        NotificationActionButton(
          key: 'VIEW_CERTIFICATE',
          label: 'View Certificate',
          actionType: ActionType.Default,
        ),
      ],
    );
  }

  // 4. New course/update notifications
  static Future<void> showUpdateNotification(
    String updateTitle,
    String description,
  ) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
        channelKey: updateChannelKey,
        title: 'New Update: $updateTitle 🔄',
        body: description,
        notificationLayout: NotificationLayout.BigText,
      ),
      actionButtons: [
        NotificationActionButton(
          key: 'EXPLORE_UPDATE',
          label: 'Explore',
          actionType: ActionType.Default,
        ),
      ],
    );
  }

  // 5. Promotional offers
  static Future<void> showPromoNotification(
    String offerTitle,
    String details,
  ) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
        channelKey: promoChannelKey,
        title: 'Special Offer: $offerTitle 💰',
        body: details,
        notificationLayout: NotificationLayout.BigText,
      ),
      actionButtons: [
        NotificationActionButton(
          key: 'CLAIM_OFFER',
          label: 'Claim Now',
          actionType: ActionType.Default,
        ),
      ],
    );
  }

  // Schedule a reminder notification
  static Future<void> scheduleCourseReminder(
    String courseTitle,
    int progressPercent,
    DateTime scheduleTime,
  ) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
        channelKey: reminderChannelKey,
        title: 'Course Reminder 📚',
        body:
            'Don\'t forget to continue "$courseTitle". You\'re $progressPercent% done!',
        notificationLayout: NotificationLayout.Default,
      ),
      schedule: NotificationCalendar.fromDate(date: scheduleTime),
    );
  }
}
