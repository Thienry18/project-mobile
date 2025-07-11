import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projek_mobile/constants/app_text_style.dart';
import 'package:projek_mobile/data/category.dart';
import 'package:projek_mobile/data/explore_data.dart';
import 'package:projek_mobile/data/interest_data.dart';
import 'package:projek_mobile/data/my_course_data.dart';
import 'package:projek_mobile/models/explore_model.dart';
import 'package:projek_mobile/providers/theme_provider.dart';
import 'package:projek_mobile/screens/cart.dart';
import 'package:projek_mobile/screens/certificate.dart';
import 'package:projek_mobile/screens/course_details.dart';
import 'package:projek_mobile/screens/explore_page.dart';
import 'package:projek_mobile/screens/notification_page.dart';
import 'package:projek_mobile/screens/profile.dart';
import 'package:projek_mobile/screens/search_screen.dart';
import 'package:projek_mobile/screens/video_player.dart';
import 'package:projek_mobile/widgets/custom_bottom_nav.dart';
import 'package:projek_mobile/widgets/icon_circle_button.dart';
import 'package:projek_mobile/widgets/category_chips.dart';
import 'package:projek_mobile/widgets/share_button.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class MyCoursePage extends StatefulWidget {
  const MyCoursePage({super.key});

  @override
  State<MyCoursePage> createState() => _MyCoursePageState();
}

class _MyCoursePageState extends State<MyCoursePage> {
  final List<String> alllist = ['All', ...categoryList];
  Set<int> selectedIndexes = {0};
  @override
  void initState() {
    super.initState();
    _loadStoredCourses();
  }

  Future<void> _loadStoredCourses() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('my_courses');
    if (data != null) {
      final decoded = jsonDecode(data);
      setState(() {
        myCourses.clear();
        myCourses.addAll(
          List<Course>.from(
            decoded.map(
              (e) => Course(
                index: e['index'],
                title: e['title'],
                price: e['price'],
                images: e['images'],
                category: e['category'],
                rating: e['rating'],
                duration: e['duration'],
                isBestseller: e['isBestseller'],
                instructor: e['instructor'],
                language: e['language'],
                subtitle: e['subtitle'],
              ),
            ),
          ),
        );
      });
    }
  }

  void openGoogleForm() async {
    final url = Uri.parse(
      'https://docs.google.com/forms/d/e/1FAIpQLSf1Y-EDqmFYjf7_k4XJ6WPbpk2DbeKHvjGoHK_IbgDWrZK4QA/viewform?usp=dialog',
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Tidak bisa membuka form';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeNotifier>(context).isDarkMode;

    final filteredCourses =
        selectedIndexes.contains(0)
            ? myCourses
            : myCourses.where((course) {
              final selectedCategories =
                  selectedIndexes.map((i) => categoryList[i - 1]).toList();
              return selectedCategories.contains(course.category);
            }).toList();

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: isDarkMode ? Colors.black : const Color(0xFF324EAF),
        title: Text(
          "My Course",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => SearchScreen(courseList: trendingCourses),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartPage()),
              );
            },
          ),
          const SizedBox(width: 10),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child:
            myCourses.isEmpty
                ? _buildEmptyState(isDarkMode)
                : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    CategoryChips(
                      categoryList: alllist,
                      selectedIndexes: selectedIndexes,
                      onCategoryToggle: (index) {
                        setState(() {
                          if (selectedIndexes.contains(index)) {
                            selectedIndexes.remove(index);
                          } else {
                            selectedIndexes.add(index);
                          }
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    Expanded(child: _buildCourseCardList(filteredCourses)),
                  ],
                ),
      ),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: 1,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder:
                      (_) => ExplorePage(selectedCategory: categoryselected),
                ),
              );
              break;
            case 1:
              break;
            case 2:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => NotificationPage()),
              );
              break;
            case 3:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => Profile()),
              );
              break;
          }
        },
      ),
    );
  }

  Widget _buildCourseCardList(List<Course> courseList) {
    final isDarkMode = Provider.of<ThemeNotifier>(context).isDarkMode;
    return ListView.builder(
      itemCount: courseList.length,
      itemBuilder: (context, index) {
        final course = courseList[index];
        return Card(
          color: isDarkMode ? Colors.black : Colors.white,
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 48),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  leading: Image.asset(
                    course.images,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                  title: Text(
                    course.title,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color:
                          isDarkMode ? Colors.white : const Color(0xFF324EAF),
                    ),
                  ),
                  subtitle: Text(
                    course.category,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: isDarkMode ? Colors.white70 : Colors.grey,
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.more_vert),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(10),
                          ),
                        ),
                        builder:
                            (context) => _buildBottomSheet(context, course),
                      );
                    },
                  ),
                ),
              ),
              Positioned(
                bottom: 8,
                right: 12,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => VideoPlayer(course: course),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Continue",
                        style: GoogleFonts.poppins(color: Colors.white),
                      ),
                      const SizedBox(width: 6),
                      const Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                        size: 18,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBottomSheet(BuildContext context, Course course) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              dense: true,
              leading: const Icon(Icons.start, color: Colors.grey),
              title: Text(
                "Start/Continue Course",
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Color(0xFF324EAF),
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VideoPlayer(course: course),
                  ),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.workspace_premium, color: Colors.grey),
              title: Text(
                "View Certificate",
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Color(0xFF324EAF),
                ),
              ),
              onTap: () {
                Navigator.pop(context); // Tutup bottom sheet
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => const CertificateImageScreen(
                          imagePath:
                              'assets/images/certificate.jpg', // sesuaikan path
                        ),
                  ),
                );
              },
            ),

            const Divider(),
            ListTile(
              leading: const Icon(Icons.schedule, color: Colors.grey),
              title: Text(
                "Set Reminder/Schedule",
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Color(0xFF324EAF),
                ),
              ),
              onTap: () => Navigator.pop(context),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.share, color: Colors.grey),
              title: Text(
                "Share Course",
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Color(0xFF324EAF),
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                showShareOptions(context, course.title);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.grid_view, color: Colors.grey),
              title: Text(
                "View Course Details",
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Color(0xFF324EAF),
                ),
              ),
              onTap: () {
                Navigator.pop(context); // Tutup bottom sheet
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
                          recommendedCourses:
                              const [], // atau isi sesuai kebutuhan
                        ),
                  ),
                );
              },
            ),

            const Divider(),
            ListTile(
              leading: const Icon(Icons.report, color: Colors.grey),
              title: Text(
                "Report a Problem",
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Color(0xFF324EAF),
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                openGoogleForm();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isDarkMode) {
    return Column(
      children: [
        const SizedBox(height: 100),
        Center(
          child: Image.asset('assets/images/empty_course.png', height: 200),
        ),
        const SizedBox(height: 24),
        Center(
          child: Text(
            "Find Your Course",
            style: AppTextStyles.heading.copyWith(
              color: isDarkMode ? Colors.white : const Color(0xff324eaf),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Center(
          child: Text(
            "Discover courses you're actually into and start learning in a way that feels easy and fun.",
            textAlign: TextAlign.center,
            style: AppTextStyles.subheading.copyWith(
              color: isDarkMode ? Colors.white : const Color(0xff324eaf),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder:
                      (_) => ExplorePage(selectedCategory: categoryselected),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Explore", style: TextStyle(color: Colors.white)),
                  SizedBox(width: 6),
                  Icon(Icons.arrow_right_alt, color: Colors.white),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
