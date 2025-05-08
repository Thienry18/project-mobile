import 'package:flutter/material.dart';
import 'package:projek_mobile/models/explore_model.dart';
import 'package:projek_mobile/constants/app_text_style.dart';

class CartItemTile extends StatelessWidget {
  final Course course;
  final bool isSelected;
  final ValueChanged<bool> onChanged;

  const CartItemTile({
    required this.course,
    required this.isSelected,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Checkbox(
          value: isSelected,
          onChanged: (value) {
            if (value != null) {
              onChanged(value);
            }
          },
        ),
        title: Text(course.title, style: AppTextStyles.body),
        subtitle: Row(
          children: [
            const Icon(Icons.star, size: 14, color: Colors.amber),
            const SizedBox(width: 4),
            Text(course.rating, style: AppTextStyles.body),
            if (course.isBestseller)
              Container(
                margin: const EdgeInsets.only(left: 8),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.yellow,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  "Bestseller",
                  style: TextStyle(
                    color: Color(0xFF324EAF),
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ),
          ],
        ),
        trailing: Text(
          course.price,
          style: AppTextStyles.body.copyWith(
            fontWeight: FontWeight.bold,
            color: const Color(0xFF324EAF),
          ),
        ),
      ),
    );
  }
}
