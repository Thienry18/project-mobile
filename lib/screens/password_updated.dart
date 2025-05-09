import 'package:flutter/material.dart';
import 'package:projek_mobile/constants/app_text_style.dart';
import 'package:projek_mobile/screens/sign_in.dart';
import 'package:projek_mobile/widgets/custom_button.dart';

class PasswordUpdated extends StatelessWidget {
  const PasswordUpdated({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF7A8EDA)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('images/gif/password_security.gif'),
              const SizedBox(height: 30),
              Text('Password Updated!', style: AppTextStyles.heading),
              const SizedBox(height: 16),
              Text(
                'Your password has been changed successfully. We’ll notify you\nif we detect any further issues with your account',
                textAlign: TextAlign.center,
                style: AppTextStyles.subheading,
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: 285,
                child: CustomButton(
                  text: 'Sign in with new password',
                  icon: Icons.arrow_forward,
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => SignIn()),
                    );
                  },
                  padding: const EdgeInsets.symmetric(vertical: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
