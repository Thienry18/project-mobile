import 'dart:convert';
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
import 'package:shared_preferences/shared_preferences.dart';

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

  void _handleContinue() async {
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

    final user = UserProfile(
      username: username,
      fullName: fullName,
      dob: dob,
      gender: gender,
      phoneNumber: phoneNumber,
      country: country,
    );

    final prefs = await SharedPreferences.getInstance();
    prefs.setString(
      'user_profile',
      jsonEncode({
        'username': user.username,
        'fullName': user.fullName,
        'dob': user.dob,
        'gender': user.gender,
        'phoneNumber': user.phoneNumber,
        'country': user.country,
      }),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Interest()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

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
                  Text('Build Your Profile', style: AppTextStyles.heading),
                  const SizedBox(height: 10),
                  Text(
                    'Take a moment to fill in your profile so we can create a more personalized and seamless journey for you.',
                    style: AppTextStyles.subheading,
                  ),
                  const SizedBox(height: 20),
                  const Center(child: ProfileImage()),
                  const SizedBox(height: 25),

                  CustomTextField(
                    prefixIcon: const Icon(Icons.person, color: Colors.white),
                    hintText: 'Username',
                    onChanged: (val) => setState(() => username = val),
                  ),
                  const SizedBox(height: 15),

                  CustomTextField(
                    prefixIcon: const Icon(Icons.badge, color: Colors.white),
                    hintText: 'Full name',
                    onChanged: (val) => setState(() => fullName = val),
                  ),
                  const SizedBox(height: 15),

                  CustomTextField(
                    prefixIcon: const Icon(
                      Icons.calendar_today,
                      color: Colors.white,
                    ),
                    hintText: dob.isEmpty ? 'Date of birth' : dob,
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
                    hintText: 'Phone number',
                    onChanged: (val) => setState(() => phoneNumber = val),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 15),

                  CustomTextField(
                    prefixIcon: const Icon(Icons.public, color: Colors.white),
                    hintText: country.isEmpty ? 'Country' : country,
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
                      text: 'Continue',
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
