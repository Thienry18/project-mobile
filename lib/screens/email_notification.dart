import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/gestures.dart';
import 'package:projek_mobile/constants/app_text_style.dart';
import 'package:projek_mobile/screens/forgot_password.dart';
import 'package:projek_mobile/screens/verify_code.dart';
import 'package:projek_mobile/widgets/custom_button.dart';

class EmailNotification extends StatelessWidget {
  final String email;

  const EmailNotification({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          const SizedBox(height: 40),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('images/gif/email_sent.gif', height: 200),
                const SizedBox(height: 32),
                Text(
                  'Check Your Mailbox!',
                  style: AppTextStyles.heading.copyWith(fontSize: 30),
                ),
                const SizedBox(height: 8),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text:
                            'We have sent a password recover instructions to\n',
                        style: AppTextStyles.subheading,
                      ),
                      TextSpan(
                        text: email,
                        style: AppTextStyles.subheading.copyWith(
                          fontWeight: FontWeight.w700,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: 260,
                  child: CustomButton(
                    text: 'Verify Code',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VerifyCode(email: email),
                        ),
                      );
                    },
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 4,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: Text.rich(
              TextSpan(
                text: "Didn't receive the email? Check your spam filter,\nor ",
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  color: const Color(0xFF7A8EDA),
                  fontWeight: FontWeight.w700,
                ),
                children: [
                  TextSpan(
                    text: 'try another email address',
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: Colors.green,
                      fontWeight: FontWeight.w700,
                      decoration: TextDecoration.underline,
                    ),
                    recognizer:
                        TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ForgotPassword(),
                              ),
                            );
                          },
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
