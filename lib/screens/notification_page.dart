// Semua import kamu tetap seperti sebelumnya
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projek_mobile/constants/app_text_style.dart';
import 'package:projek_mobile/data/interest_data.dart';
import 'package:projek_mobile/screens/cart.dart';
import 'package:projek_mobile/screens/coming_soon.dart';
import 'package:projek_mobile/screens/explore_page.dart';
import 'package:projek_mobile/screens/my_course_page.dart';
import 'package:projek_mobile/screens/profile.dart';
import 'package:projek_mobile/widgets/custom_bottom_nav.dart';
import 'package:projek_mobile/widgets/icon_circle_button.dart';
import 'package:projek_mobile/providers/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool isDeleteMode = false;
  Set<int> selectedIndexes = {};
  List<Map<String, dynamic>> notifications = [
    {
      'title': 'Order Completed!',
      'message':
          'Thanks for your purchase! Your course is now available in My Course. Take your time, start whenever you’re ready, and enjoy every step of your learning journey.',
      'image': 'assets/images/notification.png',
      'date': '04-30-2025 2:43 A.M.',
      'unread': true,
    },
    {
      'title': 'Order Completed!',
      'message':
          'Thanks for your purchase! Your course is now available in My Course. Take your time, start whenever you’re ready, and enjoy every step of your learning journey.',
      'image': 'assets/images/notification.png',
      'date': '01-04-2025 8:58 A.M.',
      'unread': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('notifications');
    if (data != null) {
      setState(() {
        notifications = List<Map<String, dynamic>>.from(
          jsonDecode(data).map((e) => Map<String, dynamic>.from(e)),
        );
      });
    } else {
      notifications = [
        {
          'title': 'Order Completed!',
          'message':
              'Thanks for your purchase! Your course is now available in My Course. Take your time, start whenever you’re ready, and enjoy every step of your learning journey.',
          'image': 'assets/images/notification.png',
          'date': '04-30-2025 2:43 A.M.',
          'unread': true,
        },
        {
          'title': 'Order Completed!',
          'message':
              'Thanks for your purchase! Your course is now available in My Course. Take your time, start whenever you’re ready, and enjoy every step of your learning journey.',
          'image': 'assets/images/notification.png',
          'date': '01-04-2025 8:58 A.M.',
          'unread': false,
        },
      ];
      _saveNotifications();
    }
  }

  Future<void> _saveNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('notifications', jsonEncode(notifications));
  }

  void toggleReadStatus(int index) {
    setState(() {
      notifications[index]['unread'] = !notifications[index]['unread'];
    });
    _saveNotifications();
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Confirm Delete'),
            content: const Text(
              'Are you sure you want to delete selected notifications?',
            ),
            actions: [
              TextButton(
                child: const Text('Cancel'),
                onPressed:
                    () => Navigator.of(context, rootNavigator: true).pop(),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Delete'),
                onPressed: () {
                  final deletedItems = <Map<String, dynamic>>[];
                  final deletedIndexes = selectedIndexes.toList()..sort();

                  for (final index in deletedIndexes.reversed) {
                    deletedItems.add(notifications[index]);
                    notifications.removeAt(index);
                  }

                  setState(() {
                    selectedIndexes.clear();
                    isDeleteMode = false;
                  });

                  _saveNotifications();
                  Navigator.of(context, rootNavigator: true).pop();

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text("Notifications deleted"),
                      duration: const Duration(seconds: 4),
                      action: SnackBarAction(
                        label: 'UNDO',
                        onPressed: () {
                          setState(() {
                            for (int i = 0; i < deletedIndexes.length; i++) {
                              notifications.insert(
                                deletedIndexes[i],
                                deletedItems[i],
                              );
                            }
                          });
                          _saveNotifications();
                        },
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeNotifier>(context).isDarkMode;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        title: Text(
          "Notification",
          style: GoogleFonts.poppins(
            color: isDarkMode ? Colors.white : const Color(0xFF324EAF),
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconCircleButton(
            icon: Icons.search,
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ComingSoon()),
                ),
          ),
          const SizedBox(width: 10),
          IconCircleButton(
            icon: Icons.shopping_cart_outlined,
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => CartPage()),
                ),
          ),
          const SizedBox(width: 10),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: const Color(0xff324eaf),
          unselectedLabelColor: Colors.grey,
          indicatorColor: const Color(0xff324eaf),
          tabs: const [
            Tab(icon: Icon(Icons.mail_outline), text: 'All'),
            Tab(icon: Icon(Icons.mark_email_unread_outlined), text: 'Unread'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildNotificationList(notifications),
          _buildNotificationList(
            notifications.where((n) => n['unread'] == true).toList(),
          ),
        ],
      ),
      bottomSheet: Container(height: 16, color: Colors.grey.shade200),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: 2,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder:
                      (_) => ExplorePage(selectedCategory: categoryselected),
                ),
              );
              break;
            case 1:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => MyCoursePage()),
              );
              break;
            case 2:
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
      floatingActionButton: SpeedDial(
        backgroundColor: const Color(0xff324eaf),
        icon: isDeleteMode ? Icons.close : Icons.add,
        activeIcon: Icons.close,
        spacing: 10,
        spaceBetweenChildren: 8,
        children: [
          SpeedDialChild(
            child: const Icon(Icons.settings, color: Colors.white),
            backgroundColor: const Color(0xff4e7fff),
            labelStyle: const TextStyle(color: Colors.white),
            labelBackgroundColor: const Color(0xff4e7fff),
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ComingSoon()),
                ),
          ),
          SpeedDialChild(
            child: const Icon(Icons.delete, color: Colors.white),
            backgroundColor:
                isDeleteMode ? Colors.red : const Color(0xff4e7fff),
            labelStyle: const TextStyle(color: Colors.white),
            labelBackgroundColor:
                isDeleteMode ? Colors.red : const Color(0xff4e7fff),
            onTap: () {
              if (isDeleteMode && selectedIndexes.isNotEmpty) {
                _showDeleteConfirmation();
              } else {
                setState(() => isDeleteMode = !isDeleteMode);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationList(List<Map<String, dynamic>> list) {
    final isDarkMode = Provider.of<ThemeNotifier>(context).isDarkMode;

    if (list.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/notification.png', height: 200),
              const SizedBox(height: 24),
              Text(
                "No Notification Yet",
                style: AppTextStyles.heading.copyWith(
                  color: isDarkMode ? Colors.white : const Color(0xff324eaf),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "Fresh start! We’ll let you know when there’s something worth your attention.",
                textAlign: TextAlign.center,
                style: AppTextStyles.subheading.copyWith(
                  color: isDarkMode ? Colors.white70 : const Color(0xff324eaf),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: list.length,
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        final notif = list[index];
        final originalIndex = notifications.indexOf(notif);

        return Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Color(0xff324eaf), width: 1),
            ),
          ),
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 4,
            ),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(notif['image'], width: 50, height: 50),
            ),
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    notif['title'],
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                if (notif['unread'])
                  const Icon(Icons.circle, size: 10, color: Colors.green),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notif['message'],
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(fontSize: 12),
                ),
                const SizedBox(height: 4),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    notif['date'],
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
            trailing:
                isDeleteMode
                    ? Checkbox(
                      value: selectedIndexes.contains(originalIndex),
                      onChanged: (value) {
                        setState(() {
                          if (value == true) {
                            selectedIndexes.add(originalIndex);
                          } else {
                            selectedIndexes.remove(originalIndex);
                          }
                        });
                      },
                    )
                    : PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'toggle') toggleReadStatus(originalIndex);
                      },
                      itemBuilder:
                          (_) => [
                            PopupMenuItem<String>(
                              value: 'toggle',
                              child: Text(
                                notif['unread']
                                    ? 'Mark as Read'
                                    : 'Mark as Unread',
                              ),
                            ),
                          ],
                    ),
          ),
        );
      },
    );
  }
}
