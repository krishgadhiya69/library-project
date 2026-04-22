import 'package:flutter/material.dart';
import '../screens/login_screen.dart';
import '../screens/register_screen.dart';
import '../screens/dashboard_screen.dart';
import '../screens/add_book_screen.dart';
import '../screens/edit_book_screen.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> routes = {
    "/login": (context) => const LoginScreen(),
    "/register": (context) => const RegisterScreen(),
    "/dashboard": (context) => const DashboardScreen(),
    "/addBook": (context) => const AddBookScreen(),
    "/editBook": (context) => const EditBookScreen(book: {} ),
  };
}