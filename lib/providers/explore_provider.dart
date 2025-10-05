import 'package:flutter/foundation.dart';
import 'package:projek_mobile/data/explore_repository.dart';
import 'package:projek_mobile/models/explore_model.dart';

class ExploreProvider extends ChangeNotifier {
  final ExploreRepository repository;

  ExploreProvider(this.repository);

  List<Course> trending = []; // top 5
  List<Course> recommended = []; // top 5 sesuai kategori
  List<Course> all = []; // SEMUA course dari DB
  bool isLoading = false;

  /// Default load saat app start (boleh pilih kategori default)
  Future<void> loadData() async {
    await loadByCategory('Python');
  }

  /// Load data sesuai kategori + ambil seluruh data untuk list/filter/search
  Future<void> loadByCategory(String category) async {
    isLoading = true;
    notifyListeners();

    // ambil semua dulu untuk kebutuhan list/filter/search
    all = await repository.getAll();

    // bagian berukuran kecil untuk section di homepage
    trending = await repository.getTrendingTop5();
    recommended = await repository.getRecommendedForYou(category);

    isLoading = false;
    notifyListeners();
  }

  /// gabungkan unik kalau suatu saat kamu butuh
  List<Course> get allUnique {
    if (all.isNotEmpty) return all;
    final map = <int, Course>{};
    for (final c in trending) map[c.index] = c;
    for (final c in recommended) map[c.index] = c;
    return map.values.toList();
  }
}
