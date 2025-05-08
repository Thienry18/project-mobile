import 'package:flutter/material.dart';
import 'package:projek_mobile/constants/app_text_style.dart';
import 'package:projek_mobile/screens/email_notification.dart';
import 'package:projek_mobile/widgets/custom_shape_clipper.dart';
import 'package:projek_mobile/widgets/custom_textfield.dart';
import 'package:projek_mobile/widgets/custom_button.dart'; // Pastikan ini diimport

class ForgotPassword extends StatelessWidget {
  ForgotPassword({super.key});

  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Color(0xFF7A8EDA)),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            Image.asset('images/forgot_password.png', height: 350),
            Text('Forgot Password?', style: AppTextStyles.heading),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.all(4),
              child: Text(
                'Reset your password by submitting the email associated with your account.',
                textAlign: TextAlign.center,
                style: AppTextStyles.subheading,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(30),
              child: CustomTextField(
                controller: _emailController,
                labelText: 'Enter your email',
                prefixIcon: Icon(
                  Icons.email_outlined,
                  color: Color(0xFF7A8EDA),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: SizedBox(
                width: 275,
                child: CustomButton(
                  text: 'Send Code',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) =>
                                EmailNotification(email: _emailController.text),
                      ),
                    );
                  },
                  padding: const EdgeInsets.symmetric(vertical: 17),
                ),
              ),
            ),
            const Spacer(),
            ClipPath(
              clipper: CustomShapeClipperDown(),
              child: Container(height: 70, color: Colors.blue[800]),
            ),
          ],
        ),
      ),
    );
  }
}
