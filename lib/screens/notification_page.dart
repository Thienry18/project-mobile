import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projek_mobile/constants/app_text_style.dart';
import 'package:projek_mobile/data/interest_data.dart';
import 'package:projek_mobile/screens/explore_page.dart';
import 'package:projek_mobile/screens/my_course_page.dart';
import 'package:projek_mobile/widgets/custom_bottom_nav.dart';
import 'package:projek_mobile/widgets/icon_circle_button.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          "Notification",
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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/notification.png', height: 200),
              const SizedBox(height: 24),
              Text("No Notification Yet", style: AppTextStyles.heading),
              const SizedBox(height: 12),
              Text(
                "Fresh start! We’ll let you know when there’s something worth your attention.",
                textAlign: TextAlign.center,
                style: AppTextStyles.subheading,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: 2,
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
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => MyCoursePage()),
              );
              break;
            case 2:
              break;
            // case 3:
            //   Navigator.push(
            //     context,
            //     MaterialPageRoute(builder: (_) => const ProfilePage()),
            //   );
            //   break;
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Color(0xff324eaf),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(90)),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
