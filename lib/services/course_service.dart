import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:projek_mobile/models/explore_model.dart';

class CourseService {
  static const String baseUrl = 'http://localhost:4000/api';

  // Get all courses
  Future<List<Course>> getAllCourses() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/courses'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data
            .map(
              (json) => Course(
                images: json['images'],
                title: json['title'],
                duration: json['duration'],
                rating: json['rating'],
                price: json['price'],
                isBestseller: json['isBestseller'],
                index: json['index'],
                category: json['category'],
                instructor: json['instructor'],
                language: json['language'],
                subtitle: json['subtitle'],
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
    try {
      final response = await http.get(Uri.parse('$baseUrl/courses/trending'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data
            .map(
              (json) => Course(
                images: json['images'],
                title: json['title'],
                duration: json['duration'],
                rating: json['rating'],
                price: json['price'],
                isBestseller: json['isBestseller'],
                index: json['index'],
                category: json['category'],
                instructor: json['instructor'],
                language: json['language'],
                subtitle: json['subtitle'],
              ),
            )
            .toList();
      }
      throw Exception('Failed to load trending courses');
    } catch (e) {
      throw Exception('Error connecting to server: $e');
    }
  }

  // Get recommended courses
  Future<List<Course>> getRecommendedCourses(String category) async {
    try {
      final response = await http.get(
        Uri.parse(
          '$baseUrl/courses/recommended/${Uri.encodeComponent(category)}',
        ),
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data
            .map(
              (json) => Course(
                images: json['images'],
                title: json['title'],
                duration: json['duration'],
                rating: json['rating'],
                price: json['price'],
                isBestseller: json['isBestseller'],
                index: json['index'],
                category: json['category'],
                instructor: json['instructor'],
                language: json['language'],
                subtitle: json['subtitle'],
              ),
            )
            .toList();
      }
      throw Exception('Failed to load recommended courses');
    } catch (e) {
      throw Exception('Error connecting to server: $e');
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
