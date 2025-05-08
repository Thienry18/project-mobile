import 'package:flutter/material.dart';

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
    return BottomNavigationBar(
      currentIndex: currentIndex,
      selectedItemColor: const Color(0xFF324EAF),
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      onTap: onTap,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
        BottomNavigationBarItem(
          icon: Icon(Icons.menu_book),
          label: 'My Course',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications_none),
          label: 'Notifications',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: 'Profile',
        ),
      ],
    );
  }
}
