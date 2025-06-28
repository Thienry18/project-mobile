import 'package:flutter/material.dart';
import 'package:projek_mobile/constants/app_text_style.dart';
import 'package:projek_mobile/data/cart_data.dart';
import 'package:projek_mobile/data/category.dart';
import 'package:projek_mobile/models/explore_model.dart';
import 'package:projek_mobile/widgets/cart_item_tile.dart';

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

  void _deleteSelectedItems() {
    setState(() {
      cartCourses.removeWhere(
        (course) => selectedIndexes.contains(course.index),
      );
      selectedIndexes.clear();
    });
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
                    onPressed: _deleteSelectedItems,
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
          _buildBottomSummary(cartItems),
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
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: 200,
                width: 200,
                color: Colors.blue,
                alignment: Alignment.center,
                child: const Icon(
                  Icons.broken_image,
                  color: Colors.white,
                  size: 48,
                ),
              );
            },
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

  Widget _buildBottomSummary(List<Course> items) {
    final selectedItems =
        items.where((item) => selectedIndexes.contains(item.index)).toList();
    final total = _calculateTotal(selectedItems);
    final finalTotal = total - promoDiscount;
    final hasSelected = selectedItems.isNotEmpty;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (hasSelected)
          InkWell(
            onTap: _showPromoBottomSheet,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: const Color(0xFFEDE7FF),
              child: Row(
                children: const [
                  Icon(Icons.local_activity_outlined, color: Color(0xFF815CFF)),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "Tap to apply your voucher and enjoy the discount!",
                      style: TextStyle(color: Color(0xFF815CFF)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Colors.grey.shade300)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Checkbox(
                    value: selectAll,
                    onChanged: (value) {
                      setState(() {
                        selectAll = value ?? false;
                        selectedIndexes =
                            selectAll ? items.map((e) => e.index).toSet() : {};
                      });
                    },
                  ),
                  const Text("All"),
                  const Spacer(),
                  if (promoDiscount > 0)
                    Text(
                      "-\$${promoDiscount.toStringAsFixed(2)}",
                      style: const TextStyle(color: Colors.blueAccent),
                    ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Total: \$${hasSelected ? finalTotal.toStringAsFixed(2) : '0'}",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (promoDiscount > 0)
                          Text(
                            "Cha-ching! \$${promoDiscount.toStringAsFixed(1)} saved with $selectedPromo!",
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00C569),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: hasSelected ? () {} : null,
                    child: Text("Checkout (${selectedItems.length})"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
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
