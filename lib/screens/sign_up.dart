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
  bool _agreeToTerms = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
            Center(
              child: Text(
                "Registration with your email and sign up to continue using our app.",
                style: AppTextStyles.subheading,
              ),
            ),
            SizedBox(height: 32),
            LoginTabBar(isSignIn: false),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
              child: Column(
                children: [
                  CustomTextField(
                    labelText: 'Enter your username',
                    prefixIcon: Icon(Icons.person, color: Color(0xFF7A8EDA)),
                  ),
                  SizedBox(height: 16),
                  CustomTextField(
                    labelText: 'Enter your email',
                    prefixIcon: Icon(
                      Icons.email_outlined,
                      color: Color(0xFF7A8EDA),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 16),
                  CustomTextField(
                    labelText: 'Enter your password',
                    prefixIcon: Icon(
                      Icons.lock_outline,
                      color: Color(0xFF7A8EDA),
                    ),
                    obscureText: true,
                  ),
                  SizedBox(height: 16),
                  CustomTextField(
                    labelText: 'Re-enter your password',
                    prefixIcon: Icon(
                      Icons.lock_outline,
                      color: Color(0xFF7A8EDA),
                    ),
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
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => BuildProfile()),
                      );
                    },
                    padding: const EdgeInsets.symmetric(
                      vertical: 18,
                      horizontal: 80,
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
