import 'package:flutter/material.dart';
import 'package:projek_mobile/screens/onboarding.dart';
import 'package:projek_mobile/screens/onboarding3.dart';
import 'package:projek_mobile/widgets/onboarding_body.dart';
import 'package:projek_mobile/widgets/onboarding_button.dart';

class FavScreen2 extends StatelessWidget {
  const FavScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            FavBody(
              image: "assets/images/gif/programming_languages.gif",
              step: 2,
            ),
          ],
        ),
        floatingActionButton: FavButton(
          step: 2,
          back: FavScreen(),
          next: FavScreen3(),
        ),
      ),
    );
  }
}
