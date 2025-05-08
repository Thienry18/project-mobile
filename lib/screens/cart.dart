import 'package:flutter/material.dart';
import 'package:projek_mobile/data/category.dart';
import 'package:projek_mobile/widgets/category_chips.dart';
import 'package:projek_mobile/widgets/custom_bottom_bar.dart';
import 'package:projek_mobile/widgets/cart_item_tile.dart';
import 'package:projek_mobile/data/cart_data.dart';
import 'package:projek_mobile/constants/app_text_style.dart';
import 'package:projek_mobile/models/explore_model.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  int? selectedCategoryIndex;
  bool selectAll = false;
  Set<int> selectedIndexes = {};

  @override
  void initState() {
    super.initState();
    selectedIndexes = cartCourses.map((e) => e.index).toSet();
    selectAll = selectedIndexes.length == cartCourses.length;
  }

  void _onSelectAllChanged(bool? value) {
    setState(() {
      selectAll = value ?? false;
      selectedIndexes =
          selectAll ? cartCourses.map((e) => e.index).toSet() : {};
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Course> cartItems = cartCourses;
    final bool isEmpty = cartItems.isEmpty;

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
          Icon(Icons.delete_outline, color: Color(0xFF324EAF)),
          SizedBox(width: 16),
        ],
      ),
      bottomNavigationBar: CustomBottomBar(
        total: _calculateTotal(cartItems),
        cartCount: selectedIndexes.length,
        selectAll: selectAll,
        onSelectAllChanged: _onSelectAllChanged,
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          CategoryChips(
            categoryList: ['All', ...categoryList],
            selectedIndex: selectedCategoryIndex,
            onCategorySelected: (index) {
              setState(() => selectedCategoryIndex = index);
            },
          ),
          const SizedBox(height: 10),
          Expanded(
            child: isEmpty ? _buildEmptyCart() : _buildCartList(cartItems),
          ),
        ],
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
              if (isSelected) {
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
          Image.asset('assets/images/empty_cart.png', height: 200),
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
    return items.where((item) => selectedIndexes.contains(item.index)).fold(
      0.0,
      (sum, item) {
        final price =
            double.tryParse(item.price.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0;
        return sum + price;
      },
    );
  }
}
