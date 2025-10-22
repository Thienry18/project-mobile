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
      _showError("Please fill in all fields.");
      return;
    }
    if (!_auth.isValidGmail(email)) {
      _showError("Email must be a valid @gmail.com address.");
      return;
    }
    if (!_auth.isValidPassword(password)) {
      _showError(
        "Password must be at least 8 chars and include uppercase, lowercase, and a symbol.",
      );
      return;
    }
    if (password != confirm) {
      _showError("Passwords do not match.");
      return;
    }
    if (!_agreeToTerms) {
      _showError("You must agree to the Terms and Privacy Policy.");
      return;
    }

    try {
      await _auth.register(email, password);

      // Save username and email into SharedPreferences for later steps
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_username', username);
      await prefs.setString('user_email', email.toLowerCase());

      _showOk("Registration successful. Continue to build your profile.");
      // if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const BuildProfile()),
      );
    } catch (e) {
      print("fuck");
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
            Center(child: Text("Sign Up", style: AppTextStyles.heading)),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                "Registration with your email and sign up to continue using our app.",
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
                    labelText: 'Enter your username',
                    prefixIcon: const Icon(Icons.person, color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _emailController,
                    labelText: 'Enter your email',
                    prefixIcon: const Icon(
                      Icons.email_outlined,
                      color: Colors.white,
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _passwordController,
                    labelText: 'Enter your password',
                    prefixIcon: const Icon(
                      Icons.lock_outline,
                      color: Colors.white,
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _confirmPasswordController,
                    labelText: 'Re-enter your password',
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
                              const TextSpan(
                                text:
                                    'By creating this account, I acknowledge that I have read and agree to the ',
                              ),
                              TextSpan(
                                text: 'Terms of Service',
                                style: GoogleFonts.poppins(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              const TextSpan(text: ' and '),
                              TextSpan(
                                text: 'Privacy Policy',
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
                        "Already have an account?  ",
                        style: AppTextStyles.body,
                      ),
                      InkWell(
                        onTap: () {
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
                  const SocialButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
