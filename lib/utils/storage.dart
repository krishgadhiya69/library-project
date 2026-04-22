import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Storage {
  static Future save(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, jsonEncode(value));
  }

  static Future<dynamic> read(String key) async {
    final prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString(key);
    if (data == null) return null;
    return jsonDecode(data);
  }
}