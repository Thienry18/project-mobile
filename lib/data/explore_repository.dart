import 'package:projek_mobile/data/db_helper.dart';
import 'package:projek_mobile/models/explore_model.dart';

class ExploreRepository {
  final _db = DbHelper.instance;

  Future<void> seedIfEmpty(List<Course> courses) async {
    final count = await _db.count();
    if (count == 0) {
      await _db.insertAll(courses);
    }
  }

  Future<List<Course>> getTrendingTop5() => _db.getTrendingTop5();

  Future<List<Course>> getRecommendedForYou(String category) =>
      _db.getRecommendedForYou(category);
}
