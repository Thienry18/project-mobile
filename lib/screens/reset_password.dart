import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projek_mobile/constants/app_text_style.dart';
import 'package:projek_mobile/providers/password_provider.dart';
import 'package:projek_mobile/widgets/custom_button.dart';
import 'package:projek_mobile/widgets/custom_textfield.dart';
import 'package:projek_mobile/widgets/password_criteria.dart';
import 'package:projek_mobile/widgets/password_strength_bar.dart';
import 'package:provider/provider.dart';
import 'package:projek_mobile/screens/password_updated.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  final FocusNode _confirmFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _confirmFocusNode.addListener(() {
      if (_confirmFocusNode.hasFocus) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _confirmFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final passwordProvider = Provider.of<PasswordProvider>(context);

    int strength = 0;
    if (passwordProvider.hasUppercase) strength++;
    if (passwordProvider.hasNumber) strength++;
    if (passwordProvider.hasMinLength) strength++;

    List<Color> barColors = List.generate(3, (index) {
      return index < strength ? Colors.green : Colors.grey.shade300;
    });

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF7A8EDA)),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/images/forgot_password.png', height: 350),
              Text('New Password', style: AppTextStyles.heading),
              const SizedBox(height: 8),
              Text(
                'Create a new password to replace your previous one.',
                textAlign: TextAlign.center,
                style: AppTextStyles.subheading.copyWith(fontSize: 10),
              ),
              const SizedBox(height: 30),
              CustomTextField(
                controller: passwordProvider.passwordController,
                onChanged: passwordProvider.onPasswordChanged,
                obscureText: _obscurePassword,
                labelText: 'Enter your password',
                prefixIcon: Icon(
                  Icons.lock_outline,
                  color: Color(0xFF7A8EDA),
                  size: 25,
                ),
                contentPadding: EdgeInsets.all(20),
                suffixIcon:
                    _obscurePassword
                        ? Icon(
                          Icons.visibility_off,
                          color: Color(0xFF7A8EDA),
                          size: 25,
                        )
                        : Icon(
                          Icons.visibility,
                          color: Color(0xFF7A8EDA),
                          size: 25,
                        ),
                onTap: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
              const SizedBox(height: 8),
              PasswordStrengthBar(
                barColors: barColors,
                isVisible: passwordProvider.passwordController.text.isNotEmpty,
              ),
              const SizedBox(height: 8),
              if (passwordProvider.passwordController.text.isNotEmpty)
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    passwordProvider.getPasswordStrengthText(),
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.green,
                    ),
                  ),
                ),
              const SizedBox(height: 8),
              if (passwordProvider.passwordController.text.isNotEmpty)
                PasswordCriteria(
                  hasUppercase: passwordProvider.hasUppercase,
                  hasNumber: passwordProvider.hasNumber,
                  hasMinLength: passwordProvider.hasMinLength,
                ),
              const SizedBox(height: 10),
              CustomTextField(
                focusNode: _confirmFocusNode,
                controller: passwordProvider.confirmPasswordController,
                onChanged: passwordProvider.onConfirmPasswordChanged,
                obscureText: _obscureConfirmPassword,
                labelText: 'Re-enter your password',
                prefixIcon: Icon(
                  Icons.lock_outline,
                  color: Color(0xFF7A8EDA),
                  size: 25,
                ),
                contentPadding: EdgeInsets.all(20),
                suffixIcon:
                    _obscureConfirmPassword
                        ? Icon(
                          Icons.visibility_off,
                          color: Color(0xFF7A8EDA),
                          size: 25,
                        )
                        : Icon(
                          Icons.visibility,
                          color: Color(0xFF7A8EDA),
                          size: 25,
                        ),
                onTap: () {
                  setState(() {
                    _obscureConfirmPassword = !_obscureConfirmPassword;
                  });
                },
              ),
              const SizedBox(height: 5),
              if (_confirmFocusNode.hasFocus &&
                  passwordProvider.confirmPasswordController.text.isNotEmpty &&
                  passwordProvider.passwordController.text !=
                      passwordProvider.confirmPasswordController.text)
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Both passwords must match.',
                    style: TextStyle(fontSize: 12, color: Colors.green),
                  ),
                ),
              const SizedBox(height: 30),
              SizedBox(
                width: 300,
                height: 50,
                child: CustomButton(
                  text: "Change Password",
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PasswordUpdated(),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
