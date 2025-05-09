import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projek_mobile/data/interest_data.dart';
import 'package:projek_mobile/screens/explore_page.dart';
import 'package:projek_mobile/screens/my_course_page.dart';
import 'package:projek_mobile/screens/notification_page.dart';
import 'package:projek_mobile/screens/sign_in.dart';
import 'package:projek_mobile/widgets/custom_bottom_nav.dart';
import 'package:projek_mobile/widgets/menu_item.dart';
import 'package:projek_mobile/widgets/toggle_item.dart';
import 'package:provider/provider.dart';
import 'package:projek_mobile/providers/theme_provider.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool isNotificationEnabled = false;

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Profile",
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color:
                            Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : const Color(0xff324eaf),
                      ),
                    ),
                    Row(
                      children: const [
                        Icon(Icons.diamond, color: Colors.blueAccent, size: 28),
                        SizedBox(width: 20),
                        Icon(Icons.shopping_cart_outlined, size: 28),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: Column(
                  children: [
                    const CircleAvatar(radius: 70),
                    const SizedBox(height: 13),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFBDBDBD),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        "Basic",
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color:
                              Theme.of(context).brightness == Brightness.dark
                                  ? const Color(0xff324eaf)
                                  : Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      "Moon Ga-young",
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color:
                            Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : const Color(0xff324eaf),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "Student",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              MenuItem(
                icon: Icons.person_outline,
                title: "Edit Profile",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => const Scaffold(
                            body: Center(child: Text("Coming Soon")),
                          ),
                    ),
                  );
                },
              ),
              MenuItem(
                icon: Icons.settings_outlined,
                title: "Settings",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => const Scaffold(
                            body: Center(child: Text("Coming Soon")),
                          ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 25),
              ToggleItem(
                icon: Icons.dark_mode_outlined,
                title: "Dark Mode",
                value: themeNotifier.isDarkMode,
                onChanged: (val) {
                  themeNotifier.toggleTheme(val);
                },
              ),
              ToggleItem(
                icon: Icons.notifications_none,
                title: "Notification",
                value: isNotificationEnabled,
                onChanged: (val) {
                  setState(() {
                    isNotificationEnabled = val;
                  });
                },
              ),
              const SizedBox(height: 25),
              MenuItem(
                icon: Icons.lock_outline,
                title: "Privacy",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => const Scaffold(
                            body: Center(child: Text("Coming Soon")),
                          ),
                    ),
                  );
                },
              ),
              MenuItem(
                icon: Icons.shield_outlined,
                title: "Security",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => const Scaffold(
                            body: Center(child: Text("Coming Soon")),
                          ),
                    ),
                  );
                },
              ),
              MenuItem(
                icon: Icons.help_outline,
                title: "FAQ",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => const Scaffold(
                            body: Center(child: Text("Coming Soon")),
                          ),
                    ),
                  );
                },
              ),
              MenuItem(
                icon: Icons.info_outline,
                title: "About App",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => const Scaffold(
                            body: Center(child: Text("Coming Soon")),
                          ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 25),
              MenuItem(
                icon: Icons.logout,
                title: "Sign Out",
                trailing: Icon(
                  Icons.arrow_forward_rounded,
                  color:
                      Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : const Color(0xff324eaf),
                  size: 20,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SignIn()),
                  );
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: 3,
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
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => NotificationPage()),
              );
              break;
            case 3:
              break;
          }
        },
      ),
    );
  }
}
