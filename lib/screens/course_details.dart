import 'package:flutter/material.dart';
import 'package:projek_mobile/constants/app_text_style.dart';
import 'package:projek_mobile/data/cart_data.dart';
import 'package:projek_mobile/models/explore_model.dart';

class CourseDetailScreen extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String price;
  final String rating;
  final String duration;
  final bool isBestseller;
  final List<Course> recommendedCourses;

  const CourseDetailScreen({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.price,
    required this.rating,
    required this.duration,
    required this.isBestseller,
    required this.recommendedCourses,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        actions: [
          IconButton(icon: const Icon(Icons.favorite_border), onPressed: () {}),
          IconButton(icon: const Icon(Icons.share), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
            const SizedBox(height: 16),

            Text(title, style: AppTextStyles.heading.copyWith(fontSize: 20)),
            const SizedBox(height: 8),

            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isBestseller)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.yellow,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'Bestseller',
                      style: AppTextStyles.subheading.copyWith(
                        color: Colors.orange,
                      ),
                    ),
                  ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      rating,
                      style: AppTextStyles.body.copyWith(color: Colors.grey),
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
                const SizedBox(height: 8),
                _InfoIconText(
                  icon: Icons.schedule,
                  text: duration,
                  textStyle: AppTextStyles.body,
                ),
                const SizedBox(height: 8),
                _InfoIconText(
                  icon: Icons.language,
                  text: 'English',
                  textStyle: AppTextStyles.body,
                ),
                const SizedBox(height: 8),
                _InfoIconText(
                  icon: Icons.subtitles,
                  text: 'Available Subtitle: Indonesian',
                  textStyle: AppTextStyles.body,
                ),
                const SizedBox(height: 8),
              ],
            ),
            const SizedBox(height: 24),

            Text(
              'About Course',
              style: AppTextStyles.heading.copyWith(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
              style: AppTextStyles.body,
            ),

            const SizedBox(height: 24),
            Text(
              'What Skill You\'ll gain',
              style: AppTextStyles.heading.copyWith(fontSize: 16),
            ),
            const SizedBox(height: 8),
            bulletText(
              'Build interactive models using Computer Vision, Convolutional Neural Networks and Natural Language Processing',
            ),
            bulletText('Design secure & scalable cloud applications and APIs'),
            bulletText(
              'Increase your skills in cloud computing, AI/ML, and integration',
            ),
            bulletText(
              'Understand how to integrate machine learning into tools and operations',
            ),

            const SizedBox(height: 24),

            Text(
              'Syllabus',
              style: AppTextStyles.heading.copyWith(fontSize: 16),
            ),
            const SizedBox(height: 8),
            ExpansionTile(
              title: Text(
                'Module 1 - Introduction',
                style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w500),
              ),
              children: [
                ListTile(
                  title: Text(
                    '• Welcome to the course',
                    style: AppTextStyles.body,
                  ),
                ),
                ListTile(
                  title: Text('• AWS overview', style: AppTextStyles.body),
                ),
              ],
            ),

            const SizedBox(height: 24),
            recommendedCourses.isNotEmpty
                ? Text(
                  'You May Like These Courses',
                  style: AppTextStyles.heading.copyWith(fontSize: 16),
                )
                : SizedBox(),
            const SizedBox(height: 8),

            recommendedCourses.isNotEmpty
                ? SizedBox(
                  height: 230,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: recommendedCourses.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final course = recommendedCourses[index];
                      return Container(
                        width: 160,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade300),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12),
                              ),
                              child: Image.network(
                                course.images,
                                height: 100,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (course.isBestseller)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.yellow[100],
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        'Bestseller',
                                        style: AppTextStyles.subheading
                                            .copyWith(color: Colors.orange),
                                      ),
                                    ),
                                  const SizedBox(height: 4),
                                  Text(
                                    course.title,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTextStyles.body.copyWith(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '${course.price}',
                                    style: AppTextStyles.heading.copyWith(
                                      fontSize: 14,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                )
                : SizedBox(),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey.shade300)),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: Row(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Price',
                  style: AppTextStyles.subheading.copyWith(fontSize: 12),
                ),
                Text(
                  '$price',
                  style: AppTextStyles.heading.copyWith(
                    fontSize: 24,
                    color: const Color(0xff324eaf),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16),

            Container(height: 40, width: 1, color: Colors.grey.shade300),
            const SizedBox(width: 16),

            SizedBox(
              height: 42,
              width: 50,
              child: OutlinedButton(
                onPressed: () {
                  final course = Course(
                    title: title,
                    images: imageUrl,
                    price: price,
                    rating: rating,
                    duration: duration,
                    isBestseller: isBestseller,
                    index: DateTime.now().millisecondsSinceEpoch,
                    category: '',
                  );

                  if (!cartCourses.any((c) => c.title == course.title)) {
                    cartCourses.add(course);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Added to cart'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Already in cart'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.green),
                  foregroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.zero,
                ),
                child: const Icon(Icons.shopping_cart_outlined, size: 24),
              ),
            ),

            const SizedBox(width: 8),

            Expanded(
              child: SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff32CD32),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                    foregroundColor: Colors.white,
                  ),
                  child: Text('Buy Course', style: AppTextStyles.button),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget bulletText(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Text(
            '• ',
            style: AppTextStyles.body.copyWith(
              fontSize: 18,
              color: Colors.black87,
            ),
          ),
          Expanded(child: Text(text, style: AppTextStyles.body)),
        ],
      ),
    );
  }
}

class _InfoIconText extends StatelessWidget {
  final IconData icon;
  final String text;
  final TextStyle textStyle;

  const _InfoIconText({
    required this.icon,
    required this.text,
    required this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: Colors.grey[700]),
        const SizedBox(width: 4),
        Text(text, style: textStyle),
      ],
    );
  }
}
