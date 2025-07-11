import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projek_mobile/constants/app_text_style.dart';
import 'package:projek_mobile/models/explore_model.dart';
import 'package:projek_mobile/providers/theme_provider.dart';
import 'package:projek_mobile/screens/payment_success_screen.dart';
import 'package:projek_mobile/widgets/checkout_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentScreen extends StatefulWidget {
  final List<Course> selectedItems;
  final double promoDiscount;

  const PaymentScreen({
    super.key,
    required this.selectedItems,
    required this.promoDiscount,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int? selectedIndex;

  final List<Map<String, dynamic>> paymentMethods = [
    {'label': 'Debit/Credit Card', 'icon': Icons.credit_card},
    {'label': 'PayPal', 'iconAsset': 'assets/icons/paypal.png'},
    {'label': 'Apple Pay', 'iconAsset': 'assets/icons/applepay.png'},
    {'label': 'Google Pay', 'iconAsset': 'assets/icons/googlepay.png'},
    {'label': 'GoPay', 'iconAsset': 'assets/icons/gopay.png'},
    {'label': 'ShopeePay', 'iconAsset': 'assets/icons/shopeepay.png'},
    {'label': 'DANA', 'iconAsset': 'assets/icons/dana.png'},
    {'label': 'OVO', 'iconAsset': 'assets/icons/ovo.png'},
    {'label': 'LinkAja', 'iconAsset': 'assets/icons/linkaja.png'},
    {'label': 'i.Saku', 'iconAsset': 'assets/icons/isaku.png'},
  ];

  double get totalPrice {
    final sum = widget.selectedItems.fold<double>(0.0, (total, item) {
      final price =
          double.tryParse(item.price.replaceAll(RegExp(r'[^\d.]'), '')) ?? 0.0;
      return total + price;
    });
    return sum - widget.promoDiscount;
  }

  Future<void> _saveCancelledHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getString('purchase_history');
    final List<Map<String, dynamic>> history =
        existing != null
            ? List<Map<String, dynamic>>.from(jsonDecode(existing))
            : [];

    for (final item in widget.selectedItems) {
      final price =
          double.tryParse(item.price.replaceAll(RegExp(r'[^\d.]'), '')) ?? 0.0;

      history.add({
        'title': item.title,
        'image': item.images,
        'price': price,
        'rating': item.rating,
        'isBestseller': item.isBestseller,
        'status': 'cancelled',
      });
    }

    await prefs.setString('purchase_history', jsonEncode(history));
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeNotifier>(context).isDarkMode;

    return WillPopScope(
      onWillPop: () async {
        await _saveCancelledHistory();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Payment', style: GoogleFonts.poppins()),
          backgroundColor: const Color(0xFF324EAF),
          foregroundColor: Colors.white,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView.builder(
              itemCount: paymentMethods.length,
              padding: const EdgeInsets.only(top: 16, bottom: 100),
              itemBuilder: (context, index) {
                final method = paymentMethods[index];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = index;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        if (method['iconAsset'] != null)
                          Image.asset(
                            method['iconAsset'],
                            height: 28,
                            width: 28,
                            errorBuilder:
                                (_, __, ___) => const Icon(Icons.error_outline),
                          )
                        else
                          Icon(method['icon'], size: 26),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            method['label'],
                            style: AppTextStyles.subheading.copyWith(
                              color:
                                  isDarkMode ? Colors.white : Color(0xff324eaf),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Radio<int>(
                          value: index,
                          groupValue: selectedIndex,
                          onChanged: (value) {
                            setState(() {
                              selectedIndex = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        bottomSheet: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.grey.shade900 : Colors.white,
            border: Border(top: BorderSide(color: Colors.grey)),
          ),
          child: Row(
            children: [
              Expanded(
                child: RichText(
                  text: TextSpan(
                    text: 'Price ',
                    style: AppTextStyles.body.copyWith(
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                    children: [
                      TextSpan(
                        text: '\$${totalPrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF324EAF),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      selectedIndex != null ? Colors.green : Colors.grey,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed:
                    selectedIndex != null
                        ? () async {
                          await CheckoutHandler.handleCheckout(
                            context,
                            widget.selectedItems,
                            widget.promoDiscount,
                          );

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PaymentSuccessScreen(),
                            ),
                          );
                        }
                        : null,
                child: Text(
                  'Pay Now',
                  style: AppTextStyles.button.copyWith(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
