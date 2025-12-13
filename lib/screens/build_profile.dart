import 'package:flutter/material.dart';
import 'package:projek_mobile/constants/app_text_style.dart';
import 'package:projek_mobile/models/user_profile.dart';
import 'package:projek_mobile/screens/interest.dart';
import 'package:projek_mobile/widgets/build_step_circle.dart';
import 'package:projek_mobile/widgets/custom_textfield.dart';
import 'package:projek_mobile/widgets/gender_picker.dart';
import 'package:projek_mobile/widgets/profile_image.dart';
import 'package:projek_mobile/widgets/custom_button.dart';
import 'package:country_picker/country_picker.dart';
import 'package:projek_mobile/data/user_profile_repository.dart';
import 'package:projek_mobile/database/database_service.dart';
import 'package:projek_mobile/database/database_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BuildProfile extends StatefulWidget {
  const BuildProfile({super.key});

  @override
  _BuildProfile createState() => _BuildProfile();
}

class _BuildProfile extends State<BuildProfile> {
  String username = '';
  String fullName = '';
  String dob = '';
  String gender = '';
  String phoneNumber = '';
  String country = '';

  Future<void> _handleContinue() async {
    if (username.isEmpty ||
        fullName.isEmpty ||
        dob.isEmpty ||
        gender.isEmpty ||
        phoneNumber.isEmpty ||
        country.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all fields.')),
      );
      return;
    }

    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Not authenticated — please sign in first.'),
        ),
      );
      return;
    }

    // Debug: print current auth uid before writing to Firestore
    // ignore: avoid_print
    print('Attempting Firestore write for uid=${firebaseUser.uid}');
    final repo = UserProfileRepository();
    final profile = UserProfile(
      uid: firebaseUser.uid,
      username: username,
      fullName: fullName,
      dob: dob,
      gender: gender,
      phoneNumber: phoneNumber,
      country: country,
    );

    try {
      await repo.createProfile(profile);
    } catch (e, st) {
      // Surface Firestore errors for debugging and abort navigation
      // ignore: avoid_print
      print('Firestore createProfile error: $e');
      // ignore: avoid_print
      print(st);
      if (e is FirebaseException && e.code == 'permission-denied') {
        try {
          final db = await DatabaseService.instance.database;
          final email = FirebaseAuth.instance.currentUser?.email ?? '';
          await DatabaseUser.insertUser(db, {
            'email': email,
            'password': '',
            'username': username,
            'fullname': fullName,
            'day_of_birth': dob,
            'gender': gender,
            'phone_number': phoneNumber,
            'country': country,
            'avatar_path': '',
          });
          try {
            await DatabaseService.instance.emitUsers();
          } catch (_) {}
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profile saved locally (Firestore not available).'),
            ),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const Interest()),
          );
          return;
        } catch (dbErr) {
          // ignore: avoid_print
          print('Local DB fallback failed: $dbErr');
          if (mounted)
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Failed to save locally as fallback: $dbErr'),
              ),
            );
          return;
        }
      }
      if (mounted)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to write profile to Firestore: $e')),
        );
      return;
    }

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Interest()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Row(
          children: [
            BuildStepCircle(isActive: true),
            BuildStepCircle(isActive: false),
            BuildStepCircle(isActive: false),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: screenHeight - kToolbarHeight - 40,
            ),
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.buildYourProfile, style: AppTextStyles.heading),
                  const SizedBox(height: 10),
                  Text(l10n.descBuildProfile, style: AppTextStyles.subheading),
                  const SizedBox(height: 20),
                  const Center(child: ProfileImage()),
                  const SizedBox(height: 25),

                  CustomTextField(
                    prefixIcon: const Icon(Icons.person, color: Colors.white),
                    hintText: l10n.username,
                    onChanged: (val) => setState(() => username = val),
                  ),
                  const SizedBox(height: 15),

                  CustomTextField(
                    prefixIcon: const Icon(Icons.badge, color: Colors.white),
                    hintText: l10n.fullName,
                    onChanged: (val) => setState(() => fullName = val),
                  ),
                  const SizedBox(height: 15),

                  CustomTextField(
                    prefixIcon: const Icon(
                      Icons.calendar_today,
                      color: Colors.white,
                    ),
                    hintText: dob.isEmpty ? l10n.dateOfBirth : dob,
                    readOnly: true,
                    suffixIcon: const Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.white,
                    ),
                    onTap: () async {
                      DateTime? date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1950),
                        lastDate: DateTime.now(),
                      );
                      if (date != null) {
                        setState(() {
                          dob = '${date.day}/${date.month}/${date.year}';
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 15),

                  GenderPicker(
                    gender: gender,
                    onChanged: (val) => setState(() => gender = val ?? ''),
                  ),
                  const SizedBox(height: 15),

                  CustomTextField(
                    prefixIcon: const Icon(Icons.phone, color: Colors.white),
                    hintText: l10n.phoneNumber,
                    onChanged: (val) => setState(() => phoneNumber = val),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 15),

                  CustomTextField(
                    prefixIcon: const Icon(Icons.public, color: Colors.white),
                    hintText: country.isEmpty ? l10n.country : country,
                    readOnly: true,
                    onTap: () {
                      showCountryPicker(
                        context: context,
                        onSelect: (c) {
                          setState(() => country = c.name);
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 30),

                  Center(
                    child: CustomButton(
                      text: l10n.continueButton,
                      onPressed: _handleContinue,
                      padding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: screenWidth * 0.2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
