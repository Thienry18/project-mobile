import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:projek_mobile/constants/app_text_style.dart';
import 'package:projek_mobile/data/cart_data.dart';
import 'package:projek_mobile/data/category.dart';
import 'package:projek_mobile/models/explore_model.dart';
import 'package:projek_mobile/providers/theme_provider.dart';
import 'package:projek_mobile/screens/history.dart';
import 'package:projek_mobile/screens/my_course_page.dart';
import 'package:projek_mobile/widgets/cart_item_tile.dart';
import 'package:projek_mobile/widgets/custom_bottom_bar.dart';
import 'package:projek_mobile/data/my_course_data.dart';
import 'package:projek_mobile/widgets/category_chips.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  @override
  void initState() {
    super.initState();
    _selectAllVisibleItems();
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Confirm Delete'),
            content: const Text(
              'Are you sure you want to delete selected items from cart?',
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
                  final deletedItems = <Course>[];
                  final deletedIndexes = selectedIndexes.toList()..sort();

                  for (final index in deletedIndexes.reversed) {
                    final course = cartCourses.firstWhere(
                      (c) => c.index == index,
                    );
                    deletedItems.add(course);
                    cartCourses.remove(course);
                  }

                  setState(() {
                    selectedIndexes.clear();
                    _selectAllVisibleItems();
                  });

                  Navigator.of(context, rootNavigator: true).pop();

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text("Items deleted from cart"),
                      duration: const Duration(seconds: 4),
                      action: SnackBarAction(
                        label: 'UNDO',
                        onPressed: () {
                          setState(() {
                            for (int i = 0; i < deletedItems.length; i++) {
                              cartCourses.insert(0, deletedItems[i]);
                            }
                            _selectAllVisibleItems();
                          });
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

  void _selectAllVisibleItems() {
    final items = _getFilteredCartItems();
    selectedIndexes = items.map((e) => e.index).toSet();
    selectAll = selectedIndexes.length == items.length;
  }

  List<Course> _getFilteredCartItems() {
    if (selectedCategoryIndex == 0) return cartCourses;
    final category = categoryList[selectedCategoryIndex - 1];
    return cartCourses.where((e) => e.category == category).toList();
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
              const Text(
                "Select a Voucher",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ListTile(
                leading: const Icon(Icons.local_offer, color: Colors.green),
                title: const Text("DISCOUNT20 - Save \$16.3"),
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
                title: const Text("FREESHIP - Free Shipping"),
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
    final prefs = await SharedPreferences.getInstance();
    final historyData = prefs.getString('purchase_history');
    final List<Map<String, dynamic>> history =
        historyData != null
            ? List<Map<String, dynamic>>.from(jsonDecode(historyData))
            : [];
    final purchasedTitles = history.map((e) => e['title']).toSet();
    final myCourseTitles = myCourses.map((e) => e.title).toSet();
    final selectedItems =
        cartCourses.where((item) {
          final notInHistory = !purchasedTitles.contains(item.title);
          final notInMyCourses = !myCourseTitles.contains(item.title);
          return selectedIndexes.contains(item.index) &&
              notInHistory &&
              notInMyCourses;
        }).toList();

    if (selectedItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("No new courses to purchase."),
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    for (final course in selectedItems) {
      myCourses.add(course);
    }
    cartCourses.removeWhere((item) => selectedIndexes.contains(item.index));
    setState(() {
      selectedIndexes.clear();
      selectedPromo = null;
      promoDiscount = 0.0;
      _selectAllVisibleItems();
    });
    await _addCheckoutNotification(selectedItems);
    await _saveToHistory(selectedItems);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => MyCoursePage()),
    );
  }

  Future<void> _saveToHistory(List<Course> purchasedCourses) async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('purchase_history');
    List<Map<String, dynamic>> history = [];
    if (data != null) {
      history = List<Map<String, dynamic>>.from(jsonDecode(data));
    }
    for (final course in purchasedCourses) {
      history.add({
        'image': course.images,
        'title': course.title,
        'rating': course.rating,
        'price':
            double.tryParse(course.price.replaceAll(RegExp(r'[^\d.]'), '')) ??
            0.0,
        'isBestseller': course.isBestseller,
        'duration': course.duration,
        'category': course.category,
        "status": "completed",
      });
    }
    await prefs.setString('purchase_history', jsonEncode(history));
  }

  Future<void> _addCheckoutNotification(List<Course> purchasedCourses) async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('notifications');
    List<Map<String, dynamic>> currentNotifications = [];
    if (data != null) {
      currentNotifications = List<Map<String, dynamic>>.from(
        jsonDecode(data).map((e) => Map<String, dynamic>.from(e)),
      );
    }
    final imageUrl =
        purchasedCourses.isNotEmpty ? purchasedCourses.first.images : null;
    final newNotification = {
      'title': 'Order Completed!',
      'message':
          'Thanks for your purchase! Your course is now available in My Course. Take your time, start whenever you’re ready, and enjoy every step of your learning journey.',
      'image': imageUrl ?? '',
      'date': _getCurrentFormattedDateTime(),
      'unread': true,
      'isNetworkImage': true,
    };
    currentNotifications.insert(0, newNotification);
    await prefs.setString('notifications', jsonEncode(currentNotifications));
  }

  String _getCurrentFormattedDateTime() {
    final now = DateTime.now();
    final hour = now.hour > 12 ? now.hour - 12 : now.hour;
    final amPm = now.hour >= 12 ? 'P.M.' : 'A.M.';
    final formatted =
        '${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}-${now.year} $hour:${now.minute.toString().padLeft(2, '0')} $amPm';
    return formatted;
  }

  @override
  Widget build(BuildContext context) {
    final cartItems = _getFilteredCartItems();
    final isDarkMode = Provider.of<ThemeNotifier>(context).isDarkMode;
    final isEmpty = cartItems.isEmpty;

    return Scaffold(
      backgroundColor: Colors.white,
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
            padding: const EdgeInsets.only(left: 16), // Tambah padding kiri
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
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF324EAF),
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
                width: screenWidth - 32, // 16 left + 16 right padding
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
