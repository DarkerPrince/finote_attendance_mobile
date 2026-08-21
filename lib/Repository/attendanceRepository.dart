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

      final Map<String, dynamic> decoded = json.decode(response.body);

      final List<dynamic> data = decoded['data'] ?? [];

      return data
          .map(
            (e) => GroupAttendanceModel.fromJson(
          e as Map<String, dynamic>,
        ),
      )
          .toList();
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

  /// 🔹 Update an existing attendance status (backend upserts on same endpoint)
  Future<List<AttendanceUserModel>> updateAttendanceStatus({
    required String programId,
    required String controllerId,
    required String userId,
    required String statusId,
    String? programDate,
  }) async {
    final url = Uri.parse("$baseUrl/programs/attendance");

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    Map<String, dynamic> attendanceData = {
      'controller_id': controllerId,
      'program_id': programId,
      'status_id': statusId,
      'createdat': programDate ?? DateTime.now().toIso8601String(),
      'updatedat': DateTime.now().toIso8601String(),
      'user_id': [userId],
      'permission_reason': "",
    };

    print("update Attendance Request Payload: $attendanceData");

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(attendanceData),
    );

    print("update Attendance RESPONSE: ${response.body}");

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception("Failed to update attendance: ${response.statusCode}");
    }

    return fetchProgramActionTakenAttendanceUsersList(programId);
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
      usersList.map<AttendanceUserModel>((userData) {

        // 1. Extract the status from the API response (adjust the key name if your API uses something else)
        // We use ?? to provide a default if the API field is null
        final String apiStatus = userData['status'] ?? "Not Set";

        // 2. Determine color based on the status
        String statusColor;
        switch (apiStatus.toLowerCase()) {
          case 'present':
            statusColor = "#4CAF50"; // Green
            break;
          case 'absent':
            statusColor = "#F44336"; // Red
            break;
          case 'permission':
            statusColor = "#FFC107"; // Amber/Yellow
            break;
          default:
            statusColor = "#9E9E9E"; // Grey
        }

        return AttendanceUserModel(
          user: UserModel.fromJson(userData),
          status: apiStatus, // ✅ Use the value from API
          color: statusColor, // ✅ Use the dynamic color
        );

      }).toList();

      return attendanceUsersList;
    } else {
      throw Exception("Failed to load programs");
    }
  }

  Future<List<AttendanceUserModel>>
  fetchProgramActionTakenAttendanceUsersList(String programId) async {
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

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);

      // API response:
      // {
      //   attendanceSummary: {...},
      //   data: [ ... ],
      //   pagination: {...}
      // }
      final List<dynamic> usersList = jsonData['data'] ?? [];

      print(
        "=========\n"
            "Fetch Program Attendance Action Taken UsersList\n"
            "Total: ${usersList.length}\n"
            "$usersList\n"
            "=========\n",
      );

      return usersList
          .map(
            (item) => AttendanceUserModel.fromJson(
          item as Map<String, dynamic>,
        ),
      )
          .toList();
    } else {
      throw Exception(
        "Failed to fetch attendance users: ${response.statusCode}",
      );
    }
  }




}