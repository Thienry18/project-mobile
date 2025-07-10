import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projek_mobile/constants/app_text_style.dart';
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
          decoration: InputDecoration(
            hintText: 'Search for a course',
            hintStyle: AppTextStyles.body.copyWith(
              color: Colors.grey,
              fontSize: 16.0,
            ),
            border: InputBorder.none,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.grey),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Icon(Icons.search, color: Colors.grey, size: 28.0),
          ),
        ],
      ),
      body: ListView(
        children:
            _filtered
                .map(
                  (course) => ListTile(
                    leading: Image.asset(
                      course.images,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder:
                          (context, error, stackTrace) =>
                              const Icon(Icons.error_outline, size: 50),
                    ),
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
