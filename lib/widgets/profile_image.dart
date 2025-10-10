import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:projek_mobile/data/auth_repository.dart';

class ProfileImage extends StatefulWidget {
  const ProfileImage({super.key});

  @override
  State<ProfileImage> createState() => _ProfileImageState();
}

class _ProfileImageState extends State<ProfileImage> {
  File? _localPreview;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      final imageFile = File(picked.path);
      setState(() {
        _localPreview = imageFile;
      });

      // Persist avatar path into DB for current user
      final prefs = await SharedPreferences.getInstance();
      final email = prefs.getString('user_email');
      if (email != null && email.isNotEmpty) {
        final auth = AuthRepository();
        try {
          await auth.updateProfile(
            currentEmail: email,
            avatarPath: picked.path,
          );
          // DatabaseService.emitUsers will be called from updateProfile
        } catch (_) {}
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: (context, spSnap) {
        final email = spSnap.data?.getString('user_email');

        if (email == null || email.isEmpty) {
          // No logged user: show placeholder and allow local pick only
          return _buildAvatar(_localPreview);
        }

        return StreamBuilder<Map<String, dynamic>?>(
          stream: AuthRepository().watchUserByEmail(email),
          builder: (context, snap) {
            String? avatarPath;
            if (snap.hasData && snap.data != null) {
              avatarPath = snap.data!['avatar_path'] as String?;
            }
            // prefer local preview if just picked
            final imageToShow =
                _localPreview ??
                (avatarPath != null && avatarPath.isNotEmpty
                    ? File(avatarPath)
                    : null);
            return _buildAvatar(imageToShow);
          },
        );
      },
    );
  }

  Widget _buildAvatar(File? image) {
    return SizedBox(
      width: 130,
      height: 130,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircleAvatar(
            radius: 55,
            backgroundImage:
                image != null
                    ? FileImage(image)
                    : const NetworkImage('https://i.pravatar.cc/150?img=3')
                        as ImageProvider,
          ),
          Positioned(
            top: 30,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFE3E8FB),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: GestureDetector(
                onTap: _pickImage,
                child: const CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.camera_alt,
                    size: 18,
                    color: Colors.black54,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
