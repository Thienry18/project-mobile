import 'package:flutter/material.dart';
import 'package:projek_mobile/services/api_service.dart';

class ApiDemoScreen extends StatefulWidget {
  const ApiDemoScreen({super.key});

  @override
  State<ApiDemoScreen> createState() => _ApiDemoScreenState();
}

class _ApiDemoScreenState extends State<ApiDemoScreen> {
  final ApiService api = ApiService(
    baseUrl: 'http://10.0.2.2:4000',
  ); // use emulator host
  String _status = 'idle';
  List _courses = [];

  Future<void> _loadCourses() async {
    setState(() => _status = 'loading');
    try {
      final res = await api.get('/courses');
      setState(() {
        _courses = res['body'];
        _status = 'loaded ${_courses.length}';
      });
    } catch (e) {
      setState(() => _status = 'error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _loadCourses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('API Demo')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Status: $_status'),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: _courses.length,
                itemBuilder: (context, i) {
                  final c = _courses[i];
                  return ListTile(
                    title: Text(c['title'] ?? c['name'] ?? 'Untitled'),
                    subtitle: Text('Instructor: ${c['instructor'] ?? '-'}'),
                    trailing: Text(c['price'] ?? '-'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
