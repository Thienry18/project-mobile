import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projek_mobile/widgets/filter_menu_button.dart';

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search for a course',
              hintStyle: GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
              suffixIcon: const Icon(Icons.search, color: Colors.grey),
              filled: true,
              fillColor: const Color(0xFFE3E8FB),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 0,
                horizontal: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        // Ganti ElevatedButton → FilterMenuButton
        const FilterMenuButton(), // ini sudah tombol + popup-nya
      ],
    );
  }
}
