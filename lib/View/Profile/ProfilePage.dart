import 'package:finote_program/View/Auth/AuthPage.dart';
import 'package:finote_program/features/auth/auth_bloc.dart';
import 'package:finote_program/features/auth/auth_event.dart';
import 'package:finote_program/features/auth/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilePage extends StatelessWidget {
  String userId;
  ProfilePage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthInitial) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const AuthPage()),
                (route) => false, // remove all previous pages
          );
        }

      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Profile"),
          centerTitle: true,
        ),
        body: BlocBuilder<AuthBloc, AuthState>(
           builder: (context, state) {
          if (state is AuthAuthenticated) {
          final user = state.user;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Profile Picture
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(
                    user.image ?? "https://i.pravatar.cc/150?img=3",
                  ),
                ),

                const SizedBox(height: 16),

                // Name
                Text(
                  user.name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                // Email
                Text(
                  user.email,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),

                const SizedBox(height: 12),

                Text(
                  user.bio ?? "No bio available",
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 20),

                ListTile(
                  dense: true,
                  title: Text(user.className?['title'] ?? "N/A"),
                  subtitle: const Text("Class"),
                  leading: const Icon(Icons.class_),
                ),
                const Divider(),

                ListTile(
                  dense: true,
                  title: Text(user.department?['title'] ?? "N/A"),
                  subtitle: const Text("Department"),
                  leading: const Icon(Icons.house_rounded),
                ),
                const Divider(),

                ListTile(
                  dense: true,
                  title: Text(user.lastAttendance ?? "N/A"),
                  subtitle: const Text("Last Attended"),
                  leading: const Icon(Icons.calendar_month_rounded),
                ),
                const Divider(),

                ListTile(
                  dense: true,
                  title: Text(user.phone ?? "N/A"),
                  subtitle: const Text("Phone Number"),
                  leading: const Icon(Icons.phone),
                ),
                const Divider(),

                ListTile(
                  dense: true,
                  title: Text(user.role?[0]['title'] ?? "N/A"),
                  subtitle: const Text("Role"),
                  leading: const Icon(Icons.admin_panel_settings),
                ),

                const SizedBox(height: 20),

                ElevatedButton.icon(
                  onPressed: () {
                    context.read<AuthBloc>().add(LogoutRequested());
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text("Logout"),
                ),
              ],
            ),
          );
        }

        if (state is AuthLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return Center(child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Not logged in"),
            ElevatedButton.icon(
              onPressed: () {
                context.read<AuthBloc>().add(LogoutRequested());
              },
              icon: const Icon(Icons.logout),
              label: const Text("Login TO Account"),
            ),
          ],
        ));
      },
      )
      ),
    );
  }
}
