import 'package:flutter/material.dart';
import 'package:projek_mobile/constants/app_text_style.dart';
import 'package:projek_mobile/screens/sign_in.dart';
import 'package:projek_mobile/screens/sign_up.dart';

class LoginTabBar extends StatelessWidget {
  final bool isSignIn;
  const LoginTabBar({super.key, required this.isSignIn});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                TextButton(
                  onPressed: () {
                    if (!isSignIn) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => SignIn()),
                      );
                    }
                  },
                  child: Text(
                    'Sign In',
                    style: AppTextStyles.subheading.copyWith(
                      color: isSignIn ? Color(0xff3df96a) : Color(0xff324eaf),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 13),
                  child:
                      (isSignIn)
                          ? Container(height: 3, color: Color(0xff3df96a))
                          : SizedBox(),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUp()),
                    );
                  },
                  child: Text(
                    'Sign Up',
                    style: AppTextStyles.subheading.copyWith(
                      color: !isSignIn ? Color(0xff3df96a) : Color(0xff324eaf),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 13),
                  child:
                      (!isSignIn)
                          ? Container(height: 3, color: Color(0xff3df96a))
                          : SizedBox(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
