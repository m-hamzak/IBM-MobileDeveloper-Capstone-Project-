import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
// Function to save user profile data
  static Future<void> saveUserProfile(Map<String, dynamic> profile) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userProfile', jsonEncode(profile));
  }

  // Function to retrieve user profile data
  static Future<Map<String, dynamic>?> getUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final profileString = prefs.getString('userProfile');
    return profileString != null ? jsonDecode(profileString) : null;
  }

  static Future<void> saveUserAction(String action) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> actions = prefs.getStringList('userActions') ?? [];
    actions.add(action);
    await prefs.setStringList('userActions', actions);
  }
}
