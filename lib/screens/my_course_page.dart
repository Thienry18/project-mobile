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
import 'package:projek_mobile/widgets/category_chips.dart';
import 'package:projek_mobile/widgets/custom_bottom_nav.dart';
import 'package:projek_mobile/widgets/share_button.dart';
import 'package:provider/provider.dart';
import 'package:projek_mobile/database/database_service.dart';
import 'package:projek_mobile/database/database_mycourse.dart';
import 'package:projek_mobile/database/database_user.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:projek_mobile/l10n/app_localizations.dart';
import 'package:projek_mobile/services/ad_service.dart';
import 'package:projek_mobile/widgets/banner_ad_widget.dart';

class MyCoursePage extends StatefulWidget {
  const MyCoursePage({super.key});

  @override
  State<MyCoursePage> createState() => _MyCoursePageState();
}

class _MyCoursePageState extends State<MyCoursePage> {
  late List<String> alllist;
  Set<int> selectedIndexes = {0};
  DateTime? _scheduledDateTime;

  @override
  void initState() {
    super.initState();
    _loadStoredCourses();
    // Will be set in build once context is available
  }

  Future<void> _loadStoredCourses() async {
    try {
      final userId = await DatabaseUser.getOrCreateDemoUserIdForApp();
      final db = await DatabaseService.instance.database;
      final rows = await DatabaseMyCourse.getMyCourses(db, userId);
      setState(() {
        myCourses.clear();
        myCourses.addAll(
          rows
              .map(
                (e) => Course(
                  index: (e['course_id'] as num?)?.toInt() ?? (e['id'] as int),
                  title: e['title'] as String? ?? 'Course',
                  price: e['price'] as String? ?? '0',
                  images:
                      e['image'] as String? ??
                      'assets/images/card_image/udemy_course.jpg',
                  category: '',
                  rating: e['rating'] as String? ?? '0',
                  duration: '',
                  isBestseller: false,
                  instructor: e['instructor'] as String? ?? '',
                  language: '',
                  subtitle: '',
                ),
              )
              .toList(),
        );
      });
    } catch (e) {
      // ignore: avoid_print
      print('Failed to load mycourse from DB: $e');
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

  Future<void> _pickScheduleDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time == null) return;

    final scheduled = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );

    setState(() {
      _scheduledDateTime = scheduled;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context).reminderSet)),
    );
  }

  @override
  Widget build(BuildContext context) {
    alllist = [AppLocalizations.of(context).allCategories, ...categoryList];
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
          AppLocalizations.of(context).myCourses,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Tooltip(
            message: AppLocalizations.of(context).search,
            child: IconButton(
              icon: const Icon(Icons.search, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SearchScreen(courseList: trendingCourses),
                  ),
                );
              },
            ),
          ),
          Tooltip(
            message: AppLocalizations.of(context).cart,
            child: IconButton(
              icon: const Icon(
                Icons.shopping_cart_outlined,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CartPage()),
                );
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          BannerAdWidget(adUnitId: AdService.bannerUnitId),
          const SizedBox(height: 8),
          if (_scheduledDateTime != null)
            Container(
              width: double.infinity,
              color: Colors.green.shade50,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              child: Row(
                children: [
                  const Icon(Icons.schedule, color: Colors.green),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      AppLocalizations.of(context).reminderSetOn(
                        _scheduledDateTime!.toLocal().toString().substring(
                          0,
                          16,
                        ),
                      ),
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.green[900],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: Padding(
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
                                selectedIndexes.contains(index)
                                    ? selectedIndexes.remove(index)
                                    : selectedIndexes.add(index);
                              });
                            },
                          ),
                          const SizedBox(height: 16),
                          Expanded(
                            child: _buildCourseCardList(filteredCourses),
                          ),
                        ],
                      ),
            ),
          ),
        ],
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
                MaterialPageRoute(builder: (_) => const NotificationPage()),
              );
              break;
            case 3:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const Profile()),
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
                  trailing: Tooltip(
                    message: AppLocalizations.of(context).moreOptions,
                    child: IconButton(
                      icon: const Icon(Icons.more_vert),
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(10),
                            ),
                          ),
                          builder: (_) => _buildBottomSheet(context, course),
                        );
                      },
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 8,
                right: 12,
                child: ElevatedButton(
                  onPressed: () async {
                    await AdService.instance.showInterstitial();
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
                        AppLocalizations.of(context).continueButton,
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildBottomSheetTile(
            icon: Icons.start,
            label: AppLocalizations.of(context).startContinueCourse,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => VideoPlayer(course: course)),
              );
            },
          ),
          _buildDivider(),
          _buildBottomSheetTile(
            icon: Icons.workspace_premium,
            label: AppLocalizations.of(context).viewCertificate,
            onTap: () {
              Navigator.pop(context);
              AdService.instance.showRewarded(
                onEarned: (reward) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => const CertificateImageScreen(
                            imagePath: 'assets/images/certificate.jpg',
                          ),
                    ),
                  );
                },
              );
            },
          ),
          _buildDivider(),
          _buildBottomSheetTile(
            icon: Icons.schedule,
            label: AppLocalizations.of(context).setReminder,
            onTap: () {
              Navigator.pop(context);
              _pickScheduleDateTime();
            },
          ),
          _buildDivider(),
          _buildBottomSheetTile(
            icon: Icons.share,
            label: AppLocalizations.of(context).shareCourse,
            onTap: () {
              Navigator.pop(context);
              showShareOptions(context, course.title);
            },
          ),
          _buildDivider(),
          _buildBottomSheetTile(
            icon: Icons.grid_view,
            label: AppLocalizations.of(context).viewCourseDetails,
            onTap: () {
              Navigator.pop(context);
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
                        recommendedCourses: const [],
                      ),
                ),
              );
            },
          ),
          _buildDivider(),
        ],
      ),
    );
  }

  Widget _buildBottomSheetTile({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return ListTile(
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      horizontalTitleGap: 8,
      leading: Icon(icon, color: Colors.grey.shade700, size: 18),
      title: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 13,
          color: const Color(0xFF324EAF),
          fontWeight: FontWeight.w600,
        ),
      ),
      onTap: onTap,
    );
  }

  Widget _buildDivider() => const Divider(height: 0, thickness: 0.5);

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
            AppLocalizations.of(context).findYourCourse,
            style: AppTextStyles.heading.copyWith(
              color: isDarkMode ? Colors.white : const Color(0xff324eaf),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Center(
          child: Text(
            AppLocalizations.of(context).discoverCourses,
            textAlign: TextAlign.center,
            style: AppTextStyles.subheading.copyWith(
              color: isDarkMode ? Colors.white : const Color(0xff324eaf),
            ),
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => ExplorePage(selectedCategory: categoryselected),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  AppLocalizations.of(context).explore,
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(width: 6),
                const Icon(Icons.arrow_right_alt, color: Colors.white),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
