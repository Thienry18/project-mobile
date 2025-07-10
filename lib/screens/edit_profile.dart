import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  final _usernameController = TextEditingController(text: "moon_gayoung031205");
  final _fullnameController = TextEditingController(text: "Moon Ga Young");
  final _statusController = TextEditingController(text: "Student");
  final _dobController = TextEditingController(text: "03/12/2005");
  final _genderController = TextEditingController(text: "Female");
  final _countryController = TextEditingController(text: "Indonesia");
  final _emailController = TextEditingController(
    text: "moon_gayoung@gmail.com",
  );
  final _phoneController = TextEditingController(text: "+628-5219-815-021");

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const blueColor = Color(0xFF324EAF);
    const grayTextColor = Colors.grey;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: blueColor,
        title: Text(
          'Edit Profile',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: const BackButton(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 55,
                    backgroundImage:
                        _imageFile != null
                            ? FileImage(_imageFile!)
                            : const NetworkImage(
                                  'https://i.pinimg.com/736x/cf/1d/84/cf1d84e5c5290f2cd1d1b77a7f3429f6.jpg',
                                )
                                as ImageProvider,
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: _pickImage,
                    child: Text(
                      'Upload/Change Photo',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: blueColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            _buildLabel("Username"),
            _buildTextField(_usernameController, blueColor),

            _buildLabel("Full Name"),
            _buildTextField(_fullnameController, blueColor),

            _buildLabel("Status"),
            _buildTextField(_statusController, grayTextColor, readOnly: true),

            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel("Date of Birth"),
                      _buildTextField(
                        _dobController,
                        grayTextColor,
                        readOnly: true,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel("Gender"),
                      _buildTextField(
                        _genderController,
                        grayTextColor,
                        readOnly: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            _buildLabel("Country"),
            _buildTextField(_countryController, blueColor),

            _buildLabel("Email Address"),
            _buildTextField(_emailController, blueColor),

            _buildLabel("Phone Number"),
            _buildTextField(_phoneController, blueColor),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 4),
      child: Text(
        label,
        textAlign: TextAlign.left,
        style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    Color color, {
    bool readOnly = false,
  }) {
    return Container(
      padding: const EdgeInsets.only(bottom: 8),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey, width: 0.6)),
      ),
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: color,
        ),
        cursorColor: color,
        decoration: const InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.zero,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
