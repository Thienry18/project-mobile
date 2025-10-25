import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;
import 'package:http/http.dart' as http;
import 'package:projek_mobile/models/explore_model.dart';

class CourseService {
  // Platform-aware base URL so Android emulators can reach host machine.
  static String get baseUrl {
    if (kIsWeb) return 'http://localhost:4000/api';
    try {
      if (Platform.isAndroid) {
        // Android emulator maps host machine localhost to 10.0.2.2
        return 'http://10.0.2.2:4000/api';
      }
    } catch (_) {
      // Platform may not be available on web; fall back to localhost
    }
    return 'http://localhost:4000/api';
  }

  // Get all courses
  Future<List<Course>> getAllCourses() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/courses'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data
            .map(
              (json) => Course(
                images: (json['images'] ?? json['thumbnail'] ?? '') as String,
                title: (json['title'] ?? '') as String,
                duration: (json['duration'] ?? '') as String,
                rating:
                    (json['rating'] != null)
                        ? json['rating'].toString()
                        : '0.0',
                price: (json['price'] ?? '') as String,
                isBestseller: (json['isBestseller'] ?? false) as bool,
                index: (json['index'] ?? json['id'] ?? 0) as int,
                category: (json['category'] ?? '') as String,
                instructor: (json['instructor'] ?? '') as String,
                language: (json['language'] ?? '') as String,
                subtitle: (json['subtitle'] ?? '') as String,
              ),
            )
            .toList();
      }
      throw Exception('Failed to load courses');
    } catch (e) {
      throw Exception('Error connecting to server: $e');
    }
  }

  // Get trending courses
  Future<List<Course>> getTrendingCourses() async {
    // If backend does not expose a trending endpoint, compute based on all courses
    try {
      final all = await getAllCourses();
      // prefer bestsellers sorted by rating
      all.sort((a, b) => b.ratingNumber.compareTo(a.ratingNumber));
      return all.take(5).toList();
    } catch (e) {
      throw Exception('Error getting trending courses: $e');
    }
  }

  // Get recommended courses
  Future<List<Course>> getRecommendedCourses(String category) async {
    // Compute recommended courses locally by category
    try {
      final all = await getAllCourses();
      final filtered =
          all
              .where(
                (c) =>
                    c.category.toLowerCase().contains(category.toLowerCase()),
              )
              .toList();
      filtered.sort((a, b) => b.ratingNumber.compareTo(a.ratingNumber));
      return filtered.take(5).toList();
    } catch (e) {
      throw Exception('Error getting recommended courses: $e');
    }
  }

  // Create course
  Future<Course> createCourse(Course course) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/courses'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'images': course.images,
          'title': course.title,
          'duration': course.duration,
          'rating': course.rating,
          'price': course.price,
          'isBestseller': course.isBestseller,
          'category': course.category,
          'instructor': course.instructor,
          'language': course.language,
          'subtitle': course.subtitle,
        }),
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        return Course(
          images: data['images'],
          title: data['title'],
          duration: data['duration'],
          rating: data['rating'],
          price: data['price'],
          isBestseller: data['isBestseller'],
          index: data['index'],
          category: data['category'],
          instructor: data['instructor'],
          language: data['language'],
          subtitle: data['subtitle'],
        );
      }
      throw Exception('Failed to create course');
    } catch (e) {
      throw Exception('Error connecting to server: $e');
    }
  }

  // Update course
  Future<Course> updateCourse(int index, Map<String, dynamic> updates) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/courses/$index'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(updates),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Course(
          images: data['images'],
          title: data['title'],
          duration: data['duration'],
          rating: data['rating'],
          price: data['price'],
          isBestseller: data['isBestseller'],
          index: data['index'],
          category: data['category'],
          instructor: data['instructor'],
          language: data['language'],
          subtitle: data['subtitle'],
        );
      }
      throw Exception('Failed to update course');
    } catch (e) {
      throw Exception('Error connecting to server: $e');
    }
  }

  // Delete course
  Future<void> deleteCourse(int index) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/courses/$index'));

      if (response.statusCode != 200) {
        throw Exception('Failed to delete course');
      }
    } catch (e) {
      throw Exception('Error connecting to server: $e');
    }
  }
}
