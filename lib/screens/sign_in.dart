import 'package:flutter/material.dart';
import 'package:projek_mobile/constants/app_text_style.dart';
import 'package:projek_mobile/screens/input_pin.dart';
import 'package:projek_mobile/screens/sign_up.dart';
import 'package:projek_mobile/screens/forgot_password.dart';
import 'package:projek_mobile/widgets/login_tab_bar.dart';
import 'package:projek_mobile/widgets/social_button.dart';
import 'package:projek_mobile/widgets/custom_textfield.dart';
import 'package:projek_mobile/widgets/custom_shape_clipper.dart' as clipper;
import 'package:projek_mobile/widgets/custom_button.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool _agreeToTerms = false;

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
                  child: Container(
                    width: double.infinity,
                    height: 400,
                    color: Colors.blue[800],
                  ),
                ),
                Positioned(
                  left: 55,
                  child: Image.asset(
                    "assets/images/finger_print.png",
                    width: 420,
                    height: 420,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Center(child: Text("Welcome!", style: AppTextStyles.heading)),
            SizedBox(height: 8),
            Center(
              child: Text(
                "To keep connected with us please sign in with your personal info.",
                style: AppTextStyles.subheading,
              ),
            ),
            SizedBox(height: 32),
            LoginTabBar(isSignIn: true),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
              child: Column(
                children: [
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      Expanded(
                        child: Text(
                          '   Remember Me',
                          style: AppTextStyles.body,
                        ),
                      ),
                      InkWell(
                        onTap: () {
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
                            decorationColor: Color(0xff97a4d8),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 18),
                  CustomButton(
                    text: 'Sign In',
                    onPressed: () {
                      InputPin();
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
                        "Don't have an account?  ",
                        style: AppTextStyles.body,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => SignUp()),
                          );
                        },
                        child: Text("Sign Up", style: AppTextStyles.link),
                      ),
                    ],
                  ),
                  SizedBox(height: 34),
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
