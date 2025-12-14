import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projek_mobile/data/explore_data.dart';
import 'package:projek_mobile/screens/search_screen.dart';
import 'package:projek_mobile/l10n/app_localizations.dart';
import 'package:projek_mobile/widgets/filter_menu_button.dart';

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Add a harmless StreamBuilder that emits a small int periodically.
    // The value is only used to slightly change opacity and does not affect navigation.
    return StreamBuilder<int>(
      stream:
          Stream.periodic(
            const Duration(seconds: 5),
            (i) => i,
          ).asBroadcastStream(),
      builder: (context, streamSnap) {
        final tick = streamSnap.data ?? 0;
        final opacity = 0.95 + (tick % 2) * 0.05;

        return Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) =>
                              SearchScreen(courseList: trendingCourses),
                    ),
                  );
                },
                child: Opacity(
                  opacity: opacity.clamp(0.0, 1.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE3E8FB),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            AppLocalizations.of(context).searchForACourse,
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        const Icon(Icons.search, color: Colors.grey),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            const FilterMenuButton(),
          ],
        );
      },
    );
  }
}
