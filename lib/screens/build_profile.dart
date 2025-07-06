import 'package:flutter/material.dart';
import 'package:projek_mobile/constants/app_text_style.dart';
import 'package:projek_mobile/screens/interest.dart';
import 'package:projek_mobile/widgets/build_step_circle.dart';
import 'package:projek_mobile/widgets/custom_textfield.dart';
import 'package:projek_mobile/widgets/gender_picker.dart';
import 'package:projek_mobile/widgets/profile_image.dart';
import 'package:projek_mobile/widgets/custom_button.dart';

import 'package:country_picker/country_picker.dart';

class BuildProfile extends StatefulWidget {
  BuildProfile({super.key});

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            BuildStepCircle(isActive: true),
            BuildStepCircle(isActive: false),
            BuildStepCircle(isActive: false),
          ],
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Build Your Profile', style: AppTextStyles.heading),
            ),
            SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Take a moment to fill in your profile so we can create a more personalized and seamless journey for you.',
                style: AppTextStyles.subheading,
                textAlign: TextAlign.left,
              ),
            ),
            SizedBox(height: 20),
            ProfileImage(),
            SizedBox(height: 25),
            CustomTextField(
              prefixIcon: Icon(Icons.person, color: Colors.white),
              hintText: 'Username',
              onChanged: (val) => setState(() => username = val),
            ),
            SizedBox(height: 15),
            CustomTextField(
              prefixIcon: Icon(Icons.badge, color: Colors.white),
              hintText: 'Full name',
              onChanged: (val) => setState(() => fullName = val),
            ),
            SizedBox(height: 15),
            CustomTextField(
              prefixIcon: Icon(Icons.calendar_today, color: Colors.white),
              hintText: dob.isEmpty ? 'Date of birth' : dob,
              readOnly: true,
              suffixIcon: Icon(Icons.keyboard_arrow_down, color: Colors.white),
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
            SizedBox(height: 15),
            GenderPicker(
              gender: gender,
              onChanged: (val) => setState(() => gender = val ?? ''),
            ),
            SizedBox(height: 15),
            CustomTextField(
              prefixIcon: Icon(Icons.phone, color: Colors.white),
              hintText: 'Phone number',
              onChanged: (val) => setState(() => phoneNumber = val),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 15),

            CustomTextField(
              prefixIcon: Icon(Icons.public, color: Colors.white),
              hintText: country.isEmpty ? 'Country' : country,
              readOnly: true,
              onTap: () {
                showCountryPicker(
                  context: context,
                  countryListTheme: CountryListThemeData(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0),
                    ),
                    inputDecoration: InputDecoration(
                      labelText: 'Search',
                      hintText: 'Start typing to search',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFF8C98A8).withOpacity(0.2),
                        ),
                      ),
                    ),
                  ),
                  onSelect: (Country selectedCountry) {
                    setState(() {
                      country = selectedCountry.name;
                    });
                  },
                );
              },
            ),

            SizedBox(height: 30),
            CustomButton(
              text: 'Continue',
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Interest()),
                );
              },
              padding: EdgeInsets.symmetric(vertical: 18, horizontal: 80),
            ),
          ],
        ),
      ),
    );
  }
}
