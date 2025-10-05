import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:projek_mobile/screens/sign_in.dart';

Future<void> signOutDialog(BuildContext context) async {
  showDialog(
    context: context,
    builder:
        (_) => AlertDialog(
          title: const Text('Sign Out'),
          content: const Text('Are you sure you want to sign out?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.remove('is_logged_in');
                await prefs.remove('user_email');

                if (context.mounted) {
                  Navigator.pop(context); // close dialog
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const SignIn()),
                    (route) => false,
                  );
                }
              },
              child: const Text('Sign Out'),
            ),
          ],
        ),
  );
}
