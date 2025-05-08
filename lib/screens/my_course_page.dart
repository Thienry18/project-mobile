import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projek_mobile/constants/app_text_style.dart';
import 'package:projek_mobile/data/category.dart';
import 'package:projek_mobile/data/interest_data.dart';
import 'package:projek_mobile/screens/explore_page.dart';
import 'package:projek_mobile/widgets/category_chips.dart';
import 'package:projek_mobile/widgets/custom_bottom_nav.dart';
import 'package:projek_mobile/widgets/icon_circle_button.dart';

class MyCoursePage extends StatefulWidget {
  const MyCoursePage({super.key});

  @override
  State<MyCoursePage> createState() => _MyCoursePageState();
}

class _MyCoursePageState extends State<MyCoursePage> {
  final List<String> alllist = ['All', ...categoryList];
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          "My Course",
          style: GoogleFonts.poppins(
            color: const Color(0xFF324EAF),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        actions: [
          IconCircleButton(icon: Icons.event_available, onTap: () {}),
          const SizedBox(width: 10),
          IconCircleButton(icon: Icons.notifications, onTap: () {}),
          const SizedBox(width: 10),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Chips
            CategoryChips(
              categoryList: alllist,
              selectedIndex: selectedIndex,
              onCategorySelected: (index) {
                setState(() {
                  selectedIndex = index;
                });
              },
            ),
            const SizedBox(height: 32),
            // Image
            Center(
              child: Image.asset('assets/images/empty_course.png', height: 200),
            ),
            const SizedBox(height: 24),
            // Title
            Center(
              child: Text("Find Your Course", style: AppTextStyles.heading),
            ),
            const SizedBox(height: 12),
            // Description
            Center(
              child: Text(
                "Discover courses you're actually into and start learning in a way that feels easy and fun.",
                textAlign: TextAlign.center,
                style: AppTextStyles.subheading,
              ),
            ),
            const SizedBox(height: 20),
            // Explore Button
            Center(
              child: ElevatedButton(
                onPressed: () {},
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
            // case 2:
            //   Navigator.push(
            //     context,
            //     MaterialPageRoute(builder: (_) => const NotificationPage()),
            //   );
            //   break;
            // case 3:
            //   Navigator.push(
            //     context,
            //     MaterialPageRoute(builder: (_) => const ProfilePage()),
            //   );
            //   break;
          }
        },
      ),
    );
  }
}
