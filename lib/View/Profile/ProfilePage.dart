import 'package:finote_program/Models/UserModel.dart';
import 'package:finote_program/View/Auth/AuthPage.dart';
import 'package:finote_program/View/ControllersPage/ControllersPage.dart';
import 'package:finote_program/features/auth/auth_bloc.dart';
import 'package:finote_program/features/auth/auth_event.dart';
import 'package:finote_program/features/auth/auth_state.dart';
import 'package:finote_program/utils/userUtils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserModel? localUser;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = await getUserFromLocal();
    setState(() {
      localUser = user;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (localUser == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("No user data found"),
              ElevatedButton(
                onPressed: () {
                  // Navigate to login
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const AuthPage()),
                  );
                },
                child: const Text("Login"),
              ),
            ],
          ),
        ),
      );
    }

    final user = localUser!;

    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              child: Icon(Icons.person),
            ),
            const SizedBox(height: 16),
            Text(user.name,
                style: const TextStyle(
                    fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(user.email,
                style: TextStyle(fontSize: 14, color: Colors.grey[600])),
            const SizedBox(height: 12),
            Text(user.bio ?? "No bio available", textAlign: TextAlign.center),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.calendar_month_rounded),
              title: Text(user.lastAttendance ?? "N/A"),
              subtitle: const Text("Last Attended"),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.class_),
              title: Text(user.className?['title'] ?? "N/A"),
              subtitle: const Text("Class"),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.house_rounded),
              title: Text(user.department?['title'] ?? "N/A"),
              subtitle: const Text("Department"),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.phone),
              title: Text(user.phone ?? "N/A"),
              subtitle: const Text("Phone Number"),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.admin_panel_settings),
              title: Text(user.role?[0]['title'] ?? "N/A"),
              subtitle: const Text("Role"),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.list_alt),
              title: const Text("Controlling Programs"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => ControllersPage(userId: user.id)),
                );
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () async {
                // await clearUserLocally();
                final prefs = await SharedPreferences.getInstance();
                await prefs.remove('authToken');
                await prefs.remove('user');
                await prefs.setBool('isLoggedIn', false);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const AuthPage()),
                );
              },
              icon: const Icon(Icons.logout),
              label: const Text("Logout"),
            ),
          ],
        ),
      ),
    );
  }
}
