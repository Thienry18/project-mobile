import 'package:flutter/material.dart';

class CustomBottomBar extends StatelessWidget {
  final double total;
  final int cartCount;
  final bool selectAll;
  final ValueChanged<bool?> onSelectAllChanged;

  const CustomBottomBar({
    required this.total,
    required this.cartCount,
    required this.selectAll,
    required this.onSelectAllChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Checkbox(value: selectAll, onChanged: onSelectAllChanged),
                const Text("Select All"),
              ],
            ),
            Text(
              'Total: \$${total.toStringAsFixed(2)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            Text('Items: $cartCount'),
          ],
        ),
      ),
    );
  }
}
