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

  void _navigateWithFade(BuildContext context, Widget destination) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => destination,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

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
                    onPressed: () => _navigateWithFade(context, back),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF40CE62),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      minimumSize: const Size(106, 45),
                    ),
                    child: Text("Back", style: AppTextStyles.button),
                  ),
                ),
              )
              : const SizedBox(),
          ElevatedButton(
            onPressed: () => _navigateWithFade(context, next),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF324EAF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              minimumSize: const Size(106, 45),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  (step != 3) ? "Next" : "Start",
                  style: AppTextStyles.button,
                ),
                const SizedBox(width: 5),
                if (step == 3)
                  const Icon(Icons.arrow_forward_sharp, color: Colors.white),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
