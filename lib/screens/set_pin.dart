import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'package:projek_mobile/constants/app_text_style.dart';
import 'package:projek_mobile/providers/pin_provider.dart';
import 'package:projek_mobile/screens/success.dart';
import 'package:projek_mobile/widgets/build_step_circle.dart';
import 'package:projek_mobile/widgets/custom_button.dart';
import 'package:projek_mobile/widgets/custom_textfield.dart';
import 'package:provider/provider.dart';

class SetPinScreen extends StatelessWidget {
  const SetPinScreen({super.key});

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
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            BuildStepCircle(isActive: true),
            BuildStepCircle(isActive: true),
            BuildStepCircle(isActive: true),
          ],
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Text('Set Your PIN', style: AppTextStyles.heading),
              const SizedBox(height: 8),
              Text(
                'Set a secure PIN to protect your account and ensure only you can access it.',
                style: GoogleFonts.poppins(color: const Color(0xff324EAF)),
              ),
              const SizedBox(height: 30),
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
                    const SizedBox(height: 50),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(4, (index) {
                        return SizedBox(
                          width: 80,
                          height: 80,
                          child: StatefulBuilder(
                            builder: (context, setState) {
                              provider.pinFocusNodes[index].addListener(() {
                                setState(() {});
                              });

                              return CustomTextField(
                                controller: provider.pinControllers[index],
                                focusNode: provider.pinFocusNodes[index],
                                keyboardType: TextInputType.number,
                                maxLength: 1,
                                textAlign: TextAlign.center,
                                textAlignVertical: TextAlignVertical.center,
                                contentPadding: const EdgeInsets.all(
                                  28,
                                ), // Padding konsisten
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
                                  (context as Element).markNeedsBuild();
                                },
                              );
                            },
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 70),
                    CustomButton(
                      text: "Continue",
                      padding: const EdgeInsets.symmetric(
                        horizontal: 80,
                        vertical: 15,
                      ),
                      onPressed:
                          provider.isPinComplete()
                              ? () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const Success(),
                                  ),
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
