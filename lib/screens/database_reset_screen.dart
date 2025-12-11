import 'package:flutter/material.dart';
import 'package:projek_mobile/database/database_service.dart';
import 'package:projek_mobile/data/db_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

class DatabaseResetScreen extends StatefulWidget {
  const DatabaseResetScreen({super.key});

  @override
  State<DatabaseResetScreen> createState() => _DatabaseResetScreenState();
}

class _DatabaseResetScreenState extends State<DatabaseResetScreen> {
  bool _running = false;
  String _status = 'Ready';

  Future<void> _resetAll() async {
    setState(() {
      _running = true;
      _status = 'Resetting databases...';
    });

    try {
      // reset app_database.db
      await DatabaseService.instance.resetDatabase();

      // reset legacy explore_courses.db
      try {
        await DbHelper.instance.close();
        final path = p.join(await getDatabasesPath(), 'explore_courses.db');
        await deleteDatabase(path);
      } catch (_) {
        // ignore if cannot delete legacy DB
      }

      // clear relevant SharedPreferences keys
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('is_logged_in');
      await prefs.remove('user_email');
      await prefs.remove('user_username');
      await prefs.remove('user_avatar_path');
      await prefs.remove('user_profile');

      setState(() {
        _status = 'Databases reset complete.';
      });
    } catch (e) {
      setState(() {
        _status = 'Reset failed: $e';
      });
    } finally {
      setState(() {
        _running = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reset Databases')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Status: $_status'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _running ? null : _resetAll,
              child:
                  _running
                      ? const CircularProgressIndicator()
                      : const Text('Reset all DB & prefs'),
            ),
            const SizedBox(height: 12),
            const Text(
              'NOTE: This will remove all local data (users, courses, prefs).',
            ),
          ],
        ),
      ),
    );
  }
}
