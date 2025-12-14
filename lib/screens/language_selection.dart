import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projek_mobile/providers/locale_provider.dart';
import 'package:projek_mobile/providers/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:projek_mobile/l10n/app_localizations.dart';

class LanguageSelectionScreen extends StatelessWidget {
  const LanguageSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final isDarkMode = themeNotifier.isDarkMode;
    final l10n = AppLocalizations.of(context);

    final codes = ['en', 'zh', 'ko', 'ja', 'id', 'de'];
    final names = [
      l10n.english,
      l10n.mandarin,
      l10n.korean,
      l10n.japanese,
      l10n.indonesian,
      l10n.german,
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDarkMode ? Colors.black : const Color(0xff324eaf),
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          l10n.selectLanguage,
          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w700),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Container(
          color: isDarkMode ? Colors.black : Colors.white,
          padding: const EdgeInsets.all(16),
          child: ListView.separated(
            itemCount: codes.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final code = codes[index];
              final name = names[index];
              final selected = localeProvider.locale.languageCode == code;
              return ListTile(
                tileColor:
                    selected
                        ? (isDarkMode
                            ? Colors.grey[900]
                            : const Color(0xFF324EAF).withOpacity(0.1))
                        : null,
                title: Text(name, style: GoogleFonts.poppins(fontSize: 16)),
                trailing:
                    selected
                        ? const Icon(
                          Icons.check_circle,
                          color: Color(0xFF324EAF),
                        )
                        : null,
                onTap: () {
                  localeProvider.setLocale(Locale(code));
                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
