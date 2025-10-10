import 'package:projek_mobile/models/explore_model.dart';
import 'package:projek_mobile/database/database_service.dart';
import 'package:projek_mobile/database/database_cart.dart';

List<Course> cartCourses = [];

// High-level wrappers that operate on app_database.db and keep `cartCourses` in-memory list in sync.
Future<int> addToUserCartLocal({
  required int userId,
  required Course course,
}) async {
  final db = await DatabaseService.instance.database;
  final data = {
    'user_id': userId,
    'course_id': course.index,
    'title': course.title,
    'price': course.price,
    'instructor': course.instructor,
    'image': course.images,
    'added_at': DateTime.now().millisecondsSinceEpoch,
  };
  final id = await DatabaseCart.addToCart(db, data);
  // Update in-memory list (best-effort)
  cartCourses.add(course);
  return id;
}

Future<int> upsertCartItemLocal({
  required int userId,
  required Course course,
}) async {
  final db = await DatabaseService.instance.database;
  final data = {
    'user_id': userId,
    'course_id': course.index,
    'title': course.title,
    'price': course.price,
    'instructor': course.instructor,
    'image': course.images,
    'added_at': DateTime.now().millisecondsSinceEpoch,
  };
  final id = await DatabaseCart.upsertCartItem(db, data);
  if (!cartCourses.any((c) => c.index == course.index)) cartCourses.add(course);
  return id;
}

Future<List<Map<String, dynamic>>> getUserCartLocal(int userId) async {
  final db = await DatabaseService.instance.database;
  return DatabaseCart.getUserCart(db, userId);
}

Future<int> removeFromCartLocal(int id) async {
  final db = await DatabaseService.instance.database;
  return DatabaseCart.removeFromCart(db, id);
}

Future<void> clearUserCartLocal(int userId) async {
  final db = await DatabaseService.instance.database;
  await DatabaseCart.clearUserCart(db, userId);
  cartCourses.clear();
}

Future<int> countUserCartLocal(int userId) async {
  final db = await DatabaseService.instance.database;
  return DatabaseCart.countUserCart(db, userId);
}

Future<double> getUserCartTotalLocal(int userId) async {
  final db = await DatabaseService.instance.database;
  return DatabaseCart.getUserCartTotal(db, userId);
}

Future<bool> existsInCartLocal(int userId, int courseId) async {
  final db = await DatabaseService.instance.database;
  return DatabaseCart.existsInCart(db, userId, courseId);
}
