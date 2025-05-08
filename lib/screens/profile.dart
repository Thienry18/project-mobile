import 'package:flutter/material.dart';
import 'package:projek_mobile/constants/app_text_style.dart';
import 'package:projek_mobile/screens/interest.dart';
import 'package:projek_mobile/widgets/build_step_circle.dart';
import 'package:projek_mobile/widgets/custom_textfield.dart';
import 'package:projek_mobile/widgets/gender_picker.dart';
import 'package:projek_mobile/widgets/profile_image.dart';
import 'package:projek_mobile/widgets/custom_button.dart'; // pastikan ini diimport

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
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
          icon: Icon(Icons.arrow_back, color: Color(0xFF7A8EDA)),
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
              prefixIcon: Icon(Icons.person, color: Color(0xFF7A8EDA)),
              hintText: 'Username',
              onChanged: (val) => setState(() => username = val),
            ),
            SizedBox(height: 15),
            CustomTextField(
              prefixIcon: Icon(Icons.badge, color: Color(0xFF7A8EDA)),
              hintText: 'Full name',
              onChanged: (val) => setState(() => fullName = val),
            ),
            SizedBox(height: 15),
            CustomTextField(
              prefixIcon: Icon(Icons.calendar_today, color: Color(0xFF7A8EDA)),
              hintText: dob.isEmpty ? 'Date of birth' : dob,
              readOnly: true,
              suffixIcon: Icon(
                Icons.keyboard_arrow_down,
                color: Color(0xFF7A8EDA),
              ),
              onTap: () async {
                DateTime? date = await showDatePicker(
                  context: context,
                  initialDate: DateTime(2000),
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
            CustomTextField(
              prefixIcon: Icon(Icons.phone, color: Color(0xFF7A8EDA)),
              hintText: 'Phone number',
              onChanged: (val) => setState(() => phoneNumber = val),
            ),
            SizedBox(height: 15),
            CustomTextField(
              prefixIcon: Icon(Icons.public, color: Color(0xFF7A8EDA)),
              hintText: 'Country',
              onChanged: (val) => setState(() => country = val),
            ),
            SizedBox(height: 30),
            CustomButton(
              text: 'Continue',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Interest()),
                );
              },
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 80),
            ),
          ],
        ),
      ),
    );
  }
}
