import 'package:flutter/material.dart';
import 'package:projek_mobile/screens/favscreen2.dart';
import 'package:projek_mobile/screens/sign_in.dart';
import 'package:projek_mobile/widgets/fav_body.dart';
import 'package:projek_mobile/widgets/fav_button.dart';

class FavScreen3 extends StatelessWidget {
  const FavScreen3({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            FavBody(image: "assets/images/gif/start_coding.gif", step: 3),
          ],
        ),
        floatingActionButton: FavButton(
          step: 3,
          back: FavScreen2(),
          next: SignIn(),
        ),
      ),
    );
  }
}
