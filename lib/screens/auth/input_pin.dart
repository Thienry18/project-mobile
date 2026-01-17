import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:projek_mobile/constants/app_text_style.dart';
import 'package:projek_mobile/providers/pin_provider.dart';
import 'package:projek_mobile/widgets/custom_button.dart';
import 'package:projek_mobile/widgets/custom_textfield.dart';
import 'package:provider/provider.dart';
import 'package:projek_mobile/data/auth_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:projek_mobile/screens/explore_page.dart';
import 'package:projek_mobile/services/awesome_notification_service.dart';
import 'package:projek_mobile/data/sync_service.dart';

class InputPin extends StatefulWidget {
  const InputPin({super.key});

  @override
  State<InputPin> createState() => _InputPinState();
}

class _InputPinState extends State<InputPin> {
  @override
  void initState() {
    super.initState();
    // Ensure local DB is synchronized from Firestore before user enters PIN.
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        await SyncService.syncCurrentUserFromFirestore();
      } catch (_) {}
      final provider = Provider.of<SetPinProvider>(context, listen: false);
      provider.clearAll();
    });
  }

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
        title: Row(mainAxisAlignment: MainAxisAlignment.start),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Text('Input Your PIN', style: AppTextStyles.heading),
              const SizedBox(height: 10),
              Text(
                'Enter your PIN to verify your identity and securely access your account.',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: const Color(0xff324EAF),
                ),
              ),
              const SizedBox(height: 80),
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
                    const SizedBox(height: 60),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(4, (index) {
                        return SizedBox(
                          width: 80,
                          height: 80,
                          child: AnimatedBuilder(
                            animation: provider.pinFocusNodes[index],
                            builder: (context, _) {
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
                        vertical: 5,
                      ),
                      onPressed:
                          provider.isPinComplete()
                              ? () async {
                                final entered = provider.getPin().trim();
                                // Prefer server-side stored PIN when user is authenticated
                                final uid =
                                    FirebaseAuth.instance.currentUser?.uid;
                                String storedPin = '';
                                if (uid != null) {
                                  try {
                                    final doc =
                                        await FirebaseFirestore.instance
                                            .collection('users')
                                            .doc(uid)
                                            .get();
                                    final dyn = doc.data()?['pin'];
                                    storedPin =
                                        dyn != null
                                            ? dyn.toString().trim()
                                            : '';
                                  } catch (_) {}
                                }

                                if (storedPin.isEmpty) {
                                  // Fallback to local DB using saved user_email
                                  final prefs =
                                      await SharedPreferences.getInstance();
                                  final email = prefs.getString('user_email');
                                  if (email != null && email.isNotEmpty) {
                                    final auth = AuthRepository();
                                    final user = await auth.getUserByEmail(
                                      email,
                                    );
                                    final dyn = (user ?? {})['pin'];
                                    storedPin =
                                        dyn != null
                                            ? dyn.toString().trim()
                                            : '';
                                  }
                                }
                                if (storedPin.isNotEmpty &&
                                    storedPin == entered) {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => const ExplorePage(
                                            selectedCategory: 'all',
                                          ),
                                    ),
                                  );
                                  provider.clearAll();
                                  setState(() {});
                                  // Show welcome notification for returning user
                                  try {
                                    final prefs =
                                        await SharedPreferences.getInstance();
                                    final email = prefs.getString('user_email');
                                    final auth = AuthRepository();
                                    final user =
                                        (email != null && email.isNotEmpty)
                                            ? await auth.getUserByEmail(email)
                                            : null;
                                    final userName =
                                        user?['username'] as String? ?? 'User';
                                    await AwesomeNotificationService.showWelcomeNotification(
                                      userName,
                                    );
                                  } catch (_) {}
                                  return;
                                }

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Invalid PIN.')),
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
