import 'package:flutter/material.dart';
import 'package:projek_mobile/screens/onboarding2.dart';
import 'package:projek_mobile/widgets/onboarding_body.dart';
import 'package:projek_mobile/widgets/onboarding_button.dart';

class FavScreen extends StatefulWidget {
  const FavScreen({super.key});

  @override
  FavScreenState createState() => FavScreenState();
}

class FavScreenState extends State<FavScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      Expanded(
                        child: FavBody(
                          image: "assets/images/gif/coding_program.gif",
                          step: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FavButton(
        step: 1,
        back: const SizedBox(),
        next: const FavScreen2(),
      ),
    );
  }
}
