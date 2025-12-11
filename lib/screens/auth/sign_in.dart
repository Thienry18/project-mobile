// ...existing code from ../sign_in.dart...
import 'package:flutter/material.dart';
import 'package:projek_mobile/constants/app_text_style.dart';
import 'package:projek_mobile/screens/auth/input_pin.dart';
import 'package:projek_mobile/screens/auth/sign_up.dart';
import 'package:projek_mobile/screens/auth/forgot_password.dart';
import 'package:projek_mobile/widgets/login_tab_bar.dart';
import 'package:projek_mobile/widgets/social_button.dart';
import 'package:projek_mobile/widgets/custom_textfield.dart';
import 'package:projek_mobile/widgets/custom_shape_clipper.dart' as clipper;
import 'package:projek_mobile/widgets/custom_button.dart';
import 'package:projek_mobile/data/auth_repository.dart';
import 'package:projek_mobile/firebase/firebase_analytics_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool _agreeToTerms = false; // dipakai sebagai "Remember Me" visual
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _auth = AuthRepository();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(backgroundColor: Colors.red, content: Text(msg)));
  }

  Future<void> _handleSignIn() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      _showError('Email and password must not be empty.');
      return;
    }

    // Track the button click
    await FirebaseAnalyticsService().trackButtonClick(
      'sign_in_button',
      extras: {'screen': 'auth_sign_in', 'email_entered': email.isNotEmpty},
    );

    final ok = await _auth.verifyCredentials(email, password);
    if (!ok) {
      _showError('Invalid email or password.');
      await FirebaseAnalyticsService().logLogin(
        method: 'email',
        success: false,
      );
      return;
    }

    // Simpan email sementara; PIN verification will set 'is_logged_in'
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_email', email.toLowerCase());

    // Lanjut flow kamu ke InputPin (seperti sebelumnya)
    if (!mounted) return;
    await FirebaseAnalyticsService().logLogin(method: 'email', success: true);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const InputPin()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: screenHeight),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  Stack(
                    children: [
                      ClipPath(
                        clipper: clipper.CustomShapeClipper(),
                        child: Container(
                          width: double.infinity,
                          height: screenHeight * 0.35,
                          color: Colors.blue[800],
                        ),
                      ),
                      Positioned(
                        left: screenWidth * 0.1,
                        child: Image.asset(
                          "assets/images/finger_print.png",
                          width: screenWidth * 0.8,
                          height: screenWidth * 0.8,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Center(child: Text("Welcome!", style: AppTextStyles.heading)),
                  const SizedBox(height: 8),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        "To keep connected with us please sign in with your personal info.",
                        style: AppTextStyles.subheading,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  const LoginTabBar(isSignIn: true),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 30,
                    ),
                    child: Column(
                      children: [
                        CustomTextField(
                          labelText: 'Enter your email',
                          prefixIcon: const Icon(
                            Icons.email_outlined,
                            color: Colors.white,
                          ),
                          keyboardType: TextInputType.emailAddress,
                          controller: _emailController,
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          labelText: 'Enter your password',
                          prefixIcon: const Icon(
                            Icons.lock_outline,
                            color: Colors.white,
                          ),
                          obscureText: true,
                          controller: _passwordController,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Checkbox(
                              value: _agreeToTerms,
                              onChanged: (bool? value) {
                                setState(() {
                                  _agreeToTerms = value ?? false;
                                });
                                FirebaseAnalyticsService().trackButtonClick(
                                  'remember_me_toggled',
                                  extras: {
                                    'screen': 'auth_sign_in',
                                    'value': _agreeToTerms,
                                  },
                                );
                              },
                              fillColor: WidgetStateProperty.resolveWith<Color>(
                                (states) {
                                  if (states.contains(WidgetState.selected)) {
                                    return const Color(0xFF324eaf);
                                  }
                                  return const Color(0xFFE3E8FB);
                                },
                              ),
                              side:
                                  _agreeToTerms
                                      ? const BorderSide(
                                        color: Color(0xff324eaf),
                                        width: 2,
                                      )
                                      : const BorderSide(
                                        color: Colors.transparent,
                                      ),
                              checkColor: Colors.white,
                            ),
                            Expanded(
                              child: Text(
                                'Remember Me',
                                style: AppTextStyles.body,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                FirebaseAnalyticsService().trackButtonClick(
                                  'forgot_password',
                                  extras: {'screen': 'auth_sign_in'},
                                );
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ForgotPassword(),
                                  ),
                                );
                              },
                              child: Text(
                                "Forgot Password?",
                                style: AppTextStyles.body.copyWith(
                                  decoration: TextDecoration.underline,
                                  decorationColor: const Color(0xff97a4d8),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        CustomButton(
                          text: 'Sign In',
                          onPressed: _handleSignIn,
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 70,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have an account?  ",
                              style: AppTextStyles.body,
                            ),
                            InkWell(
                              onTap: () {
                                FirebaseAnalyticsService().trackButtonClick(
                                  'go_to_sign_up',
                                  extras: {'screen': 'auth_sign_in'},
                                );
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SignUp(),
                                  ),
                                );
                              },
                              child: Text("Sign Up", style: AppTextStyles.link),
                            ),
                          ],
                        ),
                        const SizedBox(height: 34),
                        const SocialButton(screen: 'auth_sign_in'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
