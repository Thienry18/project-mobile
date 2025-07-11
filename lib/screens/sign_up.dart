import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projek_mobile/constants/app_text_style.dart';
import 'package:projek_mobile/screens/build_profile.dart';
import 'package:projek_mobile/screens/sign_in.dart';
import 'package:projek_mobile/widgets/login_tab_bar.dart';
import 'package:projek_mobile/widgets/social_button.dart';
import 'package:projek_mobile/widgets/custom_textfield.dart';
import 'package:projek_mobile/widgets/custom_shape_clipper.dart' as clipper;
import 'package:projek_mobile/widgets/custom_button.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _agreeToTerms = false;

  void _handleSignUp() {
    String username = _usernameController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();

    if (username.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      _showError("Please fill in all fields.");
      return;
    }

    if (password != confirmPassword) {
      _showError("Passwords do not match.");
      return;
    }

    if (!_agreeToTerms) {
      _showError("You must agree to the Terms and Privacy Policy.");
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BuildProfile()),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
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
            SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                "Registration with your email and sign up to continue using our app.",
                style: AppTextStyles.subheading,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 32),
            LoginTabBar(isSignIn: false),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
              child: Column(
                children: [
                  CustomTextField(
                    controller: _usernameController,
                    labelText: 'Enter your username',
                    prefixIcon: Icon(Icons.person, color: Colors.white),
                  ),
                  SizedBox(height: 16),
                  CustomTextField(
                    controller: _emailController,
                    labelText: 'Enter your email',
                    prefixIcon: Icon(Icons.email_outlined, color: Colors.white),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 16),
                  CustomTextField(
                    controller: _passwordController,
                    labelText: 'Enter your password',
                    prefixIcon: Icon(Icons.lock_outline, color: Colors.white),
                    obscureText: true,
                  ),
                  SizedBox(height: 16),
                  CustomTextField(
                    controller: _confirmPasswordController,
                    labelText: 'Re-enter your password',
                    prefixIcon: Icon(Icons.lock_outline, color: Colors.white),
                    obscureText: true,
                  ),
                  SizedBox(height: 12),
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
                            return Color(0xFF324eaf);
                          }
                          return Color(0xFFE3E8FB);
                        }),
                        side:
                            _agreeToTerms
                                ? BorderSide(color: Color(0xff324eaf), width: 2)
                                : BorderSide(color: Colors.transparent),
                        checkColor: Colors.white,
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            style: AppTextStyles.body,
                            children: [
                              TextSpan(
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
                              TextSpan(text: ' and '),
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
                  SizedBox(height: 32),
                  CustomButton(
                    text: 'Sign Up',
                    onPressed: _handleSignUp,
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 70,
                    ),
                  ),
                  SizedBox(height: 24),
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SignIn()),
                          );
                        },
                        child: Text("Sign In", style: AppTextStyles.link),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  SocialButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
