import 'package:flutter/material.dart';
import 'package:projek_mobile/constants/app_text_style.dart';
import 'package:projek_mobile/screens/interest.dart';
import 'package:projek_mobile/widgets/build_step_circle.dart';
import 'package:projek_mobile/widgets/custom_textfield.dart';
import 'package:projek_mobile/widgets/gender_picker.dart';
import 'package:projek_mobile/widgets/profile_image.dart';
import 'package:projek_mobile/widgets/custom_button.dart';

// Impor package yang diperlukan
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
  String country = ''; // Variabel ini akan menyimpan nama negara yang dipilih

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
              prefixIcon: Icon(Icons.phone, color: Color(0xFF7A8EDA)),
              hintText: 'Phone number',
              onChanged: (val) => setState(() => phoneNumber = val),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 15),

            // ===== BAGIAN YANG DIUBAH: DARI DROPDOWN MENJADI CUSTOMTEXTFIELD DENGAN DIALOG =====
            CustomTextField(
              prefixIcon: Icon(Icons.public, color: Color(0xFF7A8EDA)),
              hintText: country.isEmpty ? 'Country' : country,
              readOnly: true,
              onTap: () {
                showCountryPicker(
                  context: context,
                  // Tampilan UI dari dialog
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
                      // Simpan nama negara yang dipilih ke dalam state
                      country = selectedCountry.name;
                    });
                  },
                );
              },
            ),

            // ===== AKHIR BAGIAN YANG DIUBAH =====
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
