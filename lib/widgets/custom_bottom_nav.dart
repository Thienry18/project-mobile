import 'package:flutter/material.dart';
import 'package:projek_mobile/providers/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:projek_mobile/l10n/app_localizations.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNav({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeNotifier>(context).isDarkMode;
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      currentIndex: currentIndex,
      selectedItemColor: const Color(0xFF324EAF),
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      onTap: onTap,
      items: [
        BottomNavigationBarItem(
          icon: const Icon(Icons.explore),
          label: AppLocalizations.of(context).explore,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.menu_book),
          label: AppLocalizations.of(context).myCourses,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.notifications_none),
          label: AppLocalizations.of(context).notification,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.person_outline),
          label: AppLocalizations.of(context).profile,
        ),
      ],
    );
  }
}
