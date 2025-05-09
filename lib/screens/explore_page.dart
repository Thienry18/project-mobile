import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projek_mobile/data/cart_data.dart';
import 'package:projek_mobile/data/category.dart';
import 'package:projek_mobile/data/explore_data.dart';
import 'package:projek_mobile/data/interest_data.dart';
import 'package:projek_mobile/models/explore_model.dart';
import 'package:projek_mobile/screens/coming_soon.dart';
import 'package:projek_mobile/screens/my_course_page.dart';
import 'package:projek_mobile/screens/notification_page.dart';
import 'package:projek_mobile/screens/profile.dart';
import 'package:projek_mobile/widgets/category_chips.dart';
import 'package:projek_mobile/widgets/custom_bottom_nav.dart';
import 'package:projek_mobile/widgets/icon_circle_button.dart';
import 'package:projek_mobile/widgets/slide_animation.dart';
import 'package:projek_mobile/widgets/search_bar.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key, required this.selectedCategory});
  final String selectedCategory;

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  Set<int> favoriteCourses = {};
  Set<int> selectedIndexes = {0};

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    List<Course> filteredCourses =
        selectedIndexes.isNotEmpty
            ? trendingCourses
                .where(
                  (course) => selectedIndexes.contains(
                    categoryList.indexOf(course.category),
                  ),
                )
                .toList()
            : trendingCourses;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: theme.scaffoldBackgroundColor,
        title: Row(
          children: [
            const CircleAvatar(
              radius: 22,
              backgroundImage: NetworkImage('https://i.pravatar.cc/100?img=3'),
            ),
            const SizedBox(width: 10),
            Text(
              "Hi, Moon!",
              style: GoogleFonts.poppins(
                fontSize: 15,
                color:
                    Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : const Color(0xff324eaf),
              ),
            ),
          ],
        ),
        actions: [
          IconCircleButton(
            icon: Icons.diamond,
            iconColor: Colors.blue, 
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ComingSoon()),
              );
            },
          ),

          const SizedBox(width: 10),
          IconCircleButton(
            icon: Icons.event_available,
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ComingSoon()),
              );
            },
          ),
          const SizedBox(width: 10),
          IconCircleButton(
            icon: Icons.shopping_cart_outlined,
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ComingSoon()),
              );
            },
          ),
          const SizedBox(width: 10),
        ],
      ),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: 0,
        onTap: (index) {
          switch (index) {
            case 0:
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
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => Profile()),
              );
              break;
          }
        },
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ListView(
            children: [
              const SizedBox(height: 10),
              Text(
                "What would you want\nto learn today?",
                style: GoogleFonts.poppins(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color:
                      Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : const Color(0xff324eaf),
                ),
              ),
              const SizedBox(height: 20),
              SearchBarWidget(),
              const SizedBox(height: 40),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  'assets/motivation_banner.png',
                  height: 204,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 30),
              _buildSectionHeader("Trending Now"),
              const SizedBox(height: 12),
              autoSlideCourseBanner(courses: getTrendingTop5()),
              const SizedBox(height: 30),

              if (widget.selectedCategory.isNotEmpty) ...[
                _buildSectionHeader("Recommended for You"),
                const SizedBox(height: 12),
                _buildCourseCardList(getTrendingTop5()),
              ],
              const SizedBox(height: 30),

              if (widget.selectedCategory.isNotEmpty &&
                  getRecommendedForYou(categoryselected).isNotEmpty) ...[
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
                            text: "Popular for ",
                            style: TextStyle(
                              color:
                                  Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.white
                                      : const Color(0xff324eaf),
                            ),
                          ),
                          TextSpan(
                            text: categoryselected,
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
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => const Scaffold(
                                  body: Center(child: Text("Coming Soon")),
                                ),
                          ),
                        );
                      },
                      child: Text(
                        "See All",
                        style: GoogleFonts.poppins(
                          color: Colors.green,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildCourseCardList(getRecommendedForYou(categoryselected)),
              ],

              const SizedBox(height: 20),
              _buildSectionHeader("Categories"),
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
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => ComingSoon()),
            );
          },
          child: Text(
            "See All",
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
    required String rating,
    required String price,
    required int index,
    bool isBestseller = false,
  }) {
    final isFavorited = favoriteCourses.contains(index);
    return Container(
      width: 151,
      decoration: BoxDecoration(
        color: const Color(0xFF324EAF),
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
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
                    const Icon(Icons.schedule, size: 10, color: Colors.white),
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
              onTap: () {
                setState(() {
                  if (isFavorited) {
                    favoriteCourses.remove(index);
                    cartCourses.removeWhere((course) => course.index == index);
                  } else {
                    favoriteCourses.add(index);
                    final course = trendingCourses.firstWhere(
                      (c) => c.index == index,
                    );
                    cartCourses.add(course);
                  }
                });
              },
              child: Icon(
                isFavorited
                    ? Icons.shopping_cart
                    : Icons.shopping_cart_outlined,
                color: isFavorited ? Colors.green : Colors.white,
                size: 20,
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
                      decoration: BoxDecoration(
                        color: Colors.yellow,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                      ),
                      child: Text(
                        'Bestseller',
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF324EAF),
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
    );
  }
}
