import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projek_mobile/constants/app_text_style.dart';
import 'package:projek_mobile/data/interest_data.dart';
import 'package:projek_mobile/screens/cart.dart';
import 'package:projek_mobile/screens/explore_page.dart';
import 'package:projek_mobile/screens/my_course_page.dart';
import 'package:projek_mobile/screens/profile.dart';
import 'package:projek_mobile/widgets/custom_bottom_nav.dart';
import 'package:projek_mobile/providers/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:projek_mobile/database/database_service.dart';
import 'package:projek_mobile/database/database_notification.dart';
import 'package:projek_mobile/database/database_user.dart';

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
  List<Map<String, dynamic>> notifications = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    // If there are legacy prefs notifications, migrate them into DB first
    final legacy = prefs.getString('notifications');
    try {
      final userId = await DatabaseUser.getOrCreateDemoUserIdForApp();
      final db = await DatabaseService.instance.database;

      if (legacy != null) {
        final List<dynamic> legacyList = jsonDecode(legacy);
        for (final item in legacyList) {
          try {
            final Map<String, dynamic> m = Map<String, dynamic>.from(item);
            await DatabaseNotification.insertNotification(db, {
              'user_id': userId,
              'course_id': m['course_id'] ?? null,
              'title': m['title'] ?? m['title'],
              'message': m['message'] ?? '',
              'course_title': m['course_title'] ?? m['title'] ?? '',
              'course_image': m['image'] ?? m['course_image'] ?? '',
              'course_price': m['course_price'] ?? '',
              'is_read': (m['unread'] == true) ? 0 : 1,
              'created_at': DateTime.now().millisecondsSinceEpoch,
            });
          } catch (e) {
            // ignore individual migration errors
            // ignore: avoid_print
            print('Migration: failed to migrate notif: $e');
          }
        }
        // clear legacy prefs so we don't duplicate on next load
        await prefs.remove('notifications');
      }

      // Load notifications from DB
      final rows = await DatabaseNotification.getUserNotifications(db, userId);
      // Map DB rows into UI-friendly structure
      notifications =
          rows.map((r) {
            final created =
                r['created_at'] as int? ??
                DateTime.now().millisecondsSinceEpoch;
            final img = r['course_image'] as String? ?? '';
            final isNetwork = img.startsWith('http');
            return <String, dynamic>{
              'id': r['id'],
              'title': r['title'] ?? '',
              'message': r['message'] ?? '',
              'image': img.isNotEmpty ? img : 'assets/images/notification.png',
              'date': _formatDateTime(created),
              'unread': (r['is_read'] as int? ?? 0) == 0,
              'isNetworkImage': isNetwork,
              'created_at': created,
            };
          }).toList();
      setState(() {});
    } catch (e) {
      // fallback to empty list on error
      // ignore: avoid_print
      print('Failed to load notifications from DB: $e');
      setState(() => notifications = []);
    }
  }

  // legacy: notifications are persisted in DB; migration from prefs handled in _loadNotifications

  String _formatDateTime(int millis) {
    final dt = DateTime.fromMillisecondsSinceEpoch(millis);
    final hour = dt.hour > 12 ? dt.hour - 12 : dt.hour;
    final ampm = dt.hour >= 12 ? 'P.M.' : 'A.M.';
    return '${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}-${dt.year} ${hour}:${dt.minute.toString().padLeft(2, '0')} $ampm';
  }

  void toggleReadStatus(int index) {
    () async {
      final notif = notifications[index];
      final id = notif['id'] as int?;
      if (id == null) return;
      try {
        final db = await DatabaseService.instance.database;
        final currentlyUnread = notif['unread'] == true;
        if (currentlyUnread) {
          // mark as read
          await DatabaseNotification.markAsRead(db, id);
        } else {
          // mark as unread
          await db.update(
            DatabaseNotification.table,
            {'is_read': 0},
            where: 'id = ?',
            whereArgs: [id],
          );
        }
        await _loadNotifications();
      } catch (e) {
        // ignore: avoid_print
        print('Failed toggle read status: $e');
      }
    }();
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text(AppLocalizations.of(context).confirmDeleteTitle),
            content: Text(
              AppLocalizations.of(context).confirmDeleteNotifications,
            ),
            actions: [
              TextButton(
                child: Text(AppLocalizations.of(context).cancel),
                onPressed:
                    () => Navigator.of(context, rootNavigator: true).pop(),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: Text(AppLocalizations.of(context).delete),
                onPressed: () {
                  final deletedItems = <Map<String, dynamic>>[];
                  final deletedIndexes = selectedIndexes.toList()..sort();

                  for (final idx in deletedIndexes.reversed) {
                    deletedItems.add(notifications[idx]);
                  }

                  () async {
                    try {
                      final db = await DatabaseService.instance.database;
                      // delete each selected notification
                      for (final item in deletedItems) {
                        final id = item['id'] as int?;
                        if (id != null)
                          await DatabaseNotification.deleteNotification(db, id);
                      }
                      await _loadNotifications();
                      setState(() {
                        selectedIndexes.clear();
                        isDeleteMode = false;
                      });
                      Navigator.of(context, rootNavigator: true).pop();

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            AppLocalizations.of(context).notificationsDeleted,
                          ),
                          duration: const Duration(seconds: 4),
                          action: SnackBarAction(
                            label: AppLocalizations.of(context).undo,
                            onPressed: () async {
                              // Re-insert deleted items back into DB
                              try {
                                final db2 =
                                    await DatabaseService.instance.database;
                                for (final item in deletedItems.reversed) {
                                  await DatabaseNotification.insertNotification(
                                    db2,
                                    {
                                      'user_id':
                                          await DatabaseUser.getOrCreateDemoUserIdForApp(),
                                      'course_id': null,
                                      'title': item['title'] ?? '',
                                      'message': item['message'] ?? '',
                                      'course_title': '',
                                      'course_image': item['image'] ?? '',
                                      'course_price': '',
                                      'is_read': item['unread'] == true ? 0 : 1,
                                      'created_at':
                                          item['created_at'] ??
                                          DateTime.now().millisecondsSinceEpoch,
                                    },
                                  );
                                }
                              } catch (e) {
                                // ignore: avoid_print
                                print('Undo re-insert failed: $e');
                              }
                              await _loadNotifications();
                            },
                          ),
                        ),
                      );
                    } catch (e) {
                      // ignore: avoid_print
                      print('Failed to delete notifications: $e');
                      Navigator.of(context, rootNavigator: true).pop();
                    }
                  }();
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
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: isDarkMode ? Colors.black : const Color(0xff324eaf),
        title: Text(
          AppLocalizations.of(context).notification,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          const SizedBox(width: 10),
          Tooltip(
            message: 'Cart',
            child: IconButton(
              icon: const Icon(Icons.shopping_cart_outlined),
              color: Colors.white,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => CartPage()),
                );
              },
            ),
          ),

          const SizedBox(width: 10),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey,
          tabs: [
            Tab(
              icon: const Icon(Icons.mail_outline),
              text: AppLocalizations.of(context).allNotifications,
            ),
            Tab(
              icon: const Icon(Icons.mark_email_unread_outlined),
              text: AppLocalizations.of(context).unread,
            ),
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
        foregroundColor: Colors.white,
        icon: isDeleteMode ? Icons.close : Icons.add,
        activeIcon: Icons.close,
        spacing: 10,
        spaceBetweenChildren: 8,
        children: [
          SpeedDialChild(
            child: const Icon(Icons.delete, color: Colors.white),
            backgroundColor:
                isDeleteMode ? Colors.red : const Color(0xff324eaf),
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
                AppLocalizations.of(context).noNotification,
                style: AppTextStyles.heading.copyWith(
                  color: isDarkMode ? Colors.white : const Color(0xff324eaf),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                AppLocalizations.of(context).noNotificationDescription,
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
              child:
                  notif['isNetworkImage'] == true
                      ? Image.network(
                        notif['image'],
                        width: 50,
                        height: 50,
                        errorBuilder:
                            (_, __, ___) => Container(
                              width: 50,
                              height: 50,
                              color: Colors.grey,
                              child: const Icon(
                                Icons.broken_image,
                                color: Colors.white,
                              ),
                            ),
                      )
                      : Image.asset(
                        notif['image'],
                        width: 50,
                        height: 50,
                        errorBuilder:
                            (_, __, ___) => Container(
                              width: 50,
                              height: 50,
                              color: Colors.grey,
                              child: const Icon(
                                Icons.broken_image,
                                color: Colors.white,
                              ),
                            ),
                      ),
            ),

            title: Row(
              children: [
                Expanded(
                  child: Text(
                    notif['title'],
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: isDarkMode ? Colors.white : Color(0xff324eaf),
                    ),
                  ),
                ),
                if (notif['unread'])
                  const Icon(Icons.circle, size: 12, color: Colors.green),
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
                                    ? AppLocalizations.of(context).markAsRead
                                    : AppLocalizations.of(context).markAsUnread,
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
