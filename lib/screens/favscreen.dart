import 'package:flutter/material.dart';
import 'package:projek_mobile/screens/favscreen2.dart';
import 'package:projek_mobile/widgets/fav_body.dart';
import 'package:projek_mobile/widgets/fav_button.dart';

class FavScreen extends StatefulWidget {
  const FavScreen({super.key});

  @override
  FavScreenState createState() => FavScreenState();
}

class FavScreenState extends State<FavScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            FavBody(image: "assets/images/gif/coding_program.gif", step: 1),
          ],
        ),
        floatingActionButton: FavButton(
          step: 1,
          back: SizedBox(),
          next: FavScreen2(),
        ),
      ),
    );
  }
}
