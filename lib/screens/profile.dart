import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projek_mobile/data/interest_data.dart';
import 'package:projek_mobile/models/user_profile.dart';
import 'package:projek_mobile/providers/profile_image_provider.dart';
import 'package:projek_mobile/providers/theme_provider.dart';
import 'package:projek_mobile/screens/cart.dart';
import 'package:projek_mobile/screens/coming_soon.dart';
import 'package:projek_mobile/screens/edit_profile.dart';
import 'package:projek_mobile/screens/explore_page.dart';
import 'package:projek_mobile/screens/my_course_page.dart';
import 'package:projek_mobile/screens/notification_page.dart';
import 'package:projek_mobile/screens/payment_method.dart';
import 'package:projek_mobile/screens/security.dart';
import 'package:projek_mobile/widgets/custom_bottom_nav.dart';
import 'package:projek_mobile/widgets/menu_item.dart';
import 'package:projek_mobile/widgets/sign_out_dialog.dart';
import 'package:projek_mobile/widgets/toggle_item.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool isNotificationEnabled = false;
  UserProfile? userProfile;

  String? displayUsername;
  String? displayEmail;
  String? avatarPath; // optional fallback jika provider belum punya gambar

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final prefs = await SharedPreferences.getInstance();

    final spUsername = prefs.getString('user_username');
    final spEmail = prefs.getString('user_email');
    final spAvatar = prefs.getString('user_avatar_path');

    final data = prefs.getString('user_profile');
    if (data != null) {
      final json = jsonDecode(data);
      userProfile = UserProfile(
        username: json['username'],
        fullName: json['fullName'],
        dob: json['dob'],
        gender: json['gender'],
        phoneNumber: json['phoneNumber'],
        country: json['country'],
      );
    }

    setState(() {
      displayUsername =
          spUsername ?? userProfile?.username ?? userProfile?.fullName;
      displayEmail = spEmail;
      avatarPath = spAvatar; // dipakai sebagai fallback avatar
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final isDarkMode = themeNotifier.isDarkMode;

    final providerImage = context.watch<ProfileImageProvider>().image;

    ImageProvider avatarProvider;
    if (providerImage != null) {
      avatarProvider = FileImage(providerImage);
    } else if ((avatarPath ?? '').isNotEmpty &&
        File(avatarPath!).existsSync()) {
      avatarProvider = FileImage(File(avatarPath!));
    } else {
      avatarProvider = const AssetImage("assets/images/default_profile.png");
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: isDarkMode ? Colors.black : const Color(0xff324eaf),
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Profile",
          style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w700),
        ),
        actions: [
          Tooltip(
            message: 'premium',
            child: IconButton(
              icon: const Icon(
                Icons.diamond,
                color: Colors.blueAccent,
                size: 28,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ComingSoon()),
                );
              },
            ),
          ),
          Tooltip(
            message: 'Cart',
            child: IconButton(
              icon: const Icon(Icons.shopping_cart_outlined, size: 28),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CartPage()),
                );
              },
            ),
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
                      CircleAvatar(radius: 70, backgroundImage: avatarProvider),
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
                        displayUsername ?? "Your Name",
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
                        displayEmail ?? "Student",
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

                // EDIT PROFILE
                MenuItem(
                  icon: Icons.person_outline,
                  iconColor: const Color(0XFF696969),
                  title: "Edit Profile",
                  onTap: () async {
                    if (userProfile != null) {
                      final updated = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  EditProfileScreen(userProfile: userProfile!),
                        ),
                      );
                      if (updated == true) {
                        await _loadUserProfile(); // refresh SP → UI
                      }
                    } else {
                      // fallback: kalau belum ada user_profile JSON, tetap boleh buka
                      final updated = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => EditProfileScreen(
                                userProfile: UserProfile(
                                  username: displayUsername ?? '',
                                  fullName: displayUsername ?? '',
                                  dob: '',
                                  gender: '',
                                  phoneNumber: '',
                                  country: '',
                                ),
                              ),
                        ),
                      );
                      if (updated == true) {
                        await _loadUserProfile();
                      }
                    }
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
                        builder: (context) => const PaymentMethodsScreen(),
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
                  icon: Icons.shield_outlined,
                  iconColor: const Color(0XFF696969),
                  title: "Security",
                  onTap:
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SecurityScreen(),
                        ),
                      ),
                ),

                const SizedBox(height: 25),
                MenuItem(
                  icon: Icons.logout,
                  title: "Sign Out",
                  iconColor: Colors.red,
                  textColor: Colors.red,
                  trailing: Icon(
                    Icons.arrow_forward_rounded,
                    color: isDarkMode ? Colors.white : Colors.red,
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
                MaterialPageRoute(builder: (_) => const MyCoursePage()),
              );
              break;
            case 2:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const NotificationPage()),
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
