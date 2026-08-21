
import 'dart:convert';
import 'package:finote_program/Constants/StringConstants.dart';
import 'package:finote_program/Models/ProgramModel.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProgramsRepository {
  ProgramsRepository();
  // Fetch attendance list from API
  Future<List<ProgramModel>> fetchPrograms(String userId) async {
    final url = Uri.parse('$baseUrl/programs/personalized/$userId');

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print("GETTING PERSONALIZED PROGRAM URL: $url");
    print("RESPONSE: ${response.body}");

    if (response.statusCode == 200) {
      print("Response is 200 so start with that");

      // Decode the complete response as a Map
      final Map<String, dynamic> responseData =
      json.decode(response.body);

      final programs = responseData['data'];

      if (programs is! List) {
        print("Programs data is not a list: ${programs.runtimeType} - $programs");
        return [];
      }

      return programs
          .map((e) => ProgramModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception(
        "Failed to load programs: ${response.statusCode}",
      );
    }
  }
  Future<List<ProgramModel>> fetchControllerProgramsRepository(userId) async {
    final url = Uri.parse('$baseUrl/users/controller-program/$userId');


    print(url);
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

    print("RESPONSE: ${response.body}");

    if (response.statusCode == 200) {
      final Map<String,dynamic> jsonData = json.decode(response.body);
      print("the list of Controlled Programs are $jsonData");
      final programs = jsonData['data'];
      if (programs is! List) {
        throw const FormatException(
          "Controller programs response does not contain a data list",
        );
      }

      return programs
          .map((item) => ProgramModel.fromControllerJson(
                Map<String, dynamic>.from(item as Map),
              ))
          .toList();
    } else {
      throw Exception("Failed to load programs");
    }
  }
}