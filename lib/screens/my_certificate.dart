import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projek_mobile/data/category.dart';
import 'package:projek_mobile/data/my_course_data.dart';
import 'package:projek_mobile/providers/theme_provider.dart';
import 'package:projek_mobile/screens/certificate.dart';
import 'package:projek_mobile/screens/explore_page.dart';
import 'package:projek_mobile/widgets/category_chips.dart';
import 'package:provider/provider.dart';
import 'package:projek_mobile/l10n/app_localizations.dart';

class CertificatePage extends StatefulWidget {
  const CertificatePage({super.key});

  @override
  State<CertificatePage> createState() => _CertificatePageState();
}

class _CertificatePageState extends State<CertificatePage> {
  late final List<String> fullCategoryList;
  final Set<int> selectedIndexes = {0};

  @override
  void initState() {
    super.initState();
    fullCategoryList = ['All', ...categoryList];
  }

  void onCategoryToggle(int index) {
    setState(() {
      selectedIndexes.clear();
      selectedIndexes.add(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredCourses =
        selectedIndexes.contains(0)
            ? myCourses
            : myCourses.where((course) {
              final selectedCategories =
                  selectedIndexes.map((i) => categoryList[i - 1]).toList();
              return selectedCategories.contains(course.category);
            }).toList();

    final isDarkMode = Provider.of<ThemeNotifier>(context).isDarkMode;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: isDarkMode ? Colors.black : const Color(0xFF324EAF),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          AppLocalizations.of(context).myCertificates,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        child: Column(
          children: [
            CategoryChips(
              categoryList: fullCategoryList,
              selectedIndexes: selectedIndexes,
              onCategoryToggle: onCategoryToggle,
            ),
            const SizedBox(height: 16),
            Expanded(
              child:
                  filteredCourses.isEmpty
                      ? _buildEmptyState()
                      : GridView.builder(
                        padding: const EdgeInsets.only(bottom: 16),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio: 0.7, // Perbaikan overflow
                            ),
                        itemCount: filteredCourses.length,
                        itemBuilder: (context, index) {
                          final course = filteredCourses[index];
                          return _buildCertificateCard(course);
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCertificateCard(course) {
    return GestureDetector(
      onTap: () {
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
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 2,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(10),
                ),
                child: Image.asset(
                  course.images,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8.0),
              color: const Color(0xFF324EAF),
              child: Text(
                course.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Column(
      children: [
        Image.asset('images/certification.png', height: 300),
        const SizedBox(height: 20),
        Text(
          AppLocalizations.of(context).noCertificates,
          style: GoogleFonts.poppins(
            color: const Color(0xFF324EAF),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          AppLocalizations.of(context).discoverCourses,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            color: const Color(0xFF324EAF),
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 30),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const ExplorePage(selectedCategory: ''),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppLocalizations.of(context).explore,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.arrow_right_alt, color: Colors.white),
            ],
          ),
        ),
      ],
    );
  }
}
