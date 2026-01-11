import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:projek_mobile/constants/app_text_style.dart';
import 'package:projek_mobile/providers/pin_provider.dart';
import 'package:projek_mobile/screens/auth/success.dart';
import 'package:projek_mobile/widgets/build_step_circle.dart';
import 'package:projek_mobile/widgets/custom_button.dart';
import 'package:projek_mobile/widgets/custom_textfield.dart';
import 'package:provider/provider.dart';
import 'package:projek_mobile/data/auth_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:projek_mobile/services/awesome_notification_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SetPinScreen extends StatelessWidget {
  const SetPinScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SetPinProvider>(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF7A8EDA)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            BuildStepCircle(isActive: true),
            BuildStepCircle(isActive: true),
            BuildStepCircle(isActive: true),
          ],
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Text('Set Your PIN', style: AppTextStyles.heading),
              const SizedBox(height: 8),
              Text(
                'Set a secure PIN to protect your account and ensure only you can access it.',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: const Color(0xff324EAF),
                ),
              ),
              const SizedBox(height: 30),
              Center(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.blue[800],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.lock,
                        size: 100,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 50),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(4, (index) {
                        return SizedBox(
                          width: 80,
                          height: 80,
                          child: StatefulBuilder(
                            builder: (context, setState) {
                              provider.pinFocusNodes[index].addListener(() {
                                setState(() {});
                              });

                              return CustomTextField(
                                controller: provider.pinControllers[index],
                                focusNode: provider.pinFocusNodes[index],
                                keyboardType: TextInputType.number,
                                maxLength: 1,
                                textAlign: TextAlign.center,
                                textAlignVertical: TextAlignVertical.center,
                                contentPadding: const EdgeInsets.all(28),
                                inputTextStyle: AppTextStyles.heading.copyWith(
                                  fontSize: 20,
                                ),
                                obscureText:
                                    !provider.pinFocusNodes[index].hasFocus &&
                                    provider
                                        .pinControllers[index]
                                        .text
                                        .isNotEmpty,
                                obscuringCharacter: '●',
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                onChanged: (value) {
                                  provider.onPinChanged(value, index, context);
                                  (context as Element).markNeedsBuild();
                                },
                              );
                            },
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 70),
                    CustomButton(
                      text: "Continue",
                      padding: const EdgeInsets.symmetric(
                        horizontal: 80,
                        vertical: 15,
                      ),
                      onPressed:
                          provider.isPinComplete()
                              ? () async {
                                final pin = provider.getPin();
                                final prefs =
                                    await SharedPreferences.getInstance();
                                final email = prefs.getString('user_email');
                                final auth = AuthRepository();
                                if (email != null && email.isNotEmpty) {
                                  try {
                                    await auth.updateProfile(
                                      currentEmail: email,
                                      pin: pin,
                                    );
                                    // Also persist PIN to Firestore for authenticated users
                                    try {
                                      final uid =
                                          FirebaseAuth
                                              .instance
                                              .currentUser
                                              ?.uid;
                                      if (uid != null) {
                                        await FirebaseFirestore.instance
                                            .collection('users')
                                            .doc(uid)
                                            .set({
                                              'pin': pin,
                                            }, SetOptions(merge: true));
                                      }
                                    } catch (_) {}
                                    await prefs.setBool('is_logged_in', true);
                                    // Clear PIN inputs after persisting
                                    provider.clearAll();
                                    // Show welcome notification for new user
                                    final user = await auth.getUserByEmail(
                                      email,
                                    );
                                    final userName =
                                        user?['username'] as String? ?? 'User';
                                    await AwesomeNotificationService.showWelcomeNotification(
                                      userName,
                                    );
                                  } catch (_) {
                                    // ignore errors for now
                                  }
                                }

                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const Success(),
                                  ),
                                );
                              }
                              : () {},
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
