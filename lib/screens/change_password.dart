import 'package:flutter/material.dart';
import 'package:projek_mobile/constants/app_text_style.dart';
import 'package:projek_mobile/screens/email_notification.dart';
import 'package:projek_mobile/widgets/custom_shape_clipper.dart';
import 'package:projek_mobile/widgets/custom_textfield.dart';
import 'package:projek_mobile/widgets/custom_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:projek_mobile/data/auth_repository.dart';

class ChangePassword extends StatelessWidget {
  ChangePassword({super.key});

  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                      Image.asset(
                        'assets/images/forgot_password.png',
                        height: constraints.maxWidth < 400 ? 250 : 350,
                      ),
                      Text(
                        'Change Password?',
                        style: AppTextStyles.heading.copyWith(
                          fontSize: constraints.maxWidth < 400 ? 22 : 26,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'Change your Password by submitting the email associated with your account.',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.subheading,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(30),
                        child: CustomTextField(
                          controller: _emailController,
                          labelText: 'Enter your email',
                          prefixIcon: const Icon(
                            Icons.email_outlined,
                            color: Color(0xFF7A8EDA),
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: SizedBox(
                          width: 275,
                          child: CustomButton(
                            text: 'Send Code',
                            onPressed: () async {
                              final emailInput = _emailController.text.trim();
                              final auth = AuthRepository();

                              if (!auth.isValidGmail(emailInput)) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Please use a @gmail.com email',
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                                return;
                              }

                              final prefs =
                                  await SharedPreferences.getInstance();
                              final currentEmail =
                                  prefs
                                      .getString('user_email')
                                      ?.trim()
                                      .toLowerCase();
                              if (currentEmail != null &&
                                  currentEmail.isNotEmpty) {
                                if (emailInput.toLowerCase() != currentEmail) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Entered email does not match your account',
                                      ),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                  return;
                                }
                              } else {
                                final exists = await auth.emailExists(
                                  emailInput,
                                );
                                if (!exists) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Email is not registered'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                  return;
                                }
                              }

                              await prefs.setString(
                                'user_email',
                                emailInput.toLowerCase(),
                              );

                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) =>
                                          EmailNotification(email: emailInput),
                                ),
                              );
                            },
                            padding: const EdgeInsets.symmetric(vertical: 10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Spacer(),
                      ClipPath(
                        clipper: CustomShapeClipperDown(),
                        child: Container(height: 70, color: Colors.blue[800]),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
