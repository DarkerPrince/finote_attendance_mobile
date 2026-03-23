import 'package:finote_program/features/attendance/attendance_bloc.dart';
import 'package:finote_program/features/programs/program_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finote_program/features/auth/auth_bloc.dart';
import 'package:finote_program/View/HomePage.dart';
import 'package:finote_program/View/Auth/AuthPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {


  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {

    String baseUrl = "http://192.168.1.8:5001";
    // String baseUrl = "http://172.16.0.2:5001";
    // String baseUrl = "http://10.0.2.2:5001";
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => AuthBloc(baseUrl: "$baseUrl/auth/login"),
        ),
        BlocProvider<ProgramsBloc>(
          create: (_) => ProgramsBloc(baseUrl: "$baseUrl/programs"), // load programs immediately
        ),
        BlocProvider<AttendanceBloc>(
          create: (_) => AttendanceBloc(baseUrl: "$baseUrl/users/attendance"), // load programs immediately
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          useMaterial3: true,
        ),
        home: isLoggedIn ? const MyHomePage(title: "Home Page") : const AuthPage(),
      ),
    );
  }
}