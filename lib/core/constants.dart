import 'package:flutter/material.dart';

class AppConstants {
  static const String appName = 'E-Commerce App';
  static const String baseUrl = 'https://api.example.com';
  
  // Database
  static const String dbName = 'ecommerce.db';
  static const int dbVersion = 1;
  
  // Preferences
  static const String keyIsLoggedIn = 'is_logged_in';
  static const String keyUserId = 'user_id';
  static const String keyUserName = 'user_name';
  
  // Animation durations
  static const Duration defaultAnimation = Duration(milliseconds: 300);
  static const Duration splashDuration = Duration(seconds: 2);
}

class AppTheme {
  static const Color primaryColor = Color(0xFF2196F3);
  static const Color secondaryColor = Color(0xFFFF9800);
  static const Color errorColor = Color(0xFFE91E63);
  static const Color backgroundColor = Color(0xFFF5F5F5);
  
  static ThemeData get lightTheme {
    return ThemeData(
      primarySwatch: Colors.blue,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),

    );
  }
}