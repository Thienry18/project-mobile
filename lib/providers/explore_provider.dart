import 'package:flutter/foundation.dart';
import 'package:projek_mobile/data/explore_repository.dart';
import 'package:projek_mobile/models/explore_model.dart';

class ExploreProvider extends ChangeNotifier {
  final ExploreRepository repository;

  ExploreProvider(this.repository);

  List<Course> trending = [];
  List<Course> recommended = [];
  List<Course> all = [];
  bool isLoading = false;

  Future<void> loadData() async {
    await loadByCategory('Python');
  }

  Future<void> loadByCategory(String category) async {
    isLoading = true;
    notifyListeners();

    all = await repository.getAll();

    trending = await repository.getTrendingTop5();
    recommended = await repository.getRecommendedForYou(category);

    isLoading = false;
    notifyListeners();
  }

  List<Course> get allUnique {
    if (all.isNotEmpty) return all;
    final map = <int, Course>{};
    for (final c in trending) map[c.index] = c;
    for (final c in recommended) map[c.index] = c;
    return map.values.toList();
  }
}
