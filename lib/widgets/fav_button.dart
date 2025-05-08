import 'package:flutter/material.dart';
import 'package:projek_mobile/constants/app_text_style.dart';

class FavButton extends StatelessWidget {
  const FavButton({
    super.key,
    required this.step,
    required this.back,
    required this.next,
  });
  final int step;
  final Widget next;
  final Widget back;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          (step > 1)
              ? Padding(
                padding: const EdgeInsets.only(left: 40.0),
                child: SizedBox(
                  width: 110,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => back),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF40CE62),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      minimumSize: Size(106, 34),
                    ),
                    child: Text("Back", style: AppTextStyles.button),
                  ),
                ),
              )
              : SizedBox(),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => next),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF324EAF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              minimumSize: Size(106, 34),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  (step != 3) ? "Next" : "Start",
                  style: AppTextStyles.button,
                ),
                SizedBox(width: 5),
                (step == 3)
                    ? Icon(Icons.arrow_forward_sharp, color: Colors.white)
                    : SizedBox(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
