import 'package:projek_mobile/data/db_helper.dart';
import 'package:projek_mobile/models/explore_model.dart';
import 'package:projek_mobile/database/database_service.dart';

class ExploreRepository {
  final _db = DbHelper.instance;

  Future<void> seedIfEmpty(List<Course> courses) async {
    final n = await _db.count();
    if (n == 0) {
      await _db.insertAll(courses);
    }
  }

  Future<List<Course>> getTrendingTop5() => _db.getTrendingTop5();

  Future<List<Course>> getRecommendedForYou(String category) =>
      _db.getRecommendedForYou(category);

  // >>> Tambahan: expose semua data
  Future<List<Course>> getAll() => _db.getAll();

  /// Reactive stream of all courses (emits when DatabaseService emits courses)
  Stream<List<Course>> watchAllCourses() {
    return DatabaseService.instance.coursesStream.map((rows) {
      return rows.map((r) => Course.fromMap(r)).toList();
    });
  }
}
