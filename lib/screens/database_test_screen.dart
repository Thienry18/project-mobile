import 'package:flutter/material.dart';
import '../database/database_service.dart';
import '../database/database_user.dart';
import '../database/database_course.dart';
import '../database/database_cart.dart';
import '../database/database_mycourse.dart';
import '../database/database_notification.dart';

class DatabaseTestScreen extends StatefulWidget {
  const DatabaseTestScreen({super.key});

  @override
  State<DatabaseTestScreen> createState() => _DatabaseTestScreenState();
}

class _DatabaseTestScreenState extends State<DatabaseTestScreen> {
  final dbService = DatabaseService.instance;
  String logText = "";

  void _log(String text) {
    setState(() => logText += "$text\n");
  }

  Future<void> _addUser() async {
    final db = await dbService.database;
    final id = await DatabaseUser.insertUser(db, {
      'username': 'athienz',
      'fullname': 'Athien Zeng',
      'day_of_birth': '2001-05-05',
      'gender': 'Female',
      'phone_number': '08123456789',
      'country': 'Indonesia',
      'email': 'athien@example.com',
      'password': 'hashedpassword123',
    });
    _log("✅ User ditambahkan (id: $id)");
  }

  Future<void> _addCourse() async {
    final db = await dbService.database;
    final id = await DatabaseCourse.insertCourse(db, {
      'idx': 1,
      'images': 'flutter.png',
      'title': 'Flutter Masterclass',
      'duration': '12h',
      'rating_text': '4.8',
      'rating_number': 4.8,
      'price': 'Rp 250.000',
      'is_bestseller': 1,
      'category': 'Programming',
      'instructor': 'John Doe',
      'language': 'English',
      'subtitle': 'Indonesian',
    });
    _log("✅ Course ditambahkan (id: $id)");
  }

  Future<void> _addToCart() async {
    final db = await dbService.database;
    await DatabaseCart.addToCart(db, {
      'user_id': 1,
      'course_id': 1,
      'title': 'Flutter Masterclass',
      'price': 'Rp 250.000',
      'instructor': 'John Doe',
      'image': 'flutter.png',
      'added_at': DateTime.now().millisecondsSinceEpoch,
    });
    _log("✅ Course dimasukkan ke Cart");
  }

  Future<void> _checkout() async {
    final db = await dbService.database;

    // Ambil data cart user 1
    final carts = await DatabaseCart.getUserCart(db, 1);
    if (carts.isEmpty) {
      _log("⚠️ Cart kosong");
      return;
    }

    for (final cart in carts) {
      await DatabaseMyCourse.addMyCourse(db, {
        'user_id': cart['user_id'],
        'course_id': cart['course_id'],
        'title': cart['title'],
        'instructor': cart['instructor'],
        'image': cart['image'],
        'price': cart['price'],
        'purchased_at': DateTime.now().millisecondsSinceEpoch,
      });

      await DatabaseNotification.insertNotification(db, {
        'user_id': cart['user_id'],
        'title': 'Pembelian Berhasil',
        'message': 'Kamu telah membeli ${cart['title']}',
        'course_title': cart['title'],
        'course_image': cart['image'],
        'course_price': cart['price'],
        'created_at': DateTime.now().millisecondsSinceEpoch,
      });
    }

    await DatabaseCart.clearUserCart(db, 1);
    _log(
      "💳 Checkout sukses → Cart dikosongkan, MyCourse & Notifikasi ditambahkan",
    );
  }

  Future<void> _showAllData() async {
    final db = await dbService.database;

    final users = await DatabaseUser.getAllUsers(db);
    final courses = await DatabaseCourse.getAllCourses(db);
    final carts = await DatabaseCart.getUserCart(db, 1);
    final myCourses = await DatabaseMyCourse.getMyCourses(db, 1);
    final notifs = await DatabaseNotification.getUserNotifications(db, 1);

    _log("=== DATA SAAT INI ===");
    _log("👤 Users: ${users.length}");
    _log("📚 Courses: ${courses.length}");
    _log("🛒 Cart: ${carts.length}");
    _log("🎓 MyCourse: ${myCourses.length}");
    _log("🔔 Notifications: ${notifs.length}");
  }

  Future<void> _clearAll() async {
    final db = await dbService.database;
    await db.delete('users');
    await db.delete('courses');
    await db.delete('cart');
    await db.delete('mycourse');
    await db.delete('notifications');
    _log("🧹 Semua tabel dikosongkan");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Database Test")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton(
                  onPressed: _addUser,
                  child: const Text("Tambah User"),
                ),
                ElevatedButton(
                  onPressed: _addCourse,
                  child: const Text("Tambah Course"),
                ),
                ElevatedButton(
                  onPressed: _addToCart,
                  child: const Text("Tambah ke Cart"),
                ),
                ElevatedButton(
                  onPressed: _checkout,
                  child: const Text("Checkout"),
                ),
                ElevatedButton(
                  onPressed: _showAllData,
                  child: const Text("Lihat Semua"),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: _clearAll,
                  child: const Text("Hapus Semua"),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  logText,
                  style: const TextStyle(fontFamily: 'monospace'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
