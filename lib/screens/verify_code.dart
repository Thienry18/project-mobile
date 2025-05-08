import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projek_mobile/constants/app_text_style.dart';
import 'package:projek_mobile/providers/verify_code_provider.dart';
import 'package:projek_mobile/screens/reset_password.dart';
import 'package:projek_mobile/widgets/custom_button.dart';
import 'package:projek_mobile/widgets/custom_textfield.dart';
import 'package:provider/provider.dart';

class VerifyCode extends StatelessWidget {
  final String email;

  const VerifyCode({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Consumer<VerifyCodeProvider>(
          builder: (context, provider, _) {
            return Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Color(0xFF7A8EDA),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/images/forgot_password.png',
                          height: 350,
                        ),
                        Text(
                          'Verify Code',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.heading,
                        ),
                        const SizedBox(height: 4),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'Submit the code that was sent to ',
                                style: AppTextStyles.subheading,
                              ),
                              TextSpan(
                                text: email,
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.green,
                                ),
                              ),
                              TextSpan(
                                text: ' to verify your identity.',
                                style: AppTextStyles.subheading,
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 18),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: List.generate(6, (index) {
                            return SizedBox(
                              width: 60,
                              height: 60,
                              child: CustomTextField(
                                controller: provider.controllers[index],
                                focusNode: provider.focusNodes[index],
                                keyboardType: TextInputType.number,
                                maxLength: 1,
                                textAlign: TextAlign.center,
                                textAlignVertical: TextAlignVertical.center,
                                contentPadding: const EdgeInsets.all(20),
                                inputTextStyle: AppTextStyles.subheading
                                    .copyWith(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                    ),
                                onChanged: (value) {
                                  provider.onCodeChanged(value, index, context);
                                },
                              ),
                            );
                          }),
                        ),
                        const SizedBox(height: 28),
                        CustomButton(
                          text: "Submit",
                          padding: const EdgeInsets.symmetric(
                            horizontal: 80,
                            vertical: 18,
                          ),
                          onPressed:
                              provider.isCodeComplete()
                                  ? () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => const ResetPassword(),
                                      ),
                                    );
                                  }
                                  : () {},
                        ),
                        const SizedBox(height: 60),
                        Text(
                          "Haven't received the code ?",
                          style: GoogleFonts.poppins(
                            color: const Color(0xff7A8EDA),
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 3),
                        InkWell(
                          onTap: () {},
                          child: Text("Resend code", style: AppTextStyles.link),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
