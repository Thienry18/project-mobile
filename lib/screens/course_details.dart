import 'dart:math';
import 'package:flutter/material.dart';
import 'package:projek_mobile/firebase/firebase_analytics_service.dart';
import 'package:projek_mobile/constants/app_text_style.dart';
import 'package:projek_mobile/data/cart_data.dart';
import 'package:projek_mobile/database/database_cart.dart';
import 'package:projek_mobile/database/database_user.dart';
import 'package:projek_mobile/models/explore_model.dart';
import 'package:projek_mobile/providers/theme_provider.dart';
import 'package:projek_mobile/screens/cart.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:projek_mobile/l10n/app_localizations.dart';
import 'package:projek_mobile/services/ad_service.dart';
import 'package:projek_mobile/widgets/banner_ad_widget.dart';

class CourseDetailScreen extends StatefulWidget {
  final String title;
  final String imageUrl;
  final String price;
  final String rating;
  final String duration;
  final bool isBestseller;
  final String instructor;
  final List<Course> recommendedCourses;

  const CourseDetailScreen({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.price,
    required this.rating,
    required this.duration,
    required this.isBestseller,
    required this.instructor,
    required this.recommendedCourses,
  });

  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _logCourseView();
  }

  Future<void> _logCourseView() async {
    await FirebaseAnalyticsService().logCartOperation(
      operation: 'view',
      courseId: widget.title.hashCode.toString(),
      title: widget.title,
      price: double.tryParse(widget.price.replaceAll('\$', '')) ?? 0.0,
    );
  }

  void showShareOptions(BuildContext context, String courseTitle) async {
    final random = Random();
    final code = String.fromCharCodes(
      List.generate(6, (index) => random.nextInt(26) + 97),
    );
    final fakeUrl = 'https://courses.com/$code';

    await FirebaseAnalyticsService().logCartOperation(
      operation: 'share',
      courseId: widget.title.hashCode.toString(),
      title: courseTitle,
      price: double.tryParse(widget.price.replaceAll('\$', '')) ?? 0.0,
    );

    Share.share(
      'Check out this course: $courseTitle\n$fakeUrl',
      subject: 'Share Course',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        actions: [
          Tooltip(
            message: isFavorite ? 'Remove from Favorites' : 'Add to Favorites',
            child: IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.red : null,
              ),
              onPressed: () async {
                final action = isFavorite ? 'remove_favorite' : 'add_favorite';
                await FirebaseAnalyticsService().logCartOperation(
                  operation: action,
                  courseId: widget.title.hashCode.toString(),
                  title: widget.title,
                  price:
                      double.tryParse(widget.price.replaceAll('\$', '')) ?? 0.0,
                );
                setState(() {
                  isFavorite = !isFavorite;
                });
              },
            ),
          ),
          Tooltip(
            message: 'Share',
            child: IconButton(
              icon: const Icon(Icons.share),
              onPressed: () => showShareOptions(context, widget.title),
            ),
          ),
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
                widget.imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
            const SizedBox(height: 12),
            BannerAdWidget(adUnitId: AdService.bannerUnitId),
            const SizedBox(height: 16),
            // Rewarded offer: let user watch to preview a module
            _buildWatchForPreview(context),
            const SizedBox(height: 8),
            Text(
              widget.title,
              style: AppTextStyles.heading.copyWith(fontSize: 20),
            ),
            const SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.isBestseller)
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
                      AppLocalizations.of(context).bestseller,
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
                      widget.rating,
                      style: AppTextStyles.body.copyWith(color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(widget.instructor, style: AppTextStyles.body),
                const SizedBox(height: 8),
                _InfoIconText(
                  icon: Icons.schedule,
                  text: widget.duration,
                  textStyle: AppTextStyles.body,
                ),
                const SizedBox(height: 8),
                _InfoIconText(
                  icon: Icons.language,
                  text: AppLocalizations.of(context).languageEnglish,
                  textStyle: AppTextStyles.body,
                ),
                const SizedBox(height: 8),
                _InfoIconText(
                  icon: Icons.subtitles,
                  text: AppLocalizations.of(
                    context,
                  ).availableSubtitle('Indonesian'),
                  textStyle: AppTextStyles.body,
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              AppLocalizations.of(context).aboutCourse,
              style: AppTextStyles.heading.copyWith(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit...',
              style: AppTextStyles.body,
            ),
            const SizedBox(height: 24),
            Text(
              AppLocalizations.of(context).whatSkillYouGain,
              style: AppTextStyles.heading.copyWith(fontSize: 16),
            ),
            const SizedBox(height: 8),
            bulletText('Build interactive models using CV, CNN, and NLP'),
            bulletText('Design secure & scalable cloud applications'),
            bulletText('Increase your skills in cloud computing & ML'),
            bulletText('Integrate machine learning into operations'),
            const SizedBox(height: 24),
            Text(
              AppLocalizations.of(context).syllabus,
              style: AppTextStyles.heading.copyWith(fontSize: 16),
            ),
            const SizedBox(height: 8),
            ExpansionTile(
              title: Text(
                AppLocalizations.of(context).moduleTitle(1),
                style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w500),
              ),
              children: [
                ListTile(
                  title: Text(
                    '• ${AppLocalizations.of(context).comingSoon}',
                    style: AppTextStyles.body,
                  ),
                ),
                ListTile(
                  title: Text(
                    '• ${AppLocalizations.of(context).comingSoon}',
                    style: AppTextStyles.body,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            if (widget.recommendedCourses.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context).youMayLikeTheseCourses,
                    style: AppTextStyles.heading.copyWith(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 230,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.recommendedCourses.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        final course = widget.recommendedCourses[index];
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
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
                                        ),
                                        child: Text(
                                          AppLocalizations.of(
                                            context,
                                          ).bestseller,
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
                                      course.price,
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
                  ),
                ],
              ),
          ],
        ),
      ),
      bottomNavigationBar: buildBottomBar(context),
    );
  }

  Widget buildBottomBar(BuildContext context) {
    final isDarkMode = Provider.of<ThemeNotifier>(context).isDarkMode;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey.shade900 : Colors.white,
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
                AppLocalizations.of(context).priceLabel,
                style: AppTextStyles.subheading.copyWith(fontSize: 12),
              ),
              Text(
                widget.price,
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
              onPressed: () async {
                final course = Course(
                  title: widget.title,
                  images: widget.imageUrl,
                  price: widget.price,
                  rating: widget.rating,
                  duration: widget.duration,
                  isBestseller: widget.isBestseller,
                  index: DateTime.now().millisecondsSinceEpoch,
                  category: '',
                  instructor: widget.instructor,
                  language: 'English',
                  subtitle: 'Indonesian',
                );

                try {
                  final userId =
                      await DatabaseUser.getOrCreateDemoUserIdForApp();
                  await DatabaseCart.upsertCourseForUser(userId, course);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(AppLocalizations.of(context).addedToCart),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                } catch (e) {
                  // fallback to in-memory and notify
                  if (!cartCourses.any((c) => c.title == course.title)) {
                    cartCourses.add(course);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          AppLocalizations.of(context).addedToCartOffline,
                        ),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          AppLocalizations.of(context).alreadyInCart,
                        ),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  }
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
                onPressed: () async {
                  // show interstitial if available
                  await AdService.instance.showInterstitial();
                  final course = Course(
                    title: widget.title,
                    images: widget.imageUrl,
                    price: widget.price,
                    rating: widget.rating,
                    duration: widget.duration,
                    isBestseller: widget.isBestseller,
                    index: DateTime.now().millisecondsSinceEpoch,
                    category: '',
                    instructor: widget.instructor,
                    language: 'English',
                    subtitle: 'Indonesian',
                  );

                  if (!cartCourses.any((c) => c.title == course.title)) {
                    cartCourses.add(course);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CartPage()),
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff32CD32),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                  foregroundColor: Colors.white,
                ),
                child: Text(
                  AppLocalizations.of(context).buyCourse,
                  style: AppTextStyles.button,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Add a small helper: Watch a rewarded ad to preview a module
  Widget _buildWatchForPreview(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ElevatedButton(
        onPressed: () async {
          final ok = await AdService.instance.showRewarded(
            onEarned: (reward) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Reward received: ${reward.amount} ${reward.type}',
                  ),
                ),
              );
            },
          );
          if (!ok) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('No ad available right now')),
            );
          }
        },
        child: const Text('Watch to preview a module (reward)'),
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
