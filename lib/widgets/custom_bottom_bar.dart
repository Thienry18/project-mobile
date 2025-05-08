import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projek_mobile/constants/app_text_style.dart';

class CustomBottomBar extends StatelessWidget {
  final double total;
  final int cartCount;
  final bool selectAll;
  final ValueChanged<bool?> onSelectAllChanged;

  const CustomBottomBar({
    super.key,
    required this.total,
    required this.cartCount,
    required this.selectAll,
    required this.onSelectAllChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Voucher Section
          Row(
            children: [
              const Icon(Icons.card_giftcard, color: Colors.blue),
              const SizedBox(width: 8),
              Text(
                'Tap to apply your voucher and enjoy the discount!',
                style: GoogleFonts.poppins(
                  color: Colors.blue.shade700,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Bottom Cart Actions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Checkbox(
                value: selectAll,
                onChanged: onSelectAllChanged,
                activeColor: const Color(0xFF324EAF),
              ),
              Row(
                children: [
                  Text("Total ", style: AppTextStyles.body),
                  Text(
                    "\$$total",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {},
                    child: Text("Checkout ($cartCount)"),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
