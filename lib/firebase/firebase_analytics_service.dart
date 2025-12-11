import 'package:firebase_analytics/firebase_analytics.dart';

class FirebaseAnalyticsService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  // Singleton pattern
  static final FirebaseAnalyticsService _instance =
      FirebaseAnalyticsService._internal();
  factory FirebaseAnalyticsService() => _instance;
  FirebaseAnalyticsService._internal() {
    _ensureEnabled();
  }

  // Ensure analytics collection is enabled. Non-blocking call.
  // We don't await here because constructors can't be async; this simply
  // triggers the underlying platform implementation to enable collection.
  // If the app needs to toggle collection later, call
  // FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(false/true).
  void _ensureEnabled() {
    try {
      FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
    } catch (_) {}
  }

  // --- Compatibility wrappers (older helper names used across the app) ---
  Future<void> trackButtonClick(
    String buttonName, {
    Map<String, dynamic>? extras,
  }) async {
    try {
      final Map<String, Object> params = _normalizeParams({
        'button_name': buttonName,
        'timestamp': DateTime.now().toIso8601String(),
        ...?extras,
      });
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
      final Map<String, Object> params = _normalizeParams({
        'action': action,
        'timestamp': DateTime.now().toIso8601String(),
        if (courseId != null) 'course_id': courseId,
        if (price != null) 'price': price,
      });
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
      final Map<String, Object> params = _normalizeParams({
        'action': action,
        'course_id': courseId,
        'timestamp': DateTime.now().toIso8601String(),
        if (price != null) 'price': price,
      });
      await _analytics.logEvent(name: 'course_action', parameters: params);
    } catch (e) {
      print('Analytics Error (trackCourseAction): $e');
    }
  }

  // Normalize parameters: Firebase Analytics requires parameter values to be String or num.
  // Convert bool -> 1/0, keep num and String, otherwise call toString().
  Map<String, Object> _normalizeParams(Map<String, dynamic>? raw) {
    final out = <String, Object>{};
    if (raw == null) return out;
    raw.forEach((k, v) {
      if (v == null) return;
      if (v is String) {
        out[k] = v;
      } else if (v is num) {
        out[k] = v;
      } else if (v is bool) {
        out[k] = v ? 1 : 0;
      } else {
        out[k] = v.toString();
      }
    });
    return out;
  }

  // Auth Related Analytics
  Future<void> logLogin({
    required String method,
    required bool success,
    String? errorMessage,
  }) async {
    try {
      final params = _normalizeParams({
        'login_method': method,
        'success': success,
        'timestamp': DateTime.now().toIso8601String(),
        if (errorMessage != null) 'error_message': errorMessage,
      });
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
      final params = _normalizeParams({
        'signup_method': method,
        'success': success,
        'timestamp': DateTime.now().toIso8601String(),
        if (errorMessage != null) 'error_message': errorMessage,
      });
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
        parameters: _normalizeParams({
          'course_id': courseId,
          'title': title,
          'instructor': instructor,
          'price': price,
          'timestamp': DateTime.now().toIso8601String(),
        }),
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
      final params = _normalizeParams({
        'course_id': courseId,
        'title': title,
        'price': price,
        'success': success,
        'timestamp': DateTime.now().toIso8601String(),
        if (paymentMethod != null) 'payment_method': paymentMethod,
      });
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
        parameters: _normalizeParams({
          'operation': operation, // add, remove, checkout
          'course_id': courseId,
          'title': title,
          'price': price,
          'timestamp': DateTime.now().toIso8601String(),
        }),
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
      final params = _normalizeParams({
        'course_id': courseId,
        'video_title': videoTitle,
        'action': action, // play, pause, seek, complete
        'position': timePosition,
        'timestamp': DateTime.now().toIso8601String(),
        if (quality != null) 'quality': quality,
      });
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
        parameters: _normalizeParams({
          ...?parameters,
          'timestamp': DateTime.now().toIso8601String(),
        }),
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
      final params = _normalizeParams({
        'search_term': searchTerm,
        'result_count': resultCount,
        'timestamp': DateTime.now().toIso8601String(),
        if (category != null) 'category': category,
      });
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
      final params = _normalizeParams({
        'error_type': errorType,
        'message': message,
        'timestamp': DateTime.now().toIso8601String(),
        if (stackTrace != null) 'stack_trace': stackTrace,
        if (screen != null) 'screen': screen,
      });
      await _analytics.logEvent(name: 'app_error', parameters: params);
    } catch (e) {
      print('Analytics Error: $e');
    }
  }
}
