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
    return AttendanceUserModel(
      user: UserModel.fromJson(json['user']),
      status: json['status']?['title'] ?? "Unknown",
      color: json['status']?['color'] ?? "#000000"
    );
  }
}