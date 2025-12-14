import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projek_mobile/screens/add_new_card.dart';
import 'package:projek_mobile/providers/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:projek_mobile/l10n/app_localizations.dart';

class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  List<Map<String, dynamic>> savedCards = [];

  @override
  void initState() {
    super.initState();
    _loadSavedCards();
  }

  Future<void> _loadSavedCards() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('user_cards');
    if (data != null) {
      setState(() {
        savedCards = List<Map<String, dynamic>>.from(jsonDecode(data));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeNotifier>(context).isDarkMode;
    const blueColor = Color(0xFF324EAF);

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      appBar: AppBar(
        backgroundColor: blueColor,
        elevation: 0,
        title: Text(
          AppLocalizations.of(context).paymentMethods,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        leading: Tooltip(
          message: 'Back',
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue.shade200),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Text(
                      AppLocalizations.of(context).yourPaymentMethods,
                      style: GoogleFonts.poppins(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        color: blueColor,
                      ),
                    ),
                  ),
                  Column(
                    children:
                        savedCards.map((card) {
                          final cleanNumber = card['number']
                              .toString()
                              .replaceAll(' ', '');
                          final last4 = cleanNumber.substring(
                            cleanNumber.length - 4,
                          );

                          return Container(
                            color: blueColor,
                            margin: const EdgeInsets.only(bottom: 1),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              leading: Image.asset(
                                'assets/icons/mastercard.png',
                                width: 26,
                                height: 26,
                              ),
                              title: Text(
                                '${card['type']} – •••• $last4',
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13.5,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(12),
                    ),
                    child: Container(
                      color: Colors.blue.shade50,
                      child: ListTile(
                        leading: Icon(
                          Icons.add_circle_outline,
                          color: Colors.blue.shade800,
                          size: 22,
                        ),
                        title: Text(
                          AppLocalizations.of(context).addCard,
                          style: GoogleFonts.poppins(
                            color: Colors.blue.shade800,
                            fontWeight: FontWeight.w600,
                            fontSize: 13.5,
                          ),
                        ),
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AddNewCardScreen(),
                            ),
                          );
                          if (result == true) {
                            _loadSavedCards();
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
