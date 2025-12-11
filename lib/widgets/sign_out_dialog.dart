import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:projek_mobile/screens/sign_in.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<void> signOutDialog(BuildContext context) async {
  showDialog(
    context: context,
    builder:
        (_) => AlertDialog(
          title: Text(AppLocalizations.of(context).signOut),
          content: Text(AppLocalizations.of(context).areYouSureSignOut),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppLocalizations.of(context).cancel),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  await FirebaseAuth.instance.signOut();
                } catch (e) {
                  // ignore sign out errors from firebase; proceed to clear prefs
                  // ignore: avoid_print
                  print('Firebase signOut error: $e');
                }
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
              child: Text(AppLocalizations.of(context).signOut),
            ),
          ],
        ),
  );
}
