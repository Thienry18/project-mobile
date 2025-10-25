import 'package:flutter/foundation.dart';
import 'package:projek_mobile/data/explore_repository.dart';
import 'package:projek_mobile/models/explore_model.dart';
import 'package:projek_mobile/services/course_service.dart';

class ExploreProvider extends ChangeNotifier {
  final ExploreRepository repository;
  final CourseService courseService = CourseService();

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

    try {
      // Load data in parallel
      final results = await Future.wait([
        courseService.getAllCourses(),
        courseService.getTrendingCourses(),
        courseService.getRecommendedCourses(category),
      ]);

      all = results[0];
      trending = results[1];
      recommended = results[2];
    } catch (e) {
      print('Error loading courses: $e');
      // Keep empty lists on error and try loading from local repository
      try {
        final repo = repository;
        all = await repo.getAll();
        trending = await repo.getTrendingTop5();
        recommended = await repo.getRecommendedForYou(category);
      } catch (e) {
        print('Error loading from local repository: $e');
        all = [];
        trending = [];
        recommended = [];
      }
    }

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

  // CRUD operations
  Future<Course?> createCourse(Course course) async {
    try {
      final newCourse = await courseService.createCourse(course);
      all.add(newCourse);
      notifyListeners();
      return newCourse;
    } catch (e) {
      print('Error creating course: $e');
      return null;
    }
  }

  Future<bool> updateCourse(int index, Map<String, dynamic> updates) async {
    try {
      final updatedCourse = await courseService.updateCourse(index, updates);
      final courseIndex = all.indexWhere((c) => c.index == index);
      if (courseIndex != -1) {
        all[courseIndex] = updatedCourse;
        notifyListeners();
      }
      return true;
    } catch (e) {
      print('Error updating course: $e');
      return false;
    }
  }

  Future<bool> deleteCourse(int index) async {
    try {
      await courseService.deleteCourse(index);
      all.removeWhere((c) => c.index == index);
      trending.removeWhere((c) => c.index == index);
      recommended.removeWhere((c) => c.index == index);
      notifyListeners();
      return true;
    } catch (e) {
      print('Error deleting course: $e');
      return false;
    }
  }
}
