import 'package:flutter/material.dart';
import 'package:projek_mobile/models/explore_model.dart';
import 'package:projek_mobile/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class CartItemTile extends StatelessWidget {
  final Course course;
  final bool isSelected;
  final ValueChanged<bool?> onChanged;

  const CartItemTile({
    required this.course,
    required this.isSelected,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDarkMode = Provider.of<ThemeNotifier>(context).isDarkMode;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xff324eaf) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Checkbox(
            value: isSelected,
            onChanged: onChanged,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            activeColor: isDarkMode ? Colors.white : const Color(0xFF324EAF),
            checkColor: isDarkMode ? Colors.black : Colors.white,
          ),
          const SizedBox(width: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              course.images,
              width: screenWidth * 0.18, // responsif
              height: screenWidth * 0.18,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: screenWidth * 0.18,
                  height: screenWidth * 0.18,
                  color: Colors.blue,
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.broken_image,
                    color: Colors.white,
                    size: 32,
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  course.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: screenWidth < 350 ? 13 : 14,
                    color: isDarkMode ? Colors.white : const Color(0XFF324EAF),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.star, size: 16, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text(
                      '${course.rating}',
                      style: TextStyle(
                        fontSize: 12,
                        color:
                            isDarkMode ? Colors.white : const Color(0XFF324EAF),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    if (course.isBestseller) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFDFD02),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Bestseller',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color:
                                !isDarkMode
                                    ? Colors.white
                                    : const Color(0xFF324EAF),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${course.price}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: screenWidth < 350 ? 12 : 14,
              color: isDarkMode ? Colors.white : const Color(0xFF324EAF),
            ),
          ),
        ],
      ),
    );
  }
}
