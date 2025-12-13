import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../data/user_profile_repository.dart';
import '../models/user_profile.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameCtrl = TextEditingController();
  final _fullNameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  String _sex = 'male';
  String _country = '';
  DateTime? _dob;

  final _repo = UserProfileRepository();

  Future<UserProfile?> _loadProfile() => _repo.fetchProfile();

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _fullNameCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDob() async {
    final now = DateTime.now();
    final initial = _dob ?? DateTime(now.year - 20);
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1900),
      lastDate: now,
    );
    if (picked != null) setState(() => _dob = picked);
  }

  Future<void> _onSubmit(UserProfile? existing) async {
    if (!_formKey.currentState!.validate()) return;
    if (_dob == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please pick date of birth')),
      );
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Not authenticated')));
      return;
    }

    final profile = UserProfile(
      uid: user.uid,
      username: _usernameCtrl.text.trim(),
      fullName: _fullNameCtrl.text.trim(),
      dateOfBirth: Timestamp.fromDate(_dob!),
      sex: _sex,
      phoneNumber: _phoneCtrl.text.trim(),
      country: _country,
      createdAt: existing?.createdAt ?? Timestamp.now(),
      updatedAt: Timestamp.now(),
    );

    try {
      if (existing == null) {
        await _repo.createProfile(profile);
      } else {
        await _repo.updateProfile(profile);
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Profile saved')));
    } on FirebaseException catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${e.message}')));
    }
  }

  @override
  Widget build(BuildContext context) {
    // Using plain strings here to avoid missing gen-l10n keys in some locales.
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: FutureBuilder<UserProfile?>(
        future: _loadProfile(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting)
            return const Center(child: CircularProgressIndicator());
          final profile = snap.data;
          if (profile != null) {
            _usernameCtrl.text = profile.username;
            _fullNameCtrl.text = profile.fullName;
            _phoneCtrl.text = profile.phoneNumber;
            _sex = profile.sex;
            _country = profile.country;
            _dob = profile.dateOfBirth.toDate();
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _usernameCtrl,
                    decoration: const InputDecoration(labelText: 'Username'),
                    validator:
                        (v) =>
                            (v == null || v.trim().isEmpty) ? 'Required' : null,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _fullNameCtrl,
                    decoration: const InputDecoration(labelText: 'Full name'),
                    validator:
                        (v) =>
                            (v == null || v.trim().isEmpty) ? 'Required' : null,
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: _pickDob,
                    child: AbsorbPointer(
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Date of birth',
                          hintText:
                              _dob == null
                                  ? 'Pick date'
                                  : _dob!
                                      .toLocal()
                                      .toIso8601String()
                                      .split('T')
                                      .first,
                        ),
                        validator: (_) => _dob == null ? 'Required' : null,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _sex,
                    items: const [
                      DropdownMenuItem(value: 'male', child: Text('Male')),
                      DropdownMenuItem(value: 'female', child: Text('Female')),
                    ],
                    onChanged: (v) => setState(() => _sex = v ?? 'male'),
                    decoration: const InputDecoration(labelText: 'Sex'),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _phoneCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Phone number',
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Minimal country dropdown - localization expects country labels provided by gen-l10n
                  DropdownButtonFormField<String>(
                    value: _country.isEmpty ? null : _country,
                    items: [
                      DropdownMenuItem(
                        value: 'Indonesia',
                        child: Text('Indonesia'),
                      ),
                      DropdownMenuItem(
                        value: 'United States',
                        child: Text('United States'),
                      ),
                      DropdownMenuItem(value: 'Japan', child: Text('Japan')),
                    ],
                    onChanged: (v) => setState(() => _country = v ?? ''),
                    decoration: const InputDecoration(labelText: 'Country'),
                    validator:
                        (v) => (v == null || v.isEmpty) ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => _onSubmit(profile),
                    child: Text(
                      profile == null ? 'Create Profile' : 'Update Profile',
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
