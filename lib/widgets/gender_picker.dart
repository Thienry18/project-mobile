import 'package:flutter/material.dart';
import 'package:projek_mobile/constants/app_text_style.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GenderPicker extends StatelessWidget {
  final String gender;
  final ValueChanged<String?> onChanged;

  GenderPicker({required this.gender, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 15),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: Color(0xFFE3E8FB),
                borderRadius: BorderRadius.circular(12),
              ),
              child: RadioListTile<String>(
                value: 'Male',
                groupValue: gender,
                onChanged: onChanged,
                title: Text(
                  AppLocalizations.of(context).male,
                  style: AppTextStyles.subheading,
                ),
                secondary: Icon(Icons.male, color: Colors.white, size: 30),
                fillColor: MaterialStateProperty.all(Color(0XFF7A8EDA)),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 0,
                  vertical: 0,
                ),
                controlAffinity: ListTileControlAffinity.trailing,
              ),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: Color(0xFFE3E8FB),
                borderRadius: BorderRadius.circular(12),
              ),
              child: RadioListTile<String>(
                value: 'Female',
                groupValue: gender,
                onChanged: onChanged,
                fillColor: MaterialStateProperty.all(Color(0xFF7A8EDA)),
                title: Text(
                  AppLocalizations.of(context).female,
                  style: AppTextStyles.subheading,
                ),
                secondary: Icon(Icons.female, color: Colors.white, size: 30),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 0,
                  vertical: 0,
                ),
                controlAffinity: ListTileControlAffinity.trailing,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
