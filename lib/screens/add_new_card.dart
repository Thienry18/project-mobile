import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projek_mobile/providers/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:projek_mobile/l10n/app_localizations.dart';

class AddNewCardScreen extends StatefulWidget {
  const AddNewCardScreen({super.key});

  @override
  State<AddNewCardScreen> createState() => _AddNewCardScreenState();
}

class _AddNewCardScreenState extends State<AddNewCardScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController cardNumberController = TextEditingController(
    text: '1179 7571 2931 2102',
  );
  final TextEditingController expiryController = TextEditingController(
    text: '11/30',
  );
  final TextEditingController cvvController = TextEditingController(
    text: '203',
  );

  bool saveCard = false;

  Future<void> _saveCardAndReturn() async {
    if (_formKey.currentState!.validate()) {
      final prefs = await SharedPreferences.getInstance();

      final newCardNumber = cardNumberController.text.trim().replaceAll(
        ' ',
        '',
      );

      final newCard = {
        'type': 'MasterCard',
        'number': cardNumberController.text.trim(),
        'expiry': expiryController.text.trim(),
        'cvv': cvvController.text.trim(),
        'isMastercard': true,
      };

      final existing = prefs.getString('user_cards');
      List<Map<String, dynamic>> cardList = [];

      if (existing != null) {
        cardList = List<Map<String, dynamic>>.from(jsonDecode(existing));

        final isDuplicate = cardList.any((card) {
          final existingNumber = card['number'].toString().replaceAll(' ', '');
          return existingNumber == newCardNumber;
        });

        if (isDuplicate) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context).cardAlreadyAdded),
              duration: const Duration(seconds: 3),
            ),
          );
          return;
        }
      }

      cardList.add(newCard);
      await prefs.setString('user_cards', jsonEncode(cardList));

      if (!mounted) return;
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    const blueColor = Color(0xFF324EAF);
    const greenColor = Color(0xFF4CAF50);
    const textColor = Color(0xFF292D32);
    final isDarkMode = Provider.of<ThemeNotifier>(context).isDarkMode;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      appBar: AppBar(
        backgroundColor: blueColor,
        title: Text(
          AppLocalizations.of(context).addNewCard,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: Colors.white,
            fontSize: 18,
          ),
        ),
        leading: const BackButton(color: Colors.white),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 180,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: blueColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(150),
                      bottomRight: Radius.circular(150),
                    ),
                  ),
                ),
                Positioned(
                  top: 40,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Image.asset(
                      'assets/images/wallet.png',
                      height: 200,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 60),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context).cardNumber,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: isDarkMode ? Colors.white : textColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: cardNumberController,
                            validator:
                                (value) =>
                                    value!.isEmpty
                                        ? AppLocalizations.of(
                                          context,
                                        ).enterCardNumber
                                        : null,
                            style: GoogleFonts.poppins(
                              color: isDarkMode ? Colors.white : blueColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                            decoration: const InputDecoration(
                              border: UnderlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Image.asset(
                          'assets/icons/mastercard.jpeg',
                          height: 24,
                          width: 24,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppLocalizations.of(context).expiryDate,
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: isDarkMode ? Colors.white : textColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              TextFormField(
                                controller: expiryController,
                                validator:
                                    (value) =>
                                        value!.isEmpty
                                            ? AppLocalizations.of(
                                              context,
                                            ).enterExpiryDate
                                            : null,
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: isDarkMode ? Colors.white : blueColor,
                                ),
                                decoration: const InputDecoration(
                                  border: UnderlineInputBorder(),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppLocalizations.of(context).cvvLabel,
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: isDarkMode ? Colors.white : textColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              TextFormField(
                                controller: cvvController,
                                validator:
                                    (value) =>
                                        value!.isEmpty
                                            ? AppLocalizations.of(
                                              context,
                                            ).enterCVV
                                            : null,
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: isDarkMode ? Colors.white : blueColor,
                                ),
                                decoration: const InputDecoration(
                                  border: UnderlineInputBorder(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Checkbox(
                          value: saveCard,
                          activeColor: isDarkMode ? Colors.white : blueColor,
                          checkColor: isDarkMode ? Colors.black : Colors.white,
                          onChanged: (value) {
                            setState(() {
                              saveCard = value ?? false;
                            });
                          },
                        ),
                        Expanded(
                          child: Text(
                            AppLocalizations.of(context).saveCardDetails,
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: isDarkMode ? Colors.white : blueColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: greenColor,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: _saveCardAndReturn,
                        child: Text(
                          AppLocalizations.of(context).addCard,
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
