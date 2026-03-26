
import 'dart:convert';
import 'package:finote_program/Models/ProgramModel.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProgramsRepository {
  String baseUrl;
  ProgramsRepository({required this.baseUrl});
  // Fetch attendance list from API
  Future<List<ProgramModel>> fetchPrograms() async {
    final url = Uri.parse('$baseUrl/programs');

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

      return jsonData.map((e) => ProgramModel.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load programs");
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

    print("TOKEN USED: $token");
    print("RESPONSE: ${response.body}");

    if (response.statusCode == 200) {
      final Map<String,dynamic> jsonData = json.decode(response.body);
      print("the list of Controlled Programs are $jsonData");
      final List controllersPrograms  = jsonData['controllers'];
      return controllersPrograms.map((e) => ProgramModel.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load programs");
    }
  }
}