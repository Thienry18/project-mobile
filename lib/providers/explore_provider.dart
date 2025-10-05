import 'package:flutter/foundation.dart';
import 'package:projek_mobile/data/explore_repository.dart';
import 'package:projek_mobile/models/explore_model.dart';

class ExploreProvider extends ChangeNotifier {
  final ExploreRepository repository;

  ExploreProvider(this.repository);

  List<Course> trending = [];
  List<Course> recommended = [];
  bool isLoading = false;

  Future<void> loadData() async {
    isLoading = true;
    notifyListeners();
    trending = await repository.getTrendingTop5();
    recommended = await repository.getRecommendedForYou('Python');
    isLoading = false;
    notifyListeners();
  }
}
