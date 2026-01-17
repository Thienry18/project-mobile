import 'package:flutter/material.dart';
import 'package:projek_mobile/providers/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:projek_mobile/database/database_service.dart';
import 'package:projek_mobile/database/database_mycourse.dart';
import 'package:projek_mobile/database/database_history.dart';
import 'package:projek_mobile/database/database_user.dart';
import 'package:projek_mobile/providers/history_provider.dart';
import 'package:projek_mobile/l10n/app_localizations.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  List<Map<String, dynamic>> historyData = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadHistory();
    // Attach a listener to HistoryNotifier to refresh when DB changes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        final notifier = Provider.of<HistoryNotifier>(context, listen: false);
        notifier.addListener(() async {
          await _loadHistory();
        });
      } catch (_) {
        // provider not registered; ignore
      }
    });
  }

  Future<void> _loadHistory() async {
    try {
      final userId = await DatabaseUser.getOrCreateUserIdForCurrentAppUser();
      final db = await DatabaseService.instance.database;
      // Load both mycourse (purchased snapshot) and history (additional records)
      final mycourseRows = await DatabaseMyCourse.getMyCourses(db, userId);
      final historyRows = await DatabaseHistory.getHistory(db, userId);

      // Normalize rows into a common shape and combine
      final combined = <Map<String, dynamic>>[];

      final myCourseIds = <int>{};
      for (final r in mycourseRows) {
        // normalize price to double for consistent UI rendering
        double price = 0.0;
        final rawPrice = r['price'];
        if (rawPrice is num) {
          price = rawPrice.toDouble();
        } else if (rawPrice is String) {
          price =
              double.tryParse(rawPrice.replaceAll(RegExp(r'[^0-9\.]'), '')) ??
              0.0;
        }

        final courseId =
            (r['course_id'] is num)
                ? (r['course_id'] as num).toInt()
                : (r['course_id'] is String)
                ? int.tryParse(r['course_id']) ?? 0
                : 0;

        myCourseIds.add(courseId);

        combined.add({
          'id': r['id'],
          'course_id': courseId,
          'title': r['title'],
          'image': r['image'],
          'rating': r['rating'] ?? '0',
          'price': price,
          'status': r['status'] ?? 'completed',
          'isBestseller': false,
          'timestamp': r['purchased_at'] ?? 0,
        });
      }

      for (final r in historyRows) {
        double price = 0.0;
        final rawPrice = r['price'];
        if (rawPrice is num) {
          price = rawPrice.toDouble();
        } else if (rawPrice is String) {
          price =
              double.tryParse(rawPrice.replaceAll(RegExp(r'[^0-9\.]'), '')) ??
              0.0;
        }

        final histCourseId =
            (r['course_id'] is num)
                ? (r['course_id'] as num).toInt()
                : (r['course_id'] is String)
                ? int.tryParse(r['course_id']) ?? 0
                : 0;

        // If we already have this course in mycourse (snapshot of purchase),
        // skip adding a duplicate history entry for completed purchases so the
        // user sees a single record.
        if (histCourseId != 0 &&
            myCourseIds.contains(histCourseId) &&
            (r['status'] ?? 'completed') == 'completed') {
          continue;
        }

        combined.add({
          'id': r['id'],
          'course_id': histCourseId,
          'title': r['title'],
          'image': r['image'],
          'rating': r['rating'] ?? '0',
          'price': price,
          'status': r['status'] ?? 'completed',
          'isBestseller': false,
          'timestamp': r['occurred_at'] ?? 0,
        });
      }

      // Sort by timestamp desc
      combined.sort(
        (a, b) => (b['timestamp'] as int).compareTo(a['timestamp'] as int),
      );

      setState(() {
        historyData = combined;
      });
    } catch (e) {
      // ignore: avoid_print
      print('Failed to load purchase history from DB: $e');
    }
  }

  void _confirmDeleteHistory(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) {
        final l10n = AppLocalizations.of(ctx);
        return AlertDialog(
          title: Text(l10n.clearPurchaseHistory),
          content: const Text(
            "Are you sure you want to clear your history? This action cannot be undone.",
          ),
          actions: [
            TextButton(
              child: Text(l10n.cancel),
              onPressed: () => Navigator.of(ctx).pop(),
            ),
            TextButton(
              child: Text(
                AppLocalizations.of(ctx).delete,
                style: const TextStyle(color: Colors.red),
              ),
              onPressed: () async {
                try {
                  final userId =
                      await DatabaseUser.getOrCreateUserIdForCurrentAppUser();
                  final db = await DatabaseService.instance.database;
                  // Clear both mycourse and history entries for the user
                  await db.delete(
                    'mycourse',
                    where: 'user_id = ?',
                    whereArgs: [userId],
                  );
                  await DatabaseHistory.clearHistoryForUser(db, userId);
                  setState(() {
                    historyData.clear();
                  });
                } catch (e) {
                  // ignore: avoid_print
                  print('Failed to clear purchase history: $e');
                }
                Navigator.of(ctx).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(AppLocalizations.of(context).historyCleared),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildEmptyContent(String title) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/no_orders.png', height: 250),
            const SizedBox(height: 24),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xff324eaf),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              AppLocalizations.of(context).historyEmptyDescription,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryList(String status) {
    final filteredItems =
        historyData.where((item) => item['status'] == status).toList();

    if (filteredItems.isEmpty) {
      return _buildEmptyContent(AppLocalizations.of(context).noOrdersFound);
    }

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: filteredItems.length,
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) {
              final item = filteredItems[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xfff4f6fe),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Builder(
                        builder: (context) {
                          final img = (item['image'] ?? '').toString();
                          if (img.startsWith('http')) {
                            return Image.network(
                              img,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              errorBuilder:
                                  (context, error, stackTrace) => Container(
                                    width: 60,
                                    height: 60,
                                    color: Colors.grey,
                                    alignment: Alignment.center,
                                    child: const Icon(
                                      Icons.broken_image,
                                      color: Colors.white,
                                    ),
                                  ),
                            );
                          } else if (img.isNotEmpty) {
                            // treat as local asset path
                            return Image.asset(
                              img,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            );
                          } else {
                            return Container(
                              width: 60,
                              height: 60,
                              color: Colors.grey,
                              alignment: Alignment.center,
                              child: const Icon(
                                Icons.broken_image,
                                color: Colors.white,
                              ),
                            );
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['title'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Color(0xff324eaf),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                size: 16,
                                color: Colors.amber,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                item['rating'],
                                style: const TextStyle(fontSize: 12),
                              ),
                              if (item['isBestseller'] == true)
                                Container(
                                  margin: const EdgeInsets.only(left: 8),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.orange,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    AppLocalizations.of(context).bestseller,
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          status == 'completed'
                              ? AppLocalizations.of(context).completed
                              : AppLocalizations.of(context).cancelled,
                          style: TextStyle(
                            color:
                                status == 'completed'
                                    ? Colors.green
                                    : Colors.red,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          '\$${(item['price'] as double).toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeNotifier>(context).isDarkMode;
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).history),
        centerTitle: false,
        elevation: 0,
        backgroundColor: isDarkMode ? Colors.black : const Color(0xff324eaf),
        foregroundColor: Colors.white,
        leading: const BackButton(color: Colors.white),
        actions: [
          Tooltip(
            message: AppLocalizations.of(context).clearHistory,
            child: IconButton(
              icon: const Icon(Icons.delete_outline),
              tooltip: AppLocalizations.of(context).clearHistory,
              onPressed: () => _confirmDeleteHistory(context),
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.white,
          tabs: [
            Tab(
              icon: const Icon(Icons.check_circle),
              text: AppLocalizations.of(context).completed,
            ),
            Tab(
              icon: const Icon(Icons.cancel),
              text: AppLocalizations.of(context).cancelled,
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildHistoryList("completed"),
          _buildHistoryList("cancelled"),
        ],
      ),
    );
  }
}
