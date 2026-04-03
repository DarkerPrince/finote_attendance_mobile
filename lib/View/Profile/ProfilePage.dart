import 'package:finote_program/Models/UserModel.dart';
import 'package:finote_program/View/Auth/AuthPage.dart';
import 'package:finote_program/View/ControllersPage/ControllersPage.dart';
import 'package:finote_program/features/auth/auth_bloc.dart';
import 'package:finote_program/features/auth/auth_event.dart';
import 'package:finote_program/features/auth/auth_state.dart';
import 'package:finote_program/utils/dateUtils.dart';
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

  Future<void> _handleLogout() async {
    final confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Logout"),
        content: const Text("Are you sure you want to logout?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Logout"),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('authToken');
    await prefs.remove('user');
    await prefs.setBool('isLoggedIn', false);

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const AuthPage()),
    );
  }

  bool isUserAdminOrController(UserModel user){
    return (user.role ?? []).any((role) {
      final title = (role['title'] ?? '').toLowerCase();
      return title == 'admin' || title == 'controller';
    });
  }

  Widget ProgramManagementButton(UserModel user){
    if (!isUserAdminOrController(user)) return const SizedBox(); // hide completely

    return Card(
      shadowColor: Colors.blueAccent.withOpacity(0.4),
      elevation: 4,
      shape: Border.all(color: Colors.blueAccent),
      child: ListTile(
        leading: const Icon(Icons.list_alt, color: Colors.blueAccent),
        title: const Text(
          "Program Management",
          style: TextStyle(color: Colors.blueAccent),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ControllersPage(userId: user.id),
            ),
          );
        },
      ),
    );
  }



  int getDaysSince(String date) {
    try {
      final lastDate = DateTime.parse(date);
      final now = DateTime.now();

      return now.difference(lastDate).inDays;
    } catch (e) {
      return 999; // fallback (invalid date)
    }
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
    final daysSince = getDaysSince(user.lastAttendance ?? "2000-01-01");
    final isWarning = daysSince > 15;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _handleLogout,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              child: Icon(Icons.person ,color: Colors.white,size: 40,),
              backgroundColor: Colors.blueAccent,
            ),
            const SizedBox(height: 16),
            Text(user.name,
                style: const TextStyle(
                    fontSize: 22, fontWeight: FontWeight.bold ,color: Colors.blueGrey,)),
            const SizedBox(height: 4),
            Text(user.chr_name??"Baptism Name",
                style: TextStyle(fontSize: 14, color: Colors.grey[600])),
            const SizedBox(height: 12),
            // Text(user.bio ?? "No bio available", textAlign: TextAlign.center),
            // const SizedBox(height: 20),
            const Divider(),
            ListTile(
              leading: Icon(
                Icons.calendar_month_rounded,
                color: isWarning ? Colors.red : Colors.blueGrey,
              ),
              title: Text(
                formatDate(user.lastAttendance ?? "2000-01-01"),
                style: TextStyle(
                  color: isWarning ? Colors.red : Colors.black,
                  fontWeight: isWarning ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              subtitle: Text(
                isWarning
                    ? "⚠️ Last attendance was $daysSince days ago"
                    : "Last Attendance Date",
                style: TextStyle(
                  color: isWarning ? Colors.red : Colors.grey,
                ),
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.class_,color: Colors.blueGrey,),
              title: Text(user.className?['title'] ?? "N/A"),
              subtitle: const Text("Class"),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.house_rounded,color: Colors.blueGrey,),
              title: Text(user.department?['title'] ?? "N/A"),
              subtitle: const Text("Department"),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.phone,color: Colors.blueGrey,),
              title: Text(user.phone ?? "N/A"),
              subtitle: const Text("Phone Number"),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.email,color: Colors.blueGrey,),
              title: Text(user.email ?? "N/A"),
              subtitle: const Text("Email"),
            ),
            const Divider(),
            isUserAdminOrController(user)?ListTile(
              leading: const Icon(
                Icons.admin_panel_settings,
                color: Colors.blueGrey,
              ),
              title: Wrap(
              spacing: 6,
              runSpacing: 4,
              children: (user.role ?? []).map<Widget>((role) {
                return Chip(
                  padding: EdgeInsets.all(1),

                  label: Text(role['title'] ?? "N/A"),
                  backgroundColor: Colors.blueGrey.shade50,
                );
              }).toList(),
            ),
            ):Container(),
            ProgramManagementButton(user),

            // Card(
            //   shadowColor: Colors.blueAccent.withOpacity(0.4),
            //   elevation: 4,
            //   borderOnForeground: true,
            //   shape: Border.all(color: Colors.blueAccent),
            //
            //   child: ListTile(
            //     leading: const Icon(Icons.list_alt,color: Colors.blueAccent,),
            //     title: const Text("Program Management", style: TextStyle(color: Colors.blueAccent),),
            //     onTap: () {
            //       Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //             builder: (_) => ControllersPage(userId: user.id)),
            //       );
            //     },
            //   ),
            // ),
            const SizedBox(height: 20),
            // ElevatedButton.icon(
            //   onPressed: () async {
            //     // await clearUserLocally();
            //     final prefs = await SharedPreferences.getInstance();
            //     await prefs.remove('authToken');
            //     await prefs.remove('user');
            //     await prefs.setBool('isLoggedIn', false);
            //     Navigator.pushReplacement(
            //       context,
            //       MaterialPageRoute(builder: (_) => const AuthPage()),
            //     );
            //   },
            //   icon: const Icon(Icons.logout),
            //   label: const Text("Logout"),
            // ),
          ],
        ),
      ),
    );
  }
}
