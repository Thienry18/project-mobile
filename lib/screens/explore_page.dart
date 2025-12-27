import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projek_mobile/data/category.dart';
import 'package:projek_mobile/models/explore_model.dart';
import 'package:projek_mobile/providers/profile_image_provider.dart';
import 'package:projek_mobile/providers/theme_provider.dart';
import 'package:projek_mobile/database/database_service.dart';
import 'package:projek_mobile/database/database_course.dart';
import 'package:projek_mobile/data/db_helper.dart';
import 'package:projek_mobile/database/database_cart.dart';
import 'package:projek_mobile/database/database_user.dart';
import 'package:projek_mobile/screens/cart.dart';
import 'package:projek_mobile/screens/coming_soon.dart';
import 'package:projek_mobile/screens/contact.dart';
import 'package:projek_mobile/screens/course_details.dart';
import 'package:projek_mobile/l10n/app_localizations.dart';
import 'package:projek_mobile/firebase/firebase_analytics_service.dart';
import 'package:projek_mobile/screens/my_course_page.dart';
import 'package:projek_mobile/screens/notification_page.dart';
import 'package:projek_mobile/screens/profile.dart';
import 'package:projek_mobile/widgets/category_chips.dart';
import 'package:projek_mobile/services/course_service.dart';
import 'package:projek_mobile/providers/locale_provider.dart';
import 'package:provider/provider.dart';
import 'package:projek_mobile/services/ad_service.dart';
import 'package:projek_mobile/widgets/banner_ad_widget.dart';
import 'package:projek_mobile/widgets/custom_bottom_nav.dart';
import 'package:projek_mobile/screens/search_screen.dart';
import 'package:projek_mobile/widgets/sign_out_dialog.dart';
import 'package:projek_mobile/widgets/slide_animation.dart';
import 'package:projek_mobile/widgets/search_bar.dart';
import 'package:projek_mobile/screens/my_certificate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:projek_mobile/services/awesome_notification_service.dart';
import 'package:projek_mobile/database/database_mycourse.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key, required this.selectedCategory});
  final String selectedCategory;

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  Set<int> favoriteCourses = {};
  Set<int> selectedIndexes = {0};

  // Local state
  bool isLoading = false;
  List<Course> trending = [];
  List<Course> recommended = [];
  List<Course> all = [];

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final initialCat =
          widget.selectedCategory.isEmpty ? 'Python' : widget.selectedCategory;
      return _loadByCategory(initialCat);
    });
    _checkForCourseReminders();
  }

  Future<void> _checkForCourseReminders() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final email = prefs.getString('user_email');
      if (email == null) return;

      final db = await DatabaseService.instance.database;
      final user = await DatabaseUser.getUserByEmail(db, email);
      if (user == null) return;

      final userId = user['id'] as int;
      final myCourses = await DatabaseMyCourse.getMyCourses(db, userId);

      for (final course in myCourses) {
        final progress = course['progress'] as double? ?? 0.0;
        if (progress > 0.0 && progress < 1.0) {
          final courseTitle = course['title'] as String;
          final progressPercent = (progress * 100).round();
          await AwesomeNotificationService.showCourseReminder(
            courseTitle,
            progressPercent,
          );
          break; // Show only one reminder
        }
      }
    } catch (e) {
      print('Error checking course reminders: $e');
    }
  }

  Future<void> _loadByCategory(String category) async {
    setState(() {
      isLoading = true;
    });

    try {
      // Try API first
      final courseService = CourseService();
      final lang = context.read<LocaleProvider>().locale.languageCode;

      // Fetch data (CourseService computes trending/recommended if backend doesn't)
      final allCourses = await courseService.getAllCourses(lang: lang);
      final trendingCourses = await courseService.getTrendingCourses();
      final recommendedCourses = await courseService.getRecommendedCourses(
        category,
      );

      // Check for new courses and show update notification
      await _checkForNewCourses(allCourses);

      all = allCourses;
      trending = trendingCourses;
      recommended = recommendedCourses;
    } catch (e) {
      // API failed -> fallback to local DB
      print('Error fetching from API: $e');
      print('Falling back to local database');

      try {
        // If API fails, try DatabaseService
        final db = await DatabaseService.instance.database;
        all = await DatabaseCourse.getAll(db);
        trending = await DatabaseCourse.getTrendingTop5(db);
        recommended = await DatabaseCourse.getRecommendedForYou(db, category);

        // If DatabaseService is empty, try legacy DbHelper
        if (all.isEmpty) {
          final legacyDb = DbHelper.instance;
          all = await legacyDb.getAll();
          trending = await legacyDb.getTrendingTop5();
          recommended = await legacyDb.getRecommendedForYou(category);
        }
      } catch (dbError) {
        print('Error fetching from database: $dbError');
        // Keep empty lists as last resort
        all = [];
        trending = [];
        recommended = [];
      }
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = context.watch<ThemeNotifier>().isDarkMode;

    final List<Course> trendingLocal = trending;
    final List<Course> recommendedLocal = recommended;
    final List<Course> allCourses = all;

    final List<Course> filteredCourses =
        selectedIndexes.isNotEmpty
            ? allCourses.where((course) {
              final catIdx = categoryList.indexOf(course.category);
              return selectedIndexes.contains(catIdx);
            }).toList()
            : allCourses;

    return Scaffold(
      backgroundColor:
          isDarkMode ? Colors.black : theme.scaffoldBackgroundColor,

      drawer: Drawer(
        backgroundColor: Colors.white,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Image.asset(
                  'assets/images/logo.jpg',
                  width: 120,
                  height: 120,
                  fit: BoxFit.contain,
                ),
              ),
              Consumer<ProfileImageProvider>(
                builder: (context, profileImageProvider, _) {
                  final imageFile = profileImageProvider.image;
                  return Tooltip(
                    message: AppLocalizations.of(context).profile,
                    child: CircleAvatar(
                      radius: 30,
                      backgroundImage:
                          imageFile != null
                              ? FileImage(imageFile)
                              : const AssetImage(
                                    "assets/images/default_profile.png",
                                  )
                                  as ImageProvider,
                    ),
                  );
                },
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0XFF969696),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  AppLocalizations.of(context).basic,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 50),
              Text(
                AppLocalizations.of(context).account,
                style: GoogleFonts.poppins(
                  color: const Color(0xFF7A8EDA),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                leading: const Icon(
                  Icons.workspace_premium,
                  color: Color(0xff696969),
                  size: 16,
                ),
                title: Text(
                  AppLocalizations.of(context).myCertificates,
                  style: GoogleFonts.poppins(
                    color: const Color(0XFF324EAF),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CertificatePage()),
                  );
                },
              ),
              const SizedBox(height: 40),
              Text(
                AppLocalizations.of(context).support,
                style: GoogleFonts.poppins(
                  color: const Color(0xFF7A8EDA),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                leading: const Icon(
                  Icons.search,
                  color: Color(0xff696969),
                  size: 16,
                ),
                title: Text(
                  AppLocalizations.of(context).searchCourse,
                  style: GoogleFonts.poppins(
                    color: const Color(0xff324eaf),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) =>
                              SearchScreen(courseList: allCourses), // dari DB
                    ),
                  );
                },
              ),
              ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                leading: const Icon(
                  Icons.badge,
                  color: Color(0xff696969),
                  size: 16,
                ),
                title: Text(
                  AppLocalizations.of(context).contactSupport,
                  style: GoogleFonts.poppins(
                    color: const Color(0xff324eaf),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ReviewSliderScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 40),
              Text(
                AppLocalizations.of(context).moreOptions,
                style: GoogleFonts.poppins(
                  color: const Color(0xFF7A8EDA),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.logout, color: Colors.red, size: 16),
                title: Text(
                  AppLocalizations.of(context).signOut,
                  style: GoogleFonts.poppins(
                    color: Colors.red,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onTap: () => signOutDialog(context),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: isDarkMode ? Colors.black : const Color(0xff324eaf),
        leading: Builder(
          builder:
              (context) => Tooltip(
                message: AppLocalizations.of(context).menu,
                child: IconButton(
                  icon: const Icon(Icons.menu, color: Colors.white),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
              ),
        ),
        actions: [
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
          const SizedBox(width: 8),
          Consumer<ProfileImageProvider>(
            builder: (context, profileImageProvider, _) {
              final imageFile = profileImageProvider.image;
              return Tooltip(
                message: AppLocalizations.of(context).profile,
                child: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Profile(),
                        ),
                      );
                    },
                    child: CircleAvatar(
                      radius: 18,
                      backgroundImage:
                          imageFile != null
                              ? FileImage(imageFile)
                              : const AssetImage(
                                    "assets/images/default_profile.png",
                                  )
                                  as ImageProvider,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),

      bottomNavigationBar: CustomBottomNav(
        currentIndex: 0,
        onTap: (index) {
          switch (index) {
            case 0:
              break;
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MyCoursePage()),
              );
              break;
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const NotificationPage()),
              );
              break;
            case 3:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const Profile()),
              );
              break;
          }
        },
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child:
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView(
                    children: [
                      const SizedBox(height: 10),
                      Text(
                        AppLocalizations.of(context).learnPrompt,
                        style: GoogleFonts.poppins(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color:
                              theme.brightness == Brightness.dark
                                  ? Colors.white
                                  : const Color(0xff324eaf),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const SearchBarWidget(),
                      const SizedBox(height: 20),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          'assets/motivation_banner.png',
                          height: 204,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Banner ad (test id)
                      BannerAdWidget(adUnitId: AdService.bannerUnitId),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () async {
                          final ok = await AdService.instance.showRewarded(
                            onEarned: (r) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Reward: ${r.amount} ${r.type}',
                                  ),
                                ),
                              );
                            },
                          );
                          if (!ok)
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('No ad available')),
                            );
                        },
                        child: const Text('Watch ad for reward'),
                      ),
                      const SizedBox(height: 20),
                      const SizedBox(height: 20),

                      _buildSectionHeader(
                        AppLocalizations.of(context).trendingNow,
                      ),
                      const SizedBox(height: 12),
                      autoSlideCourseBanner(courses: trendingLocal),

                      const SizedBox(height: 30),

                      if (widget.selectedCategory.isNotEmpty) ...[
                        _buildSectionHeader(
                          AppLocalizations.of(context).recommendedForYou,
                        ),
                        const SizedBox(height: 12),
                        _buildCourseCardList(trendingLocal),
                      ],

                      const SizedBox(height: 30),

                      if (widget.selectedCategory.isNotEmpty &&
                          recommended.isNotEmpty) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RichText(
                              text: TextSpan(
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: theme.textTheme.bodyLarge?.color,
                                ),
                                children: [
                                  TextSpan(
                                    text:
                                        AppLocalizations.of(
                                          context,
                                        ).popularForPrefix,
                                    style: TextStyle(
                                      color:
                                          theme.brightness == Brightness.dark
                                              ? Colors.white
                                              : const Color(0xff324eaf),
                                    ),
                                  ),
                                  TextSpan(
                                    text: widget.selectedCategory,
                                    style: GoogleFonts.poppins(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => Scaffold(
                                          body: Center(
                                            child: Text(
                                              AppLocalizations.of(
                                                context,
                                              ).comingSoon,
                                            ),
                                          ),
                                        ),
                                  ),
                                );
                              },
                              child: Text(
                                AppLocalizations.of(context).seeAll,
                                style: GoogleFonts.poppins(
                                  color: Colors.green,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _buildCourseCardList(recommendedLocal),
                      ],

                      const SizedBox(height: 20),

                      _buildSectionHeader(
                        AppLocalizations.of(context).categories,
                      ),
                      const SizedBox(height: 12),
                      CategoryChips(
                        categoryList: categoryList,
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

                      _buildCourseCardList(filteredCourses),
                    ],
                  ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color:
                Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : const Color(0xff324eaf),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ComingSoon()),
            );
          },
          child: Text(
            AppLocalizations.of(context).seeAll,
            style: GoogleFonts.poppins(
              color: Colors.green,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCourseCardList(List<Course> courses) {
    return SizedBox(
      height: 250,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: courses.length,
        separatorBuilder: (context, index) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final course = courses[index];
          return _buildCourseCard(
            imageUrl: course.images,
            title: course.title,
            duration: course.duration,
            rating: course.rating,
            instructor: course.instructor,
            price: course.price,
            isBestseller: course.isBestseller,
            index: course.index,
          );
        },
      ),
    );
  }

  Widget _buildCourseCard({
    required String imageUrl,
    required String title,
    required String duration,
    required String instructor,
    required String rating,
    required String price,
    required int index,
    bool isBestseller = false,
  }) {
    final isFavorited = favoriteCourses.contains(index);
    final allCourses = all;

    return GestureDetector(
      onTap: () async {
        // Log that the course card was opened from Explore
        await FirebaseAnalyticsService().trackCourseAction(
          'open',
          index.toString(),
          price: double.tryParse(price.replaceAll('\$', '')),
        );

        // Load full course data from app database before navigating
        final courseFromDb = await DatabaseCourse.getCourseByIdForApp(index);
        if (courseFromDb != null) {
          // show an interstitial (if loaded) for monetization
          await AdService.instance.showInterstitial();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (_) => CourseDetailScreen(
                    title: courseFromDb.title,
                    imageUrl: courseFromDb.images,
                    price: courseFromDb.price,
                    rating: courseFromDb.rating,
                    duration: courseFromDb.duration,
                    isBestseller: courseFromDb.isBestseller,
                    instructor: courseFromDb.instructor,
                    recommendedCourses: [...recommended],
                  ),
            ),
          );
        } else {
          // Fallback to using the provided data if DB lookup fails
          await AdService.instance.showInterstitial();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (_) => CourseDetailScreen(
                    title: title,
                    imageUrl: imageUrl,
                    price: price,
                    rating: rating,
                    duration: duration,
                    isBestseller: isBestseller,
                    instructor: instructor,
                    recommendedCourses: [...recommended],
                  ),
            ),
          );
        }
      },
      child: Card(
        child: Container(
          width: 151,
          decoration: BoxDecoration(
            color: const Color(0xFF324EAF),
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
          ),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(10),
                ),
                child: Image.asset(
                  imageUrl,
                  height: 100,
                  width: 151,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                bottom: 60,
                left: 8,
                right: 8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w300,
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(
                          Icons.schedule,
                          size: 10,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          duration,
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(Icons.star, size: 10, color: Colors.yellow),
                        const SizedBox(width: 4),
                        Text(
                          rating,
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 30,
                right: 8,
                child: InkWell(
                  onTap: () async {
                    // Use DB-backed cart: get or create a demo user, then upsert/remove
                    final userId =
                        await DatabaseUser.getOrCreateDemoUserIdForApp();
                    setState(() {
                      if (isFavorited) {
                        favoriteCourses.remove(index);
                      } else {
                        favoriteCourses.add(index);
                      }
                    });

                    if (favoriteCourses.contains(index)) {
                      // add to cart in DB (best-effort)
                      final course = allCourses.firstWhere(
                        (c) => c.index == index,
                        orElse: () => allCourses.first,
                      );
                      await DatabaseCart.upsertCourseForUser(userId, course);
                    } else {
                      // remove from cart in DB
                      await DatabaseCart.removeByUserCourseForUser(
                        userId,
                        index,
                      );
                    }
                  },
                  child: Tooltip(
                    message:
                        isFavorited
                            ? AppLocalizations.of(context).remove
                            : AppLocalizations.of(context).add,
                    child: Icon(
                      isFavorited
                          ? Icons.shopping_cart
                          : Icons.shopping_cart_outlined,
                      color: isFavorited ? Colors.green : Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 5,
                child: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(10),
                    ),
                    color: Color(0xFF324EAF),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (isBestseller)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 4,
                          ),
                          decoration: const BoxDecoration(
                            color: Colors.yellow,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            ),
                          ),
                          child: Text(
                            AppLocalizations.of(context).bestseller,
                            style: GoogleFonts.poppins(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF324EAF),
                            ),
                          ),
                        )
                      else
                        const SizedBox(),
                      Text(
                        price,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _checkForNewCourses(List<Course> courses) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final lastCourseCount = prefs.getInt('last_course_count') ?? 0;
      final currentCourseCount = courses.length;

      if (currentCourseCount > lastCourseCount && lastCourseCount > 0) {
        // New courses available
        final newCoursesCount = currentCourseCount - lastCourseCount;
        await AwesomeNotificationService.showUpdateNotification(
          'New Courses Available!',
          'Check out $newCoursesCount new courses added to our collection.',
        );
      }

      // Update stored count
      await prefs.setInt('last_course_count', currentCourseCount);
    } catch (e) {
      print('Error checking for new courses: $e');
    }
  }
}
