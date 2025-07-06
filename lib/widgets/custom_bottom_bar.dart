import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:projek_mobile/constants/app_text_style.dart';

class CustomBottomBar extends StatelessWidget {
  final double total;
  final int cartCount;
  final bool selectAll;
  final ValueChanged<bool?> onSelectAllChanged;
  final VoidCallback onCheckout;
  final VoidCallback? onTapVoucher;
  final double promoDiscount;
  final String? selectedPromo;

  const CustomBottomBar({
    super.key,
    required this.total,
    required this.cartCount,
    required this.selectAll,
    required this.onSelectAllChanged,
    required this.onCheckout,
    this.onTapVoucher,
    this.promoDiscount = 0.0,
    this.selectedPromo,
  });

  @override
  Widget build(BuildContext context) {
    final finalTotal = total - promoDiscount;
    final hasSelected = cartCount > 0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (hasSelected && onTapVoucher != null)
          InkWell(
            onTap: onTapVoucher,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: const Color(0xFFEDE7FF),
              child: Row(
                children: [
                  Icon(Icons.local_activity_outlined, color: Color(0XFF324EAF)),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "Tap to apply your voucher and enjoy the discount!",
                      style: GoogleFonts.poppins(color: Color(0xFF815CFF)),
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
                    onChanged: onSelectAllChanged,
                    activeColor: const Color(0xFF324EAF),
                  ),
                  const Text("All"),
                  const Spacer(),
                  if (promoDiscount > 0)
                    Text(
                      "-\$${promoDiscount.toStringAsFixed(2)}",
                      style: const TextStyle(
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.w700,
                      ),
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
                          "Total: \$${hasSelected ? finalTotal.toStringAsFixed(2) : '0.00'}",
                          style: GoogleFonts.poppins(
                            color: Color(0XFF324EAF),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (promoDiscount > 0 && selectedPromo != null)
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
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: hasSelected ? onCheckout : null,
                    child: Text(
                      "Checkout ($cartCount)",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
