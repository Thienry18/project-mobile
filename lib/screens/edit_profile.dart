import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projek_mobile/utils/permission_helper.dart';
import 'package:projek_mobile/models/user_profile.dart';
import 'package:projek_mobile/data/auth_repository.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:projek_mobile/providers/profile_image_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:projek_mobile/data/user_profile_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditProfileScreen extends StatefulWidget {
  final UserProfile userProfile;

  const EditProfileScreen({super.key, required this.userProfile});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  late TextEditingController _usernameController;
  late TextEditingController _fullnameController;
  late TextEditingController _statusController;
  late TextEditingController _dobController;
  late TextEditingController _genderController;
  late TextEditingController _countryController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  final _formKey = GlobalKey<FormState>();
  final _auth = AuthRepository();

  String? _currentEmail; // email aktif (sebelum diubah)
  String? _dbAvatarPath; // avatar dari DB/SP (jika ada)
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final data = widget.userProfile;
    _usernameController = TextEditingController(text: data.username);
    _fullnameController = TextEditingController(text: data.fullName);
    _statusController = TextEditingController(text: "Student");
    _dobController = TextEditingController(text: data.dob);
    _genderController = TextEditingController(text: data.gender);
    _countryController = TextEditingController(text: data.country);
    _emailController = TextEditingController(
      text: "@gmail.com",
    ); // nanti di-replace dari SP
    _phoneController = TextEditingController(text: data.phoneNumber);

    _bootstrap();
  }

  Future<void> _bootstrap() async {
    final prefs = await SharedPreferences.getInstance();
    _currentEmail = prefs.getString('user_email');
    final spUsername = prefs.getString('user_username');
    final spAvatar = prefs.getString('user_avatar_path');

    // Prefill email / username dari SP jika ada
    if ((_currentEmail ?? '').isNotEmpty) {
      _emailController.text = _currentEmail!;
    }
    if ((spUsername ?? '').isNotEmpty) {
      _usernameController.text = spUsername!;
    }
    if ((spAvatar ?? '').isNotEmpty) {
      _dbAvatarPath = spAvatar;
    }

    // Ambil avatar dari DB kalau perlu
    if (_currentEmail != null) {
      final user = await _auth.getUserByEmail(_currentEmail!);
      if (user != null) {
        final avatar = (user['avatar_path'] as String?) ?? '';
        if (avatar.trim().isNotEmpty) {
          _dbAvatarPath = avatar;
        }
        // kalau username di DB ada, dan field kosong → pakai dari DB
        final dbUsername = user['username'] as String?;
        if ((_usernameController.text.trim().isEmpty) &&
            (dbUsername != null && dbUsername.trim().isNotEmpty)) {
          _usernameController.text = dbUsername;
        }
      }
    }
    setState(() {});
  }

  Future<void> _pickFromGallery() async {
    final ok = await PermissionHelper.requestStoragePermission(context);
    if (!ok) return;
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (pickedFile != null) {
      final file = File(pickedFile.path);
      setState(() {
        _imageFile = file;
      });
      if (mounted) {
        context.read<ProfileImageProvider>().setImage(file);
      }
    }
  }

  Future<void> _pickFromCamera() async {
    final ok = await PermissionHelper.requestCameraPermission(context);
    if (!ok) return;
    final pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
    );
    if (pickedFile != null) {
      final file = File(pickedFile.path);
      setState(() {
        _imageFile = file;
      });
      if (mounted) {
        context.read<ProfileImageProvider>().setImage(file);
      }
    }
  }

  Future<void> _showImageSourceSheet() async {
    showModalBottomSheet(
      context: context,
      builder:
          (ctx) => SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: Text(AppLocalizations.of(ctx).takePhoto),
                  onTap: () {
                    Navigator.of(ctx).pop();
                    _pickFromCamera();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: Text(AppLocalizations.of(ctx).chooseFromGallery),
                  onTap: () {
                    Navigator.of(ctx).pop();
                    _pickFromGallery();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.close),
                  title: Text(AppLocalizations.of(ctx).cancel),
                  onTap: () => Navigator.of(ctx).pop(),
                ),
              ],
            ),
          ),
    );
  }

  void _showSnack(String msg, {bool error = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: error ? Colors.red : Colors.green,
      ),
    );
  }

  Future<void> _save() async {
    if (_saving) return;
    if (!_formKey.currentState!.validate()) return;

    if ((_currentEmail ?? '').isEmpty) {
      _showSnack(AppLocalizations.of(context).noActiveSession, error: true);
      return;
    }

    final newUsername = _usernameController.text.trim();
    final newEmail = _emailController.text.trim().toLowerCase();
    final avatarPath = _imageFile?.path ?? _dbAvatarPath;

    setState(() => _saving = true);

    try {
      await _auth.updateProfile(
        currentEmail: _currentEmail!,
        newEmail: newEmail.isNotEmpty ? newEmail : null,
        username: newUsername.isNotEmpty ? newUsername : null,
        fullname:
            _fullnameController.text.trim().isNotEmpty
                ? _fullnameController.text.trim()
                : null,
        avatarPath: (avatarPath ?? '').isNotEmpty ? avatarPath : null,
      );

      final prefs = await SharedPreferences.getInstance();
      if (newUsername.isNotEmpty) {
        await prefs.setString('user_username', newUsername);
      }
      // Persist updated profile JSON so screens that read `user_profile` get latest data
      final profileJson = {
        'username':
            newUsername.isNotEmpty ? newUsername : _usernameController.text,
        'fullName': _fullnameController.text.trim(),
        'dob': _dobController.text,
        'gender': _genderController.text,
        'phoneNumber': _phoneController.text,
        'country': _countryController.text,
      };
      await prefs.setString('user_profile', jsonEncode(profileJson));
      if (newEmail.isNotEmpty && newEmail != _currentEmail) {
        await prefs.setString('user_email', newEmail);
      }
      if ((avatarPath ?? '').isNotEmpty) {
        await prefs.setString('user_avatar_path', avatarPath!);
      }

      // Also update Firestore profile if user is authenticated via Firebase
      final firebaseUser = FirebaseAuth.instance.currentUser;
      if (firebaseUser != null) {
        final repo = UserProfileRepository();
        final profile = UserProfile(
          uid: firebaseUser.uid,
          username: _usernameController.text.trim(),
          fullName: _fullnameController.text.trim(),
          dob: _dobController.text,
          gender: _genderController.text,
          phoneNumber: _phoneController.text.trim(),
          country: _countryController.text,
        );
        try {
          await repo.updateProfile(profile);
        } catch (e, st) {
          // Surface Firestore errors
          // ignore: avoid_print
          print('Firestore updateProfile error: $e');
          // ignore: avoid_print
          print(st);
          _showSnack('Failed to update Firestore profile: $e', error: true);
        }
      }

      _showSnack(AppLocalizations.of(context).profileUpdatedSuccessfully);
      if (!mounted) return;
      Navigator.pop(
        context,
        true,
      ); // kirim tanda berhasil agar screen sebelumnya refresh
    } catch (e) {
      _showSnack(e.toString().replaceFirst('Exception: ', ''), error: true);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const blueColor = Color(0xFF324EAF);
    const grayTextColor = Colors.grey;

    // Pilih sumber avatar:
    final providerImage = context.watch<ProfileImageProvider>().image;
    ImageProvider avatarProvider;
    if (providerImage != null) {
      avatarProvider = FileImage(providerImage);
    } else if (_imageFile != null) {
      avatarProvider = FileImage(_imageFile!);
    } else if ((_dbAvatarPath ?? '').isNotEmpty) {
      avatarProvider = FileImage(File(_dbAvatarPath!));
    } else {
      avatarProvider = const NetworkImage(
        'https://i.pinimg.com/736x/cf/1d/84/cf1d84e5c5290f2cd1d1b77a7f3429f6.jpg',
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: blueColor,
        title: Text(
          AppLocalizations.of(context).editProfile,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: const BackButton(color: Colors.white),
        actions: [
          TextButton(
            onPressed: _saving ? null : _save,
            child:
                _saving
                    ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                    : Text(
                      AppLocalizations.of(context).save,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    CircleAvatar(radius: 55, backgroundImage: avatarProvider),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: _showImageSourceSheet,
                      child: Text(
                        AppLocalizations.of(context).uploadChangePhoto,
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
              _buildEditableField(
                controller: _usernameController,
                color: blueColor,
                validator:
                    (v) =>
                        (v == null || v.trim().isEmpty)
                            ? 'Username must not be empty'
                            : null,
              ),

              _buildLabel("Full Name"),
              _buildEditableField(
                controller: _fullnameController,
                color: blueColor,
              ),

              _buildLabel("Status"),
              _buildEditableField(
                controller: _statusController,
                color: grayTextColor,
                readOnly: true,
              ),

              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel("Date of Birth"),
                        _buildEditableField(
                          controller: _dobController,
                          color: grayTextColor,
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
                        _buildEditableField(
                          controller: _genderController,
                          color: grayTextColor,
                          readOnly: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              _buildLabel("Country"),
              _buildEditableField(
                controller: _countryController,
                color: blueColor,
              ),

              _buildLabel("Email Address"),
              _buildEditableField(
                controller: _emailController,
                color: blueColor,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'Email must not be empty';
                  }
                  if (!_auth.isValidGmail(v.trim())) {
                    return 'Email must be a valid @gmail.com address';
                  }
                  return null;
                },
              ),

              _buildLabel("Phone Number"),
              _buildEditableField(
                controller: _phoneController,
                color: blueColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 4),
      child: Text(
        label,
        style: GoogleFonts.poppins(fontSize: 13, color: Colors.black),
      ),
    );
  }

  Widget _buildEditableField({
    required TextEditingController controller,
    required Color color,
    bool readOnly = false,
    String? Function(String?)? validator,
  }) {
    return Container(
      padding: const EdgeInsets.only(bottom: 8),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey, width: 0.6)),
      ),
      child: TextFormField(
        controller: controller,
        readOnly: readOnly,
        validator: validator,
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
