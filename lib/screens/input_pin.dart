import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'package:projek_mobile/constants/app_text_style.dart';
import 'package:projek_mobile/providers/pin_provider.dart';
import 'package:projek_mobile/l10n/app_localizations.dart';
import 'package:projek_mobile/widgets/custom_button.dart';
import 'package:projek_mobile/widgets/custom_textfield.dart';
import 'package:provider/provider.dart';
import 'package:projek_mobile/data/auth_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:projek_mobile/screens/explore_page.dart';

class InputPin extends StatelessWidget {
  const InputPin({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SetPinProvider>(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF7A8EDA)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Row(mainAxisAlignment: MainAxisAlignment.start),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Text(
                AppLocalizations.of(context).insertPin,
                style: AppTextStyles.heading,
              ),
              const SizedBox(height: 10),
              Text(
                AppLocalizations.of(context).pinDescription,
                style: GoogleFonts.poppins(color: const Color(0xff324EAF)),
              ),
              const SizedBox(height: 80),
              Center(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.blue[800],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.lock,
                        size: 100,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 60),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(4, (index) {
                        return SizedBox(
                          width: 80,
                          height: 80,
                          child: AnimatedBuilder(
                            animation: provider.pinFocusNodes[index],
                            builder: (context, _) {
                              return CustomTextField(
                                controller: provider.pinControllers[index],
                                focusNode: provider.pinFocusNodes[index],
                                keyboardType: TextInputType.number,
                                maxLength: 1,
                                textAlign: TextAlign.center,
                                textAlignVertical: TextAlignVertical.center,
                                contentPadding: const EdgeInsets.all(28),
                                inputTextStyle: AppTextStyles.heading.copyWith(
                                  fontSize: 20,
                                ),
                                obscureText:
                                    !provider.pinFocusNodes[index].hasFocus &&
                                    provider
                                        .pinControllers[index]
                                        .text
                                        .isNotEmpty,
                                obscuringCharacter: '●',
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                onChanged: (value) {
                                  provider.onPinChanged(value, index, context);
                                },
                              );
                            },
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 70),
                    CustomButton(
                      text: AppLocalizations.of(context).continueButton,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 80,
                        vertical: 5,
                      ),
                      onPressed:
                          provider.isPinComplete()
                              ? () async {
                                final entered = provider.getPin();
                                final prefs =
                                    await SharedPreferences.getInstance();
                                final email = prefs.getString('user_email');
                                final auth = AuthRepository();
                                if (email != null && email.isNotEmpty) {
                                  final user = await auth.getUserByEmail(email);
                                  final storedPin =
                                      (user ?? {})['pin'] as String? ?? '';
                                  if (storedPin.isNotEmpty &&
                                      storedPin == entered) {
                                    // Mark user as logged in for future app launches
                                    await prefs.setBool('is_logged_in', true);
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => const ExplorePage(
                                              selectedCategory: 'all',
                                            ),
                                      ),
                                    );
                                    provider.pinControllers.forEach(
                                      (controller) => controller.clear(),
                                    );
                                    return;
                                  }
                                }
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Invalid PIN.')),
                                );
                              }
                              : () {},
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
