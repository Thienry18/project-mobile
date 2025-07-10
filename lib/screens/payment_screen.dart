import 'package:flutter/material.dart';
import 'package:projek_mobile/models/explore_model.dart';
import 'package:projek_mobile/screens/payment_success_screen.dart';
import 'package:projek_mobile/widgets/checkout_handler.dart';

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
    {'label': 'Apple Pay', 'iconAsset': 'assets/icons/apple_pay.png'},
    {'label': 'Google Pay', 'iconAsset': 'assets/icons/google_pay.png'},
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
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
                          style: const TextStyle(
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
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey)),
        ),
        child: Row(
          children: [
            Expanded(
              child: RichText(
                text: TextSpan(
                  text: 'Price ',
                  style: const TextStyle(color: Colors.black),
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
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () async {
                await CheckoutHandler.handleCheckout(
                  context,
                  widget.selectedItems,
                  widget.promoDiscount,
                );

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => PaymentSuccessScreen()),
                );
              },

              child: const Text('Pay Now'),
            ),
          ],
        ),
      ),
    );
  }
}
