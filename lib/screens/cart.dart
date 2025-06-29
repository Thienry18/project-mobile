import 'package:flutter/material.dart';
import 'package:projek_mobile/constants/app_text_style.dart';
import 'package:projek_mobile/data/cart_data.dart';
import 'package:projek_mobile/data/category.dart';
import 'package:projek_mobile/models/explore_model.dart';
import 'package:projek_mobile/screens/my_course_page.dart';
import 'package:projek_mobile/widgets/cart_item_tile.dart';
import 'package:projek_mobile/widgets/custom_bottom_bar.dart';
import 'package:projek_mobile/data/my_course_data.dart';

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

  void _handleCheckout() {
    final selectedItems =
        cartCourses
            .where((item) => selectedIndexes.contains(item.index))
            .toList();

    for (final course in selectedItems) {
      if (!myCourses.any((c) => c.index == course.index)) {
        myCourses.add(course);
      }
    }

    cartCourses.removeWhere((item) => selectedIndexes.contains(item.index));

    setState(() {
      selectedIndexes.clear();
      selectedPromo = null;
      promoDiscount = 0.0;
      _selectAllVisibleItems();
    });

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => MyCoursePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartItems = _getFilteredCartItems();
    final isEmpty = cartItems.isEmpty;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'My Cart',
          style: TextStyle(
            color: Color(0xFF324EAF),
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF324EAF)),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: const [
          Icon(Icons.qr_code, color: Color(0xFF324EAF)),
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
          _buildCategoryChips(),
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
                      style: const TextStyle(color: Colors.red),
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

  Widget _buildCategoryChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: List.generate(categoryList.length + 1, (index) {
          final label = index == 0 ? 'All' : categoryList[index - 1];
          final isSelected = selectedCategoryIndex == index;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(label),
              selected: isSelected,
              onSelected: (_) {
                setState(() {
                  selectedCategoryIndex = index;
                  _selectAllVisibleItems();
                });
              },
            ),
          );
        }),
      ),
    );
  }

  Widget _buildCartList(List<Course> cartItems) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: cartItems.length,
      itemBuilder: (context, index) {
        final course = cartItems[index];
        return CartItemTile(
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
