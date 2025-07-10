import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projek_mobile/providers/theme_provider.dart';
import 'package:provider/provider.dart';
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
    final isDarkMode = Provider.of<ThemeNotifier>(context).isDarkMode;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (hasSelected && onTapVoucher != null)
          InkWell(
            onTap: onTapVoucher,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: isDarkMode ? Colors.black : Color(0xFFEDE7FF),
              child: Row(
                children: [
                  Icon(
                    Icons.local_activity_outlined,
                    color: isDarkMode ? Colors.white : Color(0XFF324EAF),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "Tap to apply your voucher and enjoy the discount!",
                      style: GoogleFonts.poppins(
                        color: isDarkMode ? Colors.white : Color(0xFF815CFF),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.black : Colors.white,
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
                    activeColor: isDarkMode ? Colors.white : Color(0xFF324EAF),
                    checkColor: isDarkMode ? Colors.black : Colors.white,
                  ),
                  Text(
                    "All",
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Color(0xff324eaf),
                    ),
                  ),
                  const Spacer(),
                  if (promoDiscount > 0)
                    Text(
                      "-\$${promoDiscount.toStringAsFixed(2)}",
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.blueAccent,
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
                            color:
                                isDarkMode ? Colors.white : Color(0XFF324EAF),
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
                      backgroundColor:
                          isDarkMode ? Colors.white : Color(0xFF00C569),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: hasSelected ? onCheckout : () {},
                    child: Text(
                      "Checkout ($cartCount)",
                      style: GoogleFonts.poppins(
                        color: isDarkMode ? Color(0xff324eaf) : Colors.white,
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
