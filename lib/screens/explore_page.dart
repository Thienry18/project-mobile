import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projek_mobile/widgets/slide_animation.dart';

class ExplorePage extends StatefulWidget {
  ExplorePage({super.key, required this.selectedCategory});

  final String selectedCategory;

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  Set<int> favoriteCourses = {};
  final List<String> categoryList = [
    'Python',
    'Java',
    'JavaScript',
    'C++',
    'C',
    'C#',
    'PHP',
    'Swift',
    'Kotlin',
    'Dart',
    'TypeScript',
    'Go',
    'SQL',
    'HTML',
    'CSS',
    'Scala',
    'R',
    'React.js',
    'Next.js',
    'Vue.js',
    'Express.js',
    'Angular',
    'Django',
    'Flask',
    'Laravel',
  ];

  int? selectedCategoryIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
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
                color: Color(0xFF324EAF),
              ),
            ),
          ],
        ),
        actions: [
          _inkCircleButton(Icons.event_available, () {}),
          const SizedBox(width: 10),
          _inkCircleButton(Icons.shopping_cart_outlined, () {}),
          const SizedBox(width: 10),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: const Color(0xFF324EAF),
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        currentIndex: 0,
        selectedLabelStyle: GoogleFonts.poppins(fontSize: 10),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: 'My Course',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
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
                  color: const Color(0xFF324EAF),
                ),
              ),
              const SizedBox(height: 20),
              _buildSearchBar(),
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

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Trending Now",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF324EAF),
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
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
              autoSlideImage(
                images: [
                  'assets/AI_guide.jpeg',
                  'assets/mobiledev.png',
                  'assets/emergintech.png',
                ],
                height: 188,
                borderRadius: 12,
              ),

              const SizedBox(height: 30),

              if (widget.selectedCategory.isNotEmpty) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Recommended for You",
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF324EAF),
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
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
                SizedBox(
                  height: 250,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _buildCourseCard(
                        imageUrl:
                            'https://img-c.udemycdn.com/course/240x135/2776760_f176_10.jpg',
                        title:
                            '100 Days of Code: The Complete Python Pro Bootcamp',
                        duration: '55h 21m',
                        rating: '4.7 (365,859)',
                        price: '\$38.69',
                        isBestseller: true,
                        index: 10,
                      ),
                      const SizedBox(width: 16),
                      _buildCourseCard(
                        imageUrl:
                            'https://images.unsplash.com/photo-1581090700227-1e8d1a5640f4',
                        title:
                            'Machine Learning A-Z: AI, Python & R + ChatGPT Prize [2025]',
                        duration: '42h 44m',
                        rating: '4.5 (196,112)',
                        price: '\$36.29',
                        isBestseller: true,
                        index: 11,
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 30),

              if (widget.selectedCategory.isNotEmpty) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF324EAF),
                        ),
                        children: [
                          TextSpan(
                            text: "Popular for ",
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF324EAF),
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
                      onPressed: () {},
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
                SizedBox(
                  height: 250,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _buildCourseCard(
                        imageUrl:
                            'https://img-c.udemycdn.com/course/240x135/1565838_e2c9_10.jpg',
                        title: 'AI for Beginners: Learn the Basics of AI',
                        duration: '20h 10m',
                        rating: '4.6 (102,232)',
                        price: '\$29.99',
                        index: 8,
                      ),
                      const SizedBox(width: 16),
                      _buildCourseCard(
                        imageUrl:
                            'https://images.unsplash.com/photo-1581090700227-1e8d1a5640f4',
                        title: 'Deep Learning with Python: Build AI Models',
                        duration: '35h 22m',
                        rating: '4.8 (56,324)',
                        price: '\$48.99',
                        index: 9,
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Categories",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF324EAF),
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
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
              _buildCategoryChips(),
              const SizedBox(height: 16),
              _buildCourseCardList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _inkCircleButton(IconData icon, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(),
      child: Ink(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(100),
          splashColor: Colors.white,
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Icon(icon, color: Colors.grey, size: 20),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search for a course',
              hintStyle: GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
              suffixIcon: const Icon(Icons.search, color: Colors.grey),
              filled: true,
              fillColor: const Color(0xFFE3E8FB),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 0,
                horizontal: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF324EAF),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.tune, color: Colors.white, size: 20),
        ),
      ],
    );
  }

  Widget _buildCategoryChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(categoryList.length, (index) {
          final isSelected = selectedCategoryIndex == index;
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedCategoryIndex = isSelected ? null : index;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color:
                      isSelected
                          ? const Color(0xFF324EAF)
                          : const Color(0xFFEFEFEF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  categoryList[index],
                  style: GoogleFonts.poppins(
                    color: isSelected ? Colors.white : Colors.grey,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildCourseCardList() {
    return SizedBox(
      height: 250,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildCourseCard(
            imageUrl:
                'https://img-c.udemycdn.com/course/240x135/2776760_f176_10.jpg',
            title: '100 Days of Code: The Complete Python Pro Bootcamp',
            duration: '55h 21m',
            rating: '4.7 (365,859)',
            price: '\$38.69',
            isBestseller: true,
            index: 1,
          ),
          const SizedBox(width: 16),
          _buildCourseCard(
            imageUrl:
                'https://images.unsplash.com/photo-1581090700227-1e8d1a5640f4',
            title:
                'Machine Learning A-Z: AI, Python & R + ChatGPT Prize [2025]',
            duration: '42h 44m',
            rating: '4.5 (196,112)',
            price: '\$36.29',
            isBestseller: true,
            index: 2,
          ),
          const SizedBox(width: 16),
          _buildCourseCard(
            imageUrl:
                'https://img-c.udemycdn.com/course/240x135/394676_ce3d_5.jpg',
            title: 'The Web Developer Bootcamp 2024',
            duration: '63h 0m',
            rating: '4.7 (200,000)',
            price: '\$29.99',
            index: 3,
          ),
          const SizedBox(width: 16),
          _buildCourseCard(
            imageUrl:
                'https://img-c.udemycdn.com/course/240x135/567828_67d0.jpg',
            title: 'iOS & Swift - The Complete iOS App Development Bootcamp',
            duration: '60h 30m',
            rating: '4.8 (150,000)',
            price: '\$39.99',
            index: 4,
          ),
          const SizedBox(width: 16),
          _buildCourseCard(
            imageUrl:
                'https://img-c.udemycdn.com/course/240x135/1561458_7f3f_16.jpg',
            title: 'The Complete JavaScript Course 2024: From Zero to Expert!',
            duration: '68h 12m',
            rating: '4.7 (210,300)',
            price: '\$35.00',
            isBestseller: true,
            index: 5,
          ),
          const SizedBox(width: 16),
          _buildCourseCard(
            imageUrl:
                'https://img-c.udemycdn.com/course/240x135/437398_46c3_9.jpg',
            title: 'The Complete Node.js Developer Course (3rd Edition)',
            duration: '35h 45m',
            rating: '4.6 (180,000)',
            price: '\$32.50',
            index: 6,
          ),
          const SizedBox(width: 16),
          _buildCourseCard(
            imageUrl:
                'https://img-c.udemycdn.com/course/240x135/851712_fc61_6.jpg',
            title: 'Docker and Kubernetes: The Complete Guide',
            duration: '22h 15m',
            rating: '4.8 (120,000)',
            price: '\$42.00',
            index: 7,
          ),
        ],
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
            child: Image.network(
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
                  } else {
                    favoriteCourses.add(index);
                  }
                });
              },
              child: Icon(
                isFavorited ? Icons.favorite : Icons.favorite_border,
                color: isFavorited ? Colors.red : Colors.white,
                size: 20,
              ),
            ),
          ),

          Positioned(
            bottom: 0,
            left: 0,
            right: 5,
            child: Container(
              padding: const EdgeInsets.symmetric(),
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
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                      ),
                      child: Text(
                        'Bestseller',
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
    );
  }
}
