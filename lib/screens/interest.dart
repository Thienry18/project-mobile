import 'package:flutter/material.dart';
import 'package:projek_mobile/constants/app_text_style.dart';
import 'package:projek_mobile/data/interest_data.dart';
import 'package:projek_mobile/screens/explore_page.dart';
import 'package:projek_mobile/widgets/build_step_circle.dart';
import 'package:projek_mobile/widgets/custom_button.dart';

class Interest extends StatefulWidget {
  const Interest({super.key});

  @override
  InterestState createState() => InterestState();
}

class InterestState extends State<Interest> {
  String? selectedInterest;

  void toggleInterest(String interest) {
    setState(() {
      if (selectedInterest == interest) {
        selectedInterest = null;
      } else {
        selectedInterest = interest;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF7A8EDA)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            BuildStepCircle(isActive: true),
            BuildStepCircle(isActive: true),
            BuildStepCircle(isActive: false),
          ],
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('What Interests You?', style: AppTextStyles.heading),
            SizedBox(height: 10),
            Text(
              'Select the tech topics that excite you the most, and we’ll build your journey around what you truly want to explore.',
              style: AppTextStyles.subheading,
            ),
            SizedBox(height: 25),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 1,
                childAspectRatio: 1.2,
                children:
                    interestsList.map((interest) {
                      final isSelected = selectedInterest == interest.name;

                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ChoiceChip(
                            showCheckmark: false, // <== Hilangkan ceklis
                            padding: EdgeInsets.all(15),
                            label: ColorFiltered(
                              colorFilter:
                                  isSelected
                                      ? ColorFilter.mode(
                                        Colors.grey.withOpacity(0.6),
                                        BlendMode.srcATop,
                                      )
                                      : ColorFilter.mode(
                                        Colors.transparent,
                                        BlendMode.multiply,
                                      ),
                              child: Image.asset(
                                interest.iconPath,
                                width: 80,
                                height: 80,
                              ),
                            ),
                            selected: isSelected,
                            selectedColor: Colors.green.withOpacity(0.2),
                            backgroundColor: Color(0xFFE3E8FB),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            onSelected: (_) => toggleInterest(interest.name),
                          ),
                          SizedBox(height: 10),
                          Text(
                            interest.name,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color:
                                  isSelected ? Colors.green : Color(0xFF7A8EDA),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: SizedBox(
                width: 250,
                child: CustomButton(
                  text: 'Continue',
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  onPressed: () {
                    if (selectedInterest != null) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => ExplorePage(
                                selectedCategory: selectedInterest!,
                              ),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Please select at least one interest.'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
