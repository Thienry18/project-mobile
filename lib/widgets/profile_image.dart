import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:projek_mobile/providers/profile_image_provider.dart';

class ProfileImage extends StatefulWidget {
  const ProfileImage({super.key});

  @override
  State<ProfileImage> createState() => _ProfileImageState();
}

class _ProfileImageState extends State<ProfileImage> {
  File? _imageFile;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      final imageFile = File(picked.path);
      setState(() {
        _imageFile = imageFile;
      });

      context.read<ProfileImageProvider>().setImage(imageFile);
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    final profileImage = context.watch<ProfileImageProvider>().image;

    return SizedBox(
      width: 130,
      height: 130,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircleAvatar(
            radius: 55,
            backgroundImage:
                profileImage != null
                    ? FileImage(profileImage)
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
