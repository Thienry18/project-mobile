import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projek_mobile/constants/app_text_style.dart';
import 'package:projek_mobile/screens/sign_in.dart';
import 'package:projek_mobile/screens/build_profile.dart';
import 'package:projek_mobile/widgets/login_tab_bar.dart';
import 'package:projek_mobile/widgets/social_button.dart';
import 'package:projek_mobile/widgets/custom_textfield.dart';
import 'package:projek_mobile/widgets/custom_shape_clipper.dart' as clipper;
import 'package:projek_mobile/widgets/custom_button.dart';
import 'package:projek_mobile/data/auth_repository.dart';
import 'package:shared_preferences/shared_preferences.dart'; // <-- tambah ini
import 'package:firebase_auth/firebase_auth.dart';
import 'package:projek_mobile/firebase/firebase_analytics_service.dart';
import 'package:projek_mobile/l10n/app_localizations.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _agreeToTerms = false;

  final _auth = AuthRepository();

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(backgroundColor: Colors.red, content: Text(message)),
    );
  }

  void _showOk(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(backgroundColor: Colors.green, content: Text(message)),
    );
  }

  Future<void> _handleSignUp() async {
    final username = _usernameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirm = _confirmPasswordController.text;

    if (username.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirm.isEmpty) {
      _showError(AppLocalizations.of(context).fillAllFields);
      return;
    }
    if (!_auth.isValidGmail(email)) {
      _showError(AppLocalizations.of(context).emailValidation);
      return;
    }
    if (!_auth.isValidPassword(password)) {
      _showError(AppLocalizations.of(context).passwordValidation);
      return;
    }
    if (password != confirm) {
      _showError(AppLocalizations.of(context).passwordMismatch);
      return;
    }
    if (!_agreeToTerms) {
      _showError(AppLocalizations.of(context).agreeTerms);
      return;
    }

    // Track the button click
    await FirebaseAnalyticsService().trackButtonClick(
      'sign_up_button',
      extras: {'screen': 'sign_up', 'email_entered': email.isNotEmpty},
    );

    bool ok = false;
    try {
      // Try to create user with Firebase Auth first
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      ok = true;
    } on FirebaseAuthException catch (e) {
      // If email already in use on Firebase, inform user and abort
      if (e.code == 'email-already-in-use') {
        _showError(AppLocalizations.of(context).emailAlreadyRegistered);
        await FirebaseAnalyticsService().logSignUp(
          method: 'email',
          success: false,
          errorMessage: 'email-already-in-use',
        );
        return;
      }
      // Otherwise, log and allow fallback to local DB
      // ignore: avoid_print
      print('Firebase signUp error: ${e.code} ${e.message}');
    } catch (e) {
      // ignore: avoid_print
      print('Firebase signUp error: $e');
    }

    try {
      if (ok) {
        // Ensure local DB also contains this user so app flows that read local DB work
        try {
          await _auth.register(email, password);
        } catch (e) {
          // If local DB already had the user, ignore; otherwise rethrow
          if (e.toString().contains('Email already registered')) {
            // ignore
          } else {
            rethrow;
          }
        }
      } else {
        // Fallback to local registration when Firebase wasn't used/successful
        await _auth.register(email, password);
      }

      // Save username and email into SharedPreferences for later steps
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_username', username);
      await prefs.setString('user_email', email.toLowerCase());
      await prefs.setBool('is_logged_in', true);

      await FirebaseAnalyticsService().logSignUp(
        method: 'email',
        success: true,
      );

      _showOk(AppLocalizations.of(context).registrationSuccessful);
      // if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const BuildProfile()),
      );
    } catch (e) {
      await FirebaseAnalyticsService().logSignUp(
        method: 'email',
        success: false,
        errorMessage: e.toString(),
      );
      _showError(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                ClipPath(
                  clipper: clipper.CustomShapeClipper(),
                  child: Container(height: 300, color: Colors.blue[800]),
                ),
              ],
            ),
            Center(
              child: Text(
                AppLocalizations.of(context).signUp,
                style: AppTextStyles.heading,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                AppLocalizations.of(context).signUpDescription,
                style: AppTextStyles.subheading,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 32),
            const LoginTabBar(isSignIn: false),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
              child: Column(
                children: [
                  CustomTextField(
                    controller: _usernameController,
                    labelText: AppLocalizations.of(context).enterUsername,
                    prefixIcon: const Icon(Icons.person, color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _emailController,
                    labelText: AppLocalizations.of(context).enterEmail,
                    prefixIcon: const Icon(
                      Icons.email_outlined,
                      color: Colors.white,
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _passwordController,
                    labelText: AppLocalizations.of(context).enterPassword,
                    prefixIcon: const Icon(
                      Icons.lock_outline,
                      color: Colors.white,
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _confirmPasswordController,
                    labelText: AppLocalizations.of(context).reEnterPassword,
                    prefixIcon: const Icon(
                      Icons.lock_outline,
                      color: Colors.white,
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Checkbox(
                        value: _agreeToTerms,
                        onChanged: (bool? value) {
                          setState(() {
                            _agreeToTerms = value ?? false;
                          });
                          FirebaseAnalyticsService().trackButtonClick(
                            'agree_terms_toggled',
                            extras: {
                              'screen': 'sign_up',
                              'value': _agreeToTerms,
                            },
                          );
                        },
                        fillColor: WidgetStateProperty.resolveWith<Color>((
                          states,
                        ) {
                          if (states.contains(WidgetState.selected)) {
                            return const Color(0xFF324eaf);
                          }
                          return const Color(0xFFE3E8FB);
                        }),
                        side:
                            _agreeToTerms
                                ? const BorderSide(
                                  color: Color(0xff324eaf),
                                  width: 2,
                                )
                                : const BorderSide(color: Colors.transparent),
                        checkColor: Colors.white,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            style: AppTextStyles.body,
                            children: [
                              TextSpan(
                                text:
                                    AppLocalizations.of(
                                      context,
                                    ).agreeToTermsText,
                              ),
                              TextSpan(
                                text:
                                    AppLocalizations.of(context).termsOfService,
                                style: GoogleFonts.poppins(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              TextSpan(text: AppLocalizations.of(context).and),
                              TextSpan(
                                text:
                                    AppLocalizations.of(context).privacyPolicy,
                                style: GoogleFonts.poppins(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  CustomButton(
                    text: 'Sign Up',
                    onPressed: _handleSignUp,
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 70,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppLocalizations.of(context).alreadyHaveAccount,
                        style: AppTextStyles.body,
                      ),
                      InkWell(
                        onTap: () async {
                          await FirebaseAnalyticsService().trackButtonClick(
                            'go_to_sign_in',
                            extras: {'screen': 'sign_up'},
                          );
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignIn(),
                            ),
                          );
                        },
                        child: Text("Sign In", style: AppTextStyles.link),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const SocialButton(screen: 'sign_up'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
