
import 'dart:convert';
import 'package:finote_program/Models/UserModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<UserModel?> getUserFromLocal() async {
  final prefs = await SharedPreferences.getInstance();
  final userString = prefs.getString('user');
  if (userString != null) {
    return UserModel.fromJson(jsonDecode(userString));
  }
  return null;
}

Future<void> loadUserToLocal(UserModel user) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString('user', jsonEncode(user.toJson()));
}