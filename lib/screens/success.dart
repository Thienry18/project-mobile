import 'package:flutter/material.dart';
import 'package:projek_mobile/constants/app_text_style.dart';
import 'package:projek_mobile/data/interest_data.dart';
import 'package:projek_mobile/screens/explore_page.dart';
import 'package:projek_mobile/widgets/custom_button.dart'; // Add this import

class Success extends StatelessWidget {
  const Success({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF7A8EDA)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('images/gif/setup.gif'),
            SizedBox(height: 30),
            Text('Setup Complete!', style: AppTextStyles.heading),
            SizedBox(height: 10),
            Text(
              'Great job! Your PIN is now active, and you can safely start using the app without any worries.',
              textAlign: TextAlign.center,
              style: AppTextStyles.subheading,
            ),
            SizedBox(height: 35),
            CustomButton(
              text: 'Get Started',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) =>
                            ExplorePage(selectedCategory: categoryselected),
                  ),
                );
              },
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
              icon: Icons.arrow_forward,
            ),
          ],
        ),
      ),
    );
  }
}
