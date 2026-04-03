import 'package:finote_program/View/OnboardingScreen.dart';
import 'package:finote_program/View/SplashScreen.dart';
import 'package:finote_program/features/attendance/attendance_bloc.dart';
import 'package:finote_program/features/programs/program_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final seenOnboarding = prefs.getBool('seenOnboarding') ?? false;

  runApp(MyApp(isLoggedIn: isLoggedIn,userId: userId??"",seenOnboarding: seenOnboarding,));
}

class MyApp extends StatelessWidget {


  final bool isLoggedIn;
  final String userId;
  final bool seenOnboarding;


  const MyApp({super.key, required this.isLoggedIn, required this.userId, required this.seenOnboarding,});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => AuthBloc(),
        ),
        BlocProvider<ProgramsBloc>(
          create: (_) => ProgramsBloc(), // load programs immediately
        ),
        BlocProvider<AttendanceBloc>(
          create: (_) => AttendanceBloc(), // load programs immediately
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: false,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            elevation: 0,

            // Back button & default icons
            iconTheme: IconThemeData(
              color: Colors.blueAccent,
            ),

            // Action icons (right side)
            actionsIconTheme: IconThemeData(
              color: Colors.blueAccent,
            ),

            // Title text
            titleTextStyle: TextStyle(
              color: Colors.blueAccent,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),

            // Status bar (top icons: battery, time)
            systemOverlayStyle: SystemUiOverlayStyle.dark,
          ),
        ),
        home: !seenOnboarding
            ? const OnboardingScreen()
            : (isLoggedIn
            ? MyHomePage(userId: userId)
            : const AuthPage()),
      ),
    );
  }
}