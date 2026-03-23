import 'dart:convert';
import 'package:finote_program/Models/UserModel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final String baseUrl;

  AuthBloc({required this.baseUrl}) : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onLoginRequested(
      LoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': event.email,
          'password': event.password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        print("the login data information is $data");

        // Expecting the API to return a token and optionally user info
        final token = data['token'];
        final userID = data['user']['id'] ?? event.email;
        final user = UserModel.fromJson(data['user']);

        // Save token locally for future API requests
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('userId', userID);

        emit(AuthAuthenticated(user));
      } else {
        // Handle API errors
        final errorData = jsonDecode(response.body);
        print("the else exception is $errorData");
        emit(AuthError(errorData['message'] ?? 'Login failed'));
      }
    } catch (e) {
      print("the Catch exception is $e");
      emit(AuthError('Login failed: ${e.toString()}'));
    }
  }

  Future<void> _onLogoutRequested(
      LogoutRequested event, Emitter<AuthState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('authToken');
    await prefs.setBool('isLoggedIn', false);
    emit(AuthInitial());
  }
}