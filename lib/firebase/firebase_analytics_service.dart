import 'package:firebase_analytics/firebase_analytics.dart';

class FirebaseAnalyticsService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  // Singleton pattern
  static final FirebaseAnalyticsService _instance =
      FirebaseAnalyticsService._internal();
  factory FirebaseAnalyticsService() => _instance;
  FirebaseAnalyticsService._internal();

  // --- Compatibility wrappers (older helper names used across the app) ---
  Future<void> trackButtonClick(
    String buttonName, {
    Map<String, dynamic>? extras,
  }) async {
    try {
      final Map<String, Object> params = {
        'button_name': buttonName,
        'timestamp': DateTime.now().toIso8601String(),
      };
      if (extras != null) {
        extras.forEach((k, v) {
          if (v != null) params[k] = v as Object;
        });
      }
      await _analytics.logEvent(name: 'button_click', parameters: params);
    } catch (e) {
      // ignore errors from analytics
      print('Analytics Error (trackButtonClick): $e');
    }
  }

  Future<void> trackCartAction(
    String action, {
    String? courseId,
    double? price,
  }) async {
    try {
      final Map<String, Object> params = {
        'action': action,
        'timestamp': DateTime.now().toIso8601String(),
      };
      if (courseId != null) params['course_id'] = courseId;
      if (price != null) params['price'] = price.toString();
      await _analytics.logEvent(name: 'cart_action', parameters: params);
    } catch (e) {
      print('Analytics Error (trackCartAction): $e');
    }
  }

  Future<void> trackCourseAction(
    String action,
    String courseId, {
    double? price,
  }) async {
    try {
      final Map<String, Object> params = {
        'action': action,
        'course_id': courseId,
        'timestamp': DateTime.now().toIso8601String(),
      };
      if (price != null) params['price'] = price.toString();
      await _analytics.logEvent(name: 'course_action', parameters: params);
    } catch (e) {
      print('Analytics Error (trackCourseAction): $e');
    }
  }

  // Auth Related Analytics
  Future<void> logLogin({
    required String method,
    required bool success,
    String? errorMessage,
  }) async {
    try {
      final params = {
        'login_method': method,
        'success': success,
        'timestamp': DateTime.now().toIso8601String(),
      };
      if (errorMessage != null) {
        params['error_message'] = errorMessage;
      }
      await _analytics.logEvent(name: 'user_login', parameters: params);
    } catch (e) {
      print('Analytics Error: $e');
    }
  }

  Future<void> logSignUp({
    required String method,
    required bool success,
    String? errorMessage,
  }) async {
    try {
      final params = {
        'signup_method': method,
        'success': success,
        'timestamp': DateTime.now().toIso8601String(),
      };
      if (errorMessage != null) {
        params['error_message'] = errorMessage;
      }
      await _analytics.logEvent(name: 'user_signup', parameters: params);
    } catch (e) {
      print('Analytics Error: $e');
    }
  }

  // Course Related Analytics
  Future<void> logCourseView({
    required String courseId,
    required String title,
    required String instructor,
    required double price,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'course_view',
        parameters: {
          'course_id': courseId,
          'title': title,
          'instructor': instructor,
          'price': price.toString(),
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
    } catch (e) {
      print('Analytics Error: $e');
    }
  }

  Future<void> logCoursePurchase({
    required String courseId,
    required String title,
    required double price,
    required bool success,
    String? paymentMethod,
  }) async {
    try {
      final params = {
        'course_id': courseId,
        'title': title,
        'price': price.toString(),
        'success': success,
        'timestamp': DateTime.now().toIso8601String(),
      };
      if (paymentMethod != null) {
        params['payment_method'] = paymentMethod;
      }
      await _analytics.logEvent(name: 'course_purchase', parameters: params);
    } catch (e) {
      print('Analytics Error: $e');
    }
  }

  // Cart Related Analytics
  Future<void> logCartOperation({
    required String operation,
    required String courseId,
    required String title,
    required double price,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'cart_operation',
        parameters: {
          'operation': operation, // add, remove, checkout
          'course_id': courseId,
          'title': title,
          'price': price.toString(),
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
    } catch (e) {
      print('Analytics Error: $e');
    }
  }

  // Video Player Analytics
  Future<void> logVideoInteraction({
    required String courseId,
    required String videoTitle,
    required String action,
    required int timePosition,
    String? quality,
  }) async {
    try {
      final params = {
        'course_id': courseId,
        'video_title': videoTitle,
        'action': action, // play, pause, seek, complete
        'position': timePosition.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      };
      if (quality != null) {
        params['quality'] = quality;
      }
      await _analytics.logEvent(name: 'video_interaction', parameters: params);
    } catch (e) {
      print('Analytics Error: $e');
    }
  }

  // Navigation Analytics
  Future<void> logScreenView({
    required String screenName,
    Map<String, dynamic>? parameters,
  }) async {
    try {
      await _analytics.logScreenView(
        screenName: screenName,
        screenClass: screenName,
        parameters: {
          ...?parameters,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
    } catch (e) {
      print('Analytics Error: $e');
    }
  }

  // Search Analytics
  Future<void> logSearch({
    required String searchTerm,
    required int resultCount,
    String? category,
  }) async {
    try {
      final params = {
        'search_term': searchTerm,
        'result_count': resultCount,
        'timestamp': DateTime.now().toIso8601String(),
      };
      if (category != null) {
        params['category'] = category;
      }
      await _analytics.logEvent(name: 'search', parameters: params);
    } catch (e) {
      print('Analytics Error: $e');
    }
  }

  // Error Analytics
  Future<void> logError({
    required String errorType,
    required String message,
    String? stackTrace,
    String? screen,
  }) async {
    try {
      final params = {
        'error_type': errorType,
        'message': message,
        'timestamp': DateTime.now().toIso8601String(),
      };
      if (stackTrace != null) {
        params['stack_trace'] = stackTrace;
      }
      if (screen != null) {
        params['screen'] = screen;
      }
      await _analytics.logEvent(name: 'app_error', parameters: params);
    } catch (e) {
      print('Analytics Error: $e');
    }
  }
}
