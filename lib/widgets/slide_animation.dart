import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projek_mobile/models/explore_model.dart';

Widget autoSlideCourseBanner({
  required List<Course> courses,
  double height = 188,
  double borderRadius = 12,
  Duration duration = const Duration(seconds: 3),
}) {
  return _AutoSlideCourseBannerWidget(
    courses: courses,
    height: height,
    borderRadius: borderRadius,
    duration: duration,
  );
}

class _AutoSlideCourseBannerWidget extends StatefulWidget {
  final List<Course> courses;
  final double height;
  final double borderRadius;
  final Duration duration;

  const _AutoSlideCourseBannerWidget({
    required this.courses,
    required this.height,
    required this.borderRadius,
    required this.duration,
  });

  @override
  State<_AutoSlideCourseBannerWidget> createState() =>
      _AutoSlideCourseBannerWidgetState();
}

class _AutoSlideCourseBannerWidgetState
    extends State<_AutoSlideCourseBannerWidget> {
  int _currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startAutoSwitch();
  }

  void _startAutoSwitch() {
    _timer = Timer.periodic(widget.duration, (_) {
      setState(() {
        _currentIndex = (_currentIndex + 1) % widget.courses.length;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final course = widget.courses[_currentIndex];
    return Column(
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 800),
          transitionBuilder: (child, animation) {
            return FadeTransition(opacity: animation, child: child);
          },
          child: ClipRRect(
            key: ValueKey(course.index),
            borderRadius: BorderRadius.circular(widget.borderRadius),
            child: Stack(
              children: [
                Image.asset(
                  course.images,
                  height: widget.height,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  left: 16,
                  bottom: 16,
                  right: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        course.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            size: 14,
                            color: Colors.yellow,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            course.rating,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (course.isBestseller)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: const BoxDecoration(
                        color: Colors.yellow,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                        ),
                      ),
                      child: Text(
                        'Bestseller',
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF324EAF),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.courses.length, (index) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: _currentIndex == index ? 12 : 8,
              height: 8,
              decoration: BoxDecoration(
                color:
                    _currentIndex == index
                        ? const Color(0xFF324EAF)
                        : Colors.grey[300],
                borderRadius: BorderRadius.circular(4),
              ),
            );
          }),
        ),
      ],
    );
  }
}
