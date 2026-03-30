import 'package:finote_program/Models/AttendanceUserModel.dart';
import 'package:finote_program/Models/ProgramModel.dart';
import 'package:finote_program/Models/UserModel.dart';
import 'package:finote_program/View/Program/ProgramDetailPage.dart';
import 'package:finote_program/features/attendance/attendance_bloc.dart';
import 'package:finote_program/features/attendance/attendance_event.dart';
import 'package:finote_program/features/attendance/attendance_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// 🔹 Attendance Page
class ActionTakenUsersListPage extends StatefulWidget {
  final ProgramModel program;
  ActionTakenUsersListPage({super.key, required this.program});

  @override
  State<ActionTakenUsersListPage> createState() =>
      _ActionTakenUsersListPageState();
}

class _ActionTakenUsersListPageState extends State<ActionTakenUsersListPage> {
  // Store selected user IDs
 late String selectedAttendanceUser ;

  @override
  void initState() {
    super.initState();
    context.read<AttendanceBloc>().add(
        LoadProgramAttendanceActionTakenListUsers(programId: widget.program.id));
  }

  /// 🔹 Status color helper
  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case "present":
        return Colors.green;
      case "absent":
        return Colors.red;
      case "by permission":
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  /// 🔹 Show options for a single member
  void showStatusOptions(int index, String UserID ) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text("Present"),
              onTap: () {
                // TODO: Update user status
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text("Absent"),
              onTap: () {
                // TODO: Update user status
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text("By Permission"),
              onTap: () {
                // TODO: Update user status
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  /// 🔹 Check if user is selected
  bool checkIfUserIsSelected(String memberId) {
    return selectedAttendanceUser.contains(memberId);
  }

  /// 🔹 Toggle selection
  // void toggleSelection(String memberId) {
  //   setState(() {
  //     if (selectedAttendanceUser.contains(memberId)) {
  //       selectedAttendanceUser.remove(memberId);
  //     } else {
  //       selectedAttendanceUser.add(memberId);
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AttendanceBloc, AttendanceState>(
      builder: (context, state) {
        if (state is AttendanceLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is AttendanceError) {
          return Center(child: Text(state.message));
        }
        if (state is AttendanceLoaded_ProgramUsersList) {
          final usersList = state.usersList;

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 🔹 List of users
              Expanded(
                child: ListView.builder(
                  itemCount: usersList.length,
                  itemBuilder: (context, index) {
                    final member = usersList[index];
                    return usersAttendanceCard(member, index);
                  },
                ),
              ),
            ],
          );
        }

        return const Center(child: Text('AttendanceList Page'));
      },
    );
  }

  /// 🔹 Single User Card
  Widget usersAttendanceCard(AttendanceUserModel member, int index) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 3,
      child: ListTile(
        onLongPress: () => showStatusOptions(index , member.user.id),
        // onTap: () {
        //   if (selectedAttendanceUser.isNotEmpty) {
        //     toggleSelection(member.id);
        //   } else {
        //     showStatusOptions(index);
        //   }
        // },
        title: Text(member.user.name),
        subtitle: Text(member.user.email),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: getStatusColor(member.status).withOpacity(0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            member.status, // TODO: Replace with actual member status
            style: TextStyle(
              color: getStatusColor(member.status),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}