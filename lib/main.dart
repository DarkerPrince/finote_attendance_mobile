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
  final userId = prefs.getString('userId') ?? null;

  runApp(MyApp(isLoggedIn: isLoggedIn,userId: userId??"",));
}

class MyApp extends StatelessWidget {


  final bool isLoggedIn;
  final String userId;

  const MyApp({super.key, required this.isLoggedIn, required this.userId});

  @override
  Widget build(BuildContext context) {

    // String baseUrl = "http://192.168.1.8:5001";
    String baseUrl = "http://172.20.10.5:5001";
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
          create: (_) => AttendanceBloc(baseUrl: "$baseUrl/users/attendance-personal"), // load programs immediately
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          useMaterial3: true,
        ),
        home: isLoggedIn ? MyHomePage(userId: userId ) : const AuthPage(),
      ),
    );
  }
}