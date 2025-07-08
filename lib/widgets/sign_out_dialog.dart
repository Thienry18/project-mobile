import 'package:flutter/material.dart';
import 'package:projek_mobile/screens/sign_in.dart';

void signOutDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (_) {
      final maxDialogWidth = MediaQuery.of(context).size.width * 0.9;
      return Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: maxDialogWidth < 320 ? maxDialogWidth : 320,
          ),
          child: Material(
            type: MaterialType.transparency,
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: const EdgeInsets.all(20),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.help_outline,
                      size: 50,
                      color: Colors.blue,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Are You Leaving?',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "Once you log out, you’ll need to sign in again to access your account. Do you still want to log out?",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.blueGrey),
                    ),
                    const SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Flexible(
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.of(context, rootNavigator: true).pop();
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.blue,
                              side: const BorderSide(color: Colors.blue),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text('NO'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Flexible(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context, rootNavigator: true).pop();
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const SignIn(),
                                ),
                                (route) => false,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text('YES'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}
