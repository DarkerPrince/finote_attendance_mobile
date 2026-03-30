import 'dart:convert';

import 'package:finote_program/Constants/StringConstants.dart';
import 'package:finote_program/Models/AttendanceModel.dart';
import 'package:finote_program/Models/AttendanceUserModel.dart';
import 'package:finote_program/Models/UserModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AttendanceRepository {

  Future<List<GroupAttendanceModel>> fetchAttendance(String userID) async {
    final url = Uri.parse("$baseUrl/users/attendance-personal/$userID");

    // 🔑 Get token from storage
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // ✅ ADD TOKEN HERE
      },
    );

    // print("TOKEN USED: $token");
    // print("RESPONSE: ${response.body}");

    if (response.statusCode == 200) {

      final List jsonData = json.decode(response.body);
      // print(" ========= \n\n\n Attendance For User Detail is $jsonData \n\n\n\ ========== \n\n\n");

      return jsonData.map((e) => GroupAttendanceModel.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load programs");
    }
  }

  Future<List<AttendanceUserModel>> addAttendanceSystem(
      String programId,
      String controllerId,
      String statusId,
      List<String> membersId, // list of user IDs for bulk
      String? permissionReason,
      String? attendanceProgramDate
      ) async
  {

    final url = Uri.parse("$baseUrl/programs/attendance");

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    // Prepare attendance data
    Map<String, dynamic> attendanceData = {
      'controller_id': controllerId,
      'program_id': programId,
      'status_id': statusId,
      'createdat': attendanceProgramDate,
      'updatedat': DateTime.now().toIso8601String(),
      'user_id': membersId, // bulk list
      'permission_reason': permissionReason ?? "",
    };

    print("\n\n\n add Attendance Request Payload: ${attendanceData} \n\n\n");

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(attendanceData),
    );

    // print("TOKEN USED: $token");
    print("add Attendance RESPONSE: ${response.body}");

    List<AttendanceUserModel> attendanceUsersList = await fetchProgramAttendanceUsersList(programId);
    // final List<dynamic> jsonData = json.decode(response.body);
    print("JSON DATA ____ $attendanceUsersList");
    return attendanceUsersList;
  }

  Future<List<AttendanceUserModel>> fetchProgramAttendanceUsersList(programId) async {
    final url = Uri.parse("$baseUrl/programs/$programId");

    // 🔑 Get token from storage
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // ✅ ADD TOKEN HERE
      },
    );

    print(url);
    print("TOKEN USED: $token");
    print("RESPONSE: ${response.body}");
    final Map<String,dynamic> jsonData = json.decode(response.body);
    final List<dynamic> usersList = jsonData['users']??[];

    print(" ========= \n Fetch Program Attendance UsersList \n $usersList \n ========== \n\n\n");

    if (response.statusCode == 200) {
      final List<AttendanceUserModel> attendanceUsersList =
      usersList.map<AttendanceUserModel>((user) {

        return AttendanceUserModel(
          user: UserModel.fromJson(user),
          /// ✅ DEFAULT VALUES (your requirement)
          status: "Not Set",
          color: "#9E9E9E",
          // grey
        );

      }).toList();
      print(" ========= \n Fetch Program Attendance - JSONDATA $jsonData \n ========== \n\n\n");

      return attendanceUsersList;
    } else {
      throw Exception("Failed to load programs");
    }
  }

  Future<List<AttendanceUserModel>> fetchProgramActionTakenAttendanceUsersList(programId) async {
    final url = Uri.parse("$baseUrl/programs/attendance/$programId");

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final Map<String, dynamic> jsonData = json.decode(response.body);
    final List<dynamic> usersList = jsonData['users'] ?? [];

    final List<AttendanceUserModel> attendanceUsersList =
    usersList.map((item) => AttendanceUserModel.fromJson(item)).toList();

    return attendanceUsersList;
  }




}