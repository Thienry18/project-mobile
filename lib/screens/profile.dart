import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projek_mobile/data/interest_data.dart';
import 'package:projek_mobile/providers/profile_image_provider.dart';
import 'package:projek_mobile/providers/theme_provider.dart';
import 'package:projek_mobile/screens/cart.dart';
import 'package:projek_mobile/screens/coming_soon.dart';
import 'package:projek_mobile/screens/explore_page.dart';
import 'package:projek_mobile/screens/my_course_page.dart';
import 'package:projek_mobile/screens/notification_page.dart';
import 'package:projek_mobile/screens/payment_method.dart';
import 'package:projek_mobile/widgets/custom_bottom_nav.dart';
import 'package:projek_mobile/widgets/menu_item.dart';
import 'package:projek_mobile/widgets/sign_out_dialog.dart';
import 'package:projek_mobile/widgets/toggle_item.dart';
import 'package:provider/provider.dart';
import 'package:projek_mobile/screens/edit_profile.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool isNotificationEnabled = false;

  @override
  Widget build(BuildContext context) {
    Future<void> _pickImage(BuildContext context) async {
      final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (picked != null) {
        final imageFile = File(picked.path);
        context.read<ProfileImageProvider>().setImage(imageFile);
      }
    }

    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final isDarkMode = themeNotifier.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor:
            themeNotifier.isDarkMode ? Colors.black : const Color(0xff324eaf),
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Profile",
          style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.diamond, color: Colors.blueAccent, size: 28),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ComingSoon()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined, size: 28),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartPage()),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            color: isDarkMode ? Colors.black : Colors.white,
            child: Column(
              children: [
                const SizedBox(height: 12),
                Center(
                  child: Column(
                    children: [
                      Consumer<ProfileImageProvider>(
                        builder: (context, profileImageProvider, _) {
                          final imageFile = profileImageProvider.image;
                          return CircleAvatar(
                            radius: 70,
                            backgroundImage:
                                imageFile != null
                                    ? FileImage(imageFile)
                                    : const AssetImage(
                                          "assets/images/default_profile.png",
                                        )
                                        as ImageProvider,
                          );
                        },
                      ),
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
                                isDarkMode
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
                              isDarkMode
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
                  iconColor: const Color(0XFF696969),
                  title: "Edit Profile",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EditProfileScreen(),
                      ),
                    );
                  },
                ),
                MenuItem(
                  icon: Icons.payment_outlined,
                  iconColor: const Color(0XFF696969),
                  title: "Payment Methods",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PaymentMethodsScreen(),
                      ),
                    );
                  },
                ),
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
                MenuItem(
                  icon: Icons.lock_outline,
                  iconColor: const Color(0XFF696969),
                  title: "Privacy",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ComingSoon()),
                    );
                  },
                ),
                MenuItem(
                  icon: Icons.shield_outlined,
                  iconColor: const Color(0XFF696969),
                  title: "Security",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ComingSoon()),
                    );
                  },
                ),
                MenuItem(
                  icon: Icons.help_outline,
                  iconColor: const Color(0XFF696969),
                  title: "FAQ",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ComingSoon()),
                    );
                  },
                ),
                MenuItem(
                  icon: Icons.info_outline,
                  iconColor: const Color(0XFF696969),
                  title: "About App",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ComingSoon()),
                    );
                  },
                ),
                const SizedBox(height: 25),
                MenuItem(
                  icon: Icons.logout,
                  title: "Sign Out",
                  iconColor: Colors.red,
                  textColor: Colors.red,
                  trailing: Icon(
                    Icons.arrow_forward_rounded,
                    color:
                        Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.red,
                    size: 20,
                  ),
                  onTap: () {
                    signOutDialog(context);
                  },
                ),
                const SizedBox(height: 16),
              ],
            ),
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
