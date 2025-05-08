import 'package:flutter/material.dart';
import 'package:projek_mobile/constants/app_text_style.dart';

class FavBody extends StatelessWidget {
  FavBody({super.key, required this.image, required this.step});
  final String image;
  final int step;
  final List<List> text = [
    [
      'Learn coding & Build innovations',
      'We help you master programming with interactive lessons',
      'and real-world projects. Develop practical skills and turn',
      'your creativity into innovation.',
    ],
    [
      'Turn ideas into real projects',
      'We guide you step by step and provide hands-on',
      'challenges to help you transform your ideas into functional',
      'websites, apps, and AI solutions.',
    ],
    [
      'Start coding and shape tomorrow',
      'We connect you with a community of learners and give you',
      'the skills to build the future. Whether you are a beginner or',
      'experienced, we empower you to grow',
    ],
  ];

  @override
  Widget build(BuildContext context) {
    {
      return Column(
        children: [
          Center(
            child: Image.asset(
              'assets/images/logo.jpg',
              width: 200,
              height: 200,
            ),
          ),
          SizedBox(
            width: double.infinity,
            height: 200,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  top: 0,
                  left: 95,
                  child: Hero(
                    tag: 'circle-shape',
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        color: Color(0xFF97F0AC),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  left: 90,
                  child: Image.asset(image, width: 200, height: 200),
                ),
              ],
            ),
          ),
          SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 10,
            children: List.generate(3, (index) {
              return Container(
                width: 5,
                height: 10,
                decoration: BoxDecoration(
                  color: (index == step - 1) ? Color(0xff40CE62) : Colors.grey,
                  shape: BoxShape.circle,
                ),
              );
            }),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              text[step - 1][0],
              style: AppTextStyles.heading,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 10),
          Text(text[step - 1][1], style: AppTextStyles.body),
          Text(text[step - 1][2], style: AppTextStyles.body),
          Text(text[step - 1][3], style: AppTextStyles.body),
        ],
      );
    }
  }
}
