import 'package:flutter/material.dart';
import 'package:projek_mobile/constants/app_text_style.dart';
import 'package:projek_mobile/firebase/firebase_analytics_service.dart';
import 'package:projek_mobile/database/database_service.dart';
import 'package:projek_mobile/database/database_cart.dart';
import 'package:projek_mobile/database/database_user.dart';
import 'package:projek_mobile/database/database_course.dart';
import 'package:projek_mobile/database/database_history.dart';
import 'package:projek_mobile/data/category.dart';
import 'package:projek_mobile/models/explore_model.dart';
import 'package:projek_mobile/providers/theme_provider.dart';
import 'package:projek_mobile/screens/history.dart';
import 'package:projek_mobile/screens/payment_screen.dart';
import 'package:projek_mobile/widgets/cart_item_tile.dart';
import 'package:projek_mobile/widgets/custom_bottom_bar.dart';
import 'package:projek_mobile/data/my_course_data.dart';
import 'package:projek_mobile/widgets/category_chips.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  int selectedCategoryIndex = 0;
  bool selectAll = false;
  Set<int> selectedIndexes = {};
  String? selectedPromo;
  double promoDiscount = 0.0;
  int? _userId;
  List<Course> _dbCartCourses = [];

  @override
  void initState() {
    super.initState();
    _loadCartFromDb();
  }

  Future<void> _loadCartFromDb() async {
    try {
      final uid = await DatabaseUser.getOrCreateDemoUserIdForApp();
      _userId = uid;
      final db = await DatabaseService.instance.database;
      final rows = await DatabaseCart.getUserCart(db, uid);
      final List<Course> loaded = [];
      for (final r in rows) {
        final courseId = (r['course_id'] as num?)?.toInt() ?? 0;
        final courseFromDb = await DatabaseCourse.getCourseById(db, courseId);
        if (courseFromDb != null) {
          loaded.add(courseFromDb);
        } else {
          loaded.add(
            Course(
              images:
                  (r['image'] as String?) ??
                  'assets/images/card_image/udemy_course.jpg',
              title: (r['title'] as String?) ?? 'Course',
              duration: (r['added_at'] != null) ? 'Purchased' : '',
              rating: (r['price'] as String?) ?? '0',
              price: (r['price'] as String?) ?? '0',
              isBestseller: false,
              index: courseId,
              category: '',
              instructor: (r['instructor'] as String?) ?? '',
              language: '',
              subtitle: '',
            ),
          );
        }
      }
      setState(() {
        _dbCartCourses = loaded;
      });
      _selectAllVisibleItems();
    } catch (e) {
      // ignore: avoid_print
      print('Error loading cart from DB: $e');
    }
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text(AppLocalizations.of(context)!.confirmDeleteTitle),
            content: Text(
              AppLocalizations.of(context)!.confirmDeleteCartContent,
            ),
            actions: [
              TextButton(
                child: Text(AppLocalizations.of(context)!.cancel),
                onPressed:
                    () => Navigator.of(context, rootNavigator: true).pop(),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: Text(AppLocalizations.of(context)!.delete),
                onPressed: () async {
                  Navigator.of(context, rootNavigator: true).pop();
                  // Ensure we have a user id
                  try {
                    final uid =
                        _userId ??
                        await DatabaseUser.getOrCreateDemoUserIdForApp();
                    _userId = uid;

                    final deletedItems = <Course>[];
                    final toDelete = selectedIndexes.toList();

                    // Remove each selected course from DB
                    for (final courseIdx in toDelete) {
                      final course = _dbCartCourses.firstWhere(
                        (c) => c.index == courseIdx,
                        orElse:
                            () => Course(
                              images:
                                  'assets/images/card_image/udemy_course.jpg',
                              title: 'Course',
                              duration: '',
                              rating: '0',
                              price: '0',
                              isBestseller: false,
                              index: courseIdx,
                              category: '',
                              instructor: '',
                              language: '',
                              subtitle: '',
                            ),
                      );
                      deletedItems.add(course);
                      await DatabaseCart.removeByUserCourseForUser(
                        uid,
                        courseIdx,
                      );
                      // record history for deletion from cart
                      try {
                        final db = await DatabaseService.instance.database;
                        await DatabaseHistory.addHistory(db, {
                          'user_id': uid,
                          'course_id': course.index,
                          'title': course.title,
                          'image': course.images,
                          'price': course.price,
                          'status': 'deleted',
                          'source': 'cart_delete',
                          'occurred_at': DateTime.now().millisecondsSinceEpoch,
                        });
                      } catch (e) {
                        // ignore: avoid_print
                        print('Could not insert history for cart deletion: $e');
                      }
                    }

                    // Refresh local list from DB
                    await _loadCartFromDb();

                    setState(() {
                      selectedIndexes.clear();
                      _selectAllVisibleItems();
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          AppLocalizations.of(context)!.itemsDeletedFromCart,
                        ),
                        duration: const Duration(seconds: 4),
                        action: SnackBarAction(
                          label: AppLocalizations.of(context)!.undo,
                          onPressed: () async {
                            // Re-insert deleted items
                            if (deletedItems.isEmpty) return;
                            for (final c in deletedItems) {
                              await DatabaseCart.upsertCourseForUser(uid, c);
                            }
                            await _loadCartFromDb();
                            setState(() {
                              _selectAllVisibleItems();
                            });
                          },
                        ),
                      ),
                    );
                  } catch (e) {
                    // ignore: avoid_print
                    print('Failed to delete items from DB: $e');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          AppLocalizations.of(context)!.failedToDeleteItems,
                        ),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
    );
  }

  void _selectAllVisibleItems() {
    final items = _getFilteredCartItems();
    selectedIndexes = items.map((e) => e.index).toSet();
    selectAll = selectedIndexes.length == items.length;
  }

  List<Course> _getFilteredCartItems() {
    if (selectedCategoryIndex == 0) return _dbCartCourses;
    final category = categoryList[selectedCategoryIndex - 1];
    return _dbCartCourses.where((e) => e.category == category).toList();
  }

  void _showPromoBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.selectVoucher,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              ListTile(
                leading: const Icon(Icons.local_offer, color: Colors.green),
                title: Text(AppLocalizations.of(context)!.discount20),
                onTap: () {
                  setState(() {
                    selectedPromo = "DISCOUNT20";
                    promoDiscount = 16.3;
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.card_giftcard, color: Colors.purple),
                title: Text(AppLocalizations.of(context)!.freeship),
                onTap: () {
                  setState(() {
                    selectedPromo = "FREESHIP";
                    promoDiscount = 0.0;
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _handleCheckout() async {
    final historyTitles = myCourses.map((e) => e.title).toSet();
    final selectedItems =
        _dbCartCourses.where((item) {
          return selectedIndexes.contains(item.index) &&
              !historyTitles.contains(item.title);
        }).toList();

    if (selectedItems.isEmpty) {
      await FirebaseAnalyticsService().trackCartAction(
        'checkout_failed',
        courseId: null,
        price: null,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.noNewCoursesToPurchase),
          duration: const Duration(seconds: 3),
        ),
      );
      return;
    }

    // Track successful checkout initiation
    for (final item in selectedItems) {
      await FirebaseAnalyticsService().trackCartAction(
        'checkout_initiated',
        courseId: item.index.toString(),
        price: double.tryParse(item.price.replaceAll('\$', '')),
      );
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder:
            (_) => PaymentScreen(
              selectedItems: selectedItems,
              promoDiscount: promoDiscount,
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartItems = _getFilteredCartItems();
    final isDarkMode = Provider.of<ThemeNotifier>(context).isDarkMode;
    final isEmpty = cartItems.isEmpty;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      appBar: AppBar(
        backgroundColor: isDarkMode ? Colors.black : const Color(0xFF324EAF),
        foregroundColor: Colors.white,
        title: const Text('My Cart'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HistoryScreen()),
              );
            },
            icon: Icon(Icons.history_toggle_off_outlined, color: Colors.white),
          ),
          SizedBox(width: 16),
        ],
      ),
      bottomNavigationBar: CustomBottomBar(
        total: _calculateTotal(
          cartItems
              .where((item) => selectedIndexes.contains(item.index))
              .toList(),
        ),
        cartCount: selectedIndexes.length,
        selectAll: selectAll,
        promoDiscount: promoDiscount,
        selectedPromo: selectedPromo,
        onSelectAllChanged: (value) {
          setState(() {
            selectAll = value ?? false;
            selectedIndexes =
                selectAll ? cartItems.map((e) => e.index).toSet() : {};
          });
        },
        onCheckout: _handleCheckout,
        onTapVoucher: _showPromoBottomSheet,
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: CategoryChips(
              categoryList: ['All', ...categoryList],
              selectedIndexes: {selectedCategoryIndex},
              onCategoryToggle: (index) {
                setState(() {
                  selectedCategoryIndex = index;
                  _selectAllVisibleItems();
                });
              },
            ),
          ),

          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (selectedIndexes.isNotEmpty)
                  Text(
                    "${selectedIndexes.length} Items",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Color(0xFF324EAF),
                    ),
                  ),
                if (selectedIndexes.isNotEmpty)
                  TextButton(
                    onPressed: _showDeleteConfirmation,
                    child: Text(
                      "Delete (${selectedIndexes.length})",
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: isEmpty ? _buildEmptyCart() : _buildCartList(cartItems),
          ),
        ],
      ),
    );
  }

  Widget _buildCartList(List<Course> cartItems) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: cartItems.length,
      itemBuilder: (context, index) {
        final course = cartItems[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Builder(
            builder: (context) {
              final screenWidth = MediaQuery.of(context).size.width;
              return Container(
                width: screenWidth - 32,
                child: CartItemTile(
                  course: course,
                  isSelected: selectedIndexes.contains(course.index),
                  onChanged: (isSelected) {
                    setState(() {
                      if (isSelected == true) {
                        selectedIndexes.add(course.index);
                      } else {
                        selectedIndexes.remove(course.index);
                      }
                      selectAll = selectedIndexes.length == cartItems.length;
                    });
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/empty_cart.png',
            height: 200,
            errorBuilder:
                (context, error, stackTrace) => Container(
                  height: 200,
                  width: 200,
                  color: Colors.blue,
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.broken_image,
                    color: Colors.white,
                    size: 48,
                  ),
                ),
          ),
          const SizedBox(height: 30),
          Text("No Items Yet", style: AppTextStyles.heading),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Text(
              "Add courses you're interested in to your wishlist and check out whenever you're ready to start learning.",
              textAlign: TextAlign.center,
              style: AppTextStyles.body,
            ),
          ),
        ],
      ),
    );
  }

  double _calculateTotal(List<Course> items) {
    return items.fold(0.0, (sum, item) {
      final price =
          double.tryParse(item.price.replaceAll(RegExp(r'[^\d.]'), '')) ?? 0.0;
      return sum + price;
    });
  }
}
