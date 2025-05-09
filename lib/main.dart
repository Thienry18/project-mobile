import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:projek_mobile/providers/theme_provider.dart';
import 'package:projek_mobile/screens/explore_page.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeNotifier(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Dapatkan mode yang dipilih dari ThemeNotifier
    final isDarkMode = Provider.of<ThemeNotifier>(context).isDarkMode;

    return MaterialApp(
      title: 'Flutter Demo',
      theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      debugShowCheckedModeBanner: false, // Mematikan banner debug
      home: const ExplorePage(selectedCategory: 'Category1'),
    );
  }
}
