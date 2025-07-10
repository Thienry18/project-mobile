import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddNewCardScreen extends StatefulWidget {
  const AddNewCardScreen({super.key});

  @override
  State<AddNewCardScreen> createState() => _AddNewCardScreenState();
}

class _AddNewCardScreenState extends State<AddNewCardScreen> {
  bool saveCard = false;

  @override
  Widget build(BuildContext context) {
    const blueColor = Color(0xFF324EAF);
    const greenColor = Color(0xFF4CAF50);
    const textColor = Color(0xFF292D32);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: blueColor,
        title: Text(
          'Add New Card',
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
            // Bagian atas dengan background biru dan gambar wallet
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
                  top: 40, // posisikan sedikit keluar
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Image.asset(
                      'assets/images/wallet.png', // pastikan file ini ada
                      height: 200,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 60), // agar konten tidak ketimpa

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Card Number
                  Text(
                    'Card Number',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: textColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          initialValue: '1179 7571 2931 2102',
                          style: GoogleFonts.poppins(
                            color: blueColor,
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
                        'assets/icons/mastercard.jpeg', // logo kartu
                        height: 24,
                        width: 24,
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Expiry Date & CVV
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Expiry Date',
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: textColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            TextFormField(
                              initialValue: '11/30',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: blueColor,
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
                              'CVV',
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: textColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            TextFormField(
                              initialValue: '203',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: blueColor,
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

                  // Save Card Checkbox
                  Row(
                    children: [
                      Checkbox(
                        value: saveCard,
                        activeColor: blueColor,
                        onChanged: (value) {
                          setState(() {
                            saveCard = value ?? false;
                          });
                        },
                      ),
                      Expanded(
                        child: Text(
                          'Save this card and details for faster payments',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: blueColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Add Card Button
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
                      onPressed: () {},
                      child: Text(
                        'Add Card',
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
          ],
        ),
      ),
    );
  }
}
