import 'dart:convert';
import 'package:finote_program/Models/AttendanceModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AttendanceRepository {
  String baseUrl;
  AttendanceRepository({required this.baseUrl});

  Future<List<AttendanceModel>> fetchAttendance(String userID) async {
    final url = Uri.parse("$baseUrl/$userID");

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

    print("TOKEN USED: $token");
    print("RESPONSE: ${response.body}");

    if (response.statusCode == 200) {

      final List jsonData = json.decode(response.body);
      print(" ========= \n\n\n Attendance For User Detail is $jsonData \n\n\n\ ========== \n\n\n");
      return jsonData.map((e) => AttendanceModel.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load programs");
    }
  }


}