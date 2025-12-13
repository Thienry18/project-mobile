import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

class ContactsHelper {
  static Future<List<Contact>> getContacts(BuildContext context) async {
    if (!await FlutterContacts.requestPermission()) {
      // permission denied
      return [];
    }
    return await FlutterContacts.getContacts(withProperties: true);
  }

  static Future<bool> addContact(Contact contact) async {
    try {
      await FlutterContacts.insertContact(contact);
      return true;
    } catch (_) {
      return false;
    }
  }
}
