import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projek_mobile/models/explore_model.dart';
import 'package:projek_mobile/screens/course_details.dart';

class SearchScreen extends StatefulWidget {
  final List<Course> courseList;

  const SearchScreen({super.key, required this.courseList});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  List<Course> _filtered = [];

  void _filter(String query) {
    setState(() {
      _filtered =
          widget.courseList
              .where(
                (course) =>
                    course.title.toLowerCase().contains(query.toLowerCase()),
              )
              .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          autofocus: true,
          controller: _controller,
          onChanged: _filter,
          decoration: const InputDecoration(
            hintText: 'Search for a course',
            border: InputBorder.none,
          ),
        ),
      ),
      body: ListView(
        children:
            _filtered
                .map(
                  (course) => ListTile(
                    title: Text(
                      course.title,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF324EAF),
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => CourseDetailScreen(
                                title: course.title,
                                imageUrl: course.images,
                                price: course.price,
                                rating: course.rating,
                                duration: course.duration,
                                isBestseller: course.isBestseller,
                                instructor: course.instructor,
                                recommendedCourses: [],
                              ),
                        ),
                      );
                    },
                  ),
                )
                .toList(),
      ),
    );
  }
}
