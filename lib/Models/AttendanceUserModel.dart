import 'package:finote_program/Models/UserModel.dart';

class AttendanceUserModel {
  final UserModel user;
  final String status;
  final String color;

  AttendanceUserModel({
    required this.user,
    required this.status,
    required this.color
  });

  factory AttendanceUserModel.fromJson(Map<String, dynamic> json) {
    final userData = json['user'];
    return AttendanceUserModel(
      user: userData is Map<String, dynamic> ? UserModel.fromJson(userData) : UserModel(id: "", name: "", email: ""),
      status: json['status']?['title'] ?? "Unknown",
      color: json['status']?['color'] ?? "#000000"
    );
  }
}