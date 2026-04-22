import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class BookService {

  static Future<List> loadBooks() async {

    final prefs = await SharedPreferences.getInstance();

    final data = prefs.getString("books");

    if(data==null){
      return [];
    }

    return jsonDecode(data);
  }

  static Future saveBooks(List books) async {

    final prefs = await SharedPreferences.getInstance();

    prefs.setString("books", jsonEncode(books));

  }

}