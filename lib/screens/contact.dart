import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projek_mobile/l10n/app_localizations.dart';

class ReviewSliderScreen extends StatefulWidget {
  const ReviewSliderScreen({super.key});

  @override
  State<ReviewSliderScreen> createState() => _ReviewSliderScreenState();
}

class _ReviewSliderScreenState extends State<ReviewSliderScreen> {
  final PageController _pageController = PageController(
    initialPage: 1,
    viewportFraction: 0.5,
  );

  int _currentPage = 1;

  final List<Map<String, String>> users = [
    {
      'name': 'Andrian Cheniago',
      'image': 'assets/profile/Andrian.jpg',
      'phone': '+62 818 0787 1201',
      'email': 'andrian.cheniago@students.mikroskil.ac.id',
    },
    {
      'name': 'Delvin Ayers',
      'image': 'assets/profile/delvin.jpg',
      'phone': '+62 812 2777 5235',
      'email': 'delvin.ayers@students.mikroskil.ac.id',
    },
    {
      'name': 'Thienry',
      'image': 'assets/profile/thienry.jpg',
      'phone': '+62 821 6321 1128',
      'email': 'Thienry@students.mikroskil.ac.id',
    },
  ];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _pageController.jumpToPage(_currentPage);
      });
    });

    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!.round();
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  double _calculateScale(int index) {
    final diff = (_pageController.page ?? _currentPage) - index;
    return 1.0 - (diff.abs() * 0.3).clamp(0.0, 0.3);
  }

  double _calculateRadius(double scale) {
    return 90 * scale;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF324EAF),
        title: Text(
          AppLocalizations.of(context).reviewSlider,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: SizedBox(
          height: 440,
          child: PageView.builder(
            controller: _pageController,
            itemCount: users.length,
            itemBuilder: (context, index) {
              final scale = _calculateScale(index);
              final user = users[index];
              final avatarRadius = _calculateRadius(scale);

              return Transform.scale(
                scale: scale,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: avatarRadius,
                      backgroundImage: AssetImage(user['image']!),
                    ),
                    const SizedBox(height: 16),
                    Opacity(
                      opacity: index == _currentPage ? 1.0 : 0.4,
                      child: Column(
                        children: [
                          Text(
                            user['name']!,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            user['phone']!,
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            user['email']!,
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.grey,
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
      ),
    );
  }
}
