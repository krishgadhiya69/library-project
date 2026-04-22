import 'dart:convert';
import 'package:crypto/crypto.dart';
import '../utils/storage.dart';

class AuthService {

  static String encryptPassword(String password){
    return sha256.convert(utf8.encode(password)).toString();
  }

  static Future register(String email,String password) async{

    final encrypted = encryptPassword(password);

    await Storage.save("user",{
      "email":email,
      "password":encrypted
    });
  }

  static Future<bool> login(String email,String password) async{

    final user = await Storage.read("user");

    if(user==null) return false;

    String encrypted = encryptPassword(password);

    if(user["email"]==email && user["password"]==encrypted){
      return true;
    }

    return false;
  }

}