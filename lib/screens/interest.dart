import 'package:flutter/material.dart';
import 'package:projek_mobile/constants/app_text_style.dart';
import 'package:projek_mobile/data/interest_data.dart';
import 'package:projek_mobile/screens/set_pin.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:projek_mobile/data/auth_repository.dart';
import 'package:projek_mobile/widgets/build_step_circle.dart';
import 'package:projek_mobile/widgets/custom_button.dart';
import 'package:projek_mobile/l10n/app_localizations.dart';

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
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = 2;
    final spacing = 10.0;
    final itemWidth =
        (screenWidth - (spacing * (crossAxisCount + 1))) / crossAxisCount;
    final itemHeight = itemWidth + 30;
    final aspectRatio = itemWidth / itemHeight;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).iconTheme.color,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Row(
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
            Text(
              AppLocalizations.of(context).whatInterestsYou,
              style: AppTextStyles.heading,
            ),
            const SizedBox(height: 10),
            Text(
              AppLocalizations.of(context).selectInterestsDescription,
              style: AppTextStyles.subheading,
            ),
            const SizedBox(height: 25),
            Expanded(
              child: GridView.count(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: spacing,
                mainAxisSpacing: spacing,
                childAspectRatio: aspectRatio,
                children:
                    interestsList.map((interest) {
                      final isSelected = selectedInterest == interest.name;

                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ChoiceChip(
                            showCheckmark: false,
                            padding: const EdgeInsets.all(15),
                            label: ColorFiltered(
                              colorFilter:
                                  isSelected
                                      ? ColorFilter.mode(
                                        Colors.grey.withOpacity(0.6),
                                        BlendMode.srcATop,
                                      )
                                      : const ColorFilter.mode(
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
                            backgroundColor: const Color(0xFFE3E8FB),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            onSelected: (_) => toggleInterest(interest.name),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            interest.name,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color:
                                  isSelected
                                      ? Colors.green
                                      : Theme.of(
                                            context,
                                          ).textTheme.bodyMedium?.color ??
                                          const Color(0xFF7A8EDA),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: SizedBox(
                width: 250,
                child: CustomButton(
                  text: AppLocalizations.of(context).continueButton,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  onPressed: () {
                    if (selectedInterest != null) {
                      categoryselected = selectedInterest!;
                      // persist interest into DB for current user (if logged in)
                      () async {
                        final prefs = await SharedPreferences.getInstance();
                        final email = prefs.getString('user_email');
                        if (email != null && email.isNotEmpty) {
                          final auth = AuthRepository();
                          try {
                            await auth.updateProfile(
                              currentEmail: email,
                              pin: null,
                              interest: selectedInterest,
                            );
                          } catch (_) {}
                        }
                        if (!mounted) return;
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SetPinScreen(),
                          ),
                        );
                      }();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            AppLocalizations.of(
                              context,
                            ).selectAtLeastOneInterest,
                          ),
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
