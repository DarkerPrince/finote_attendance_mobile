import 'package:finote_program/Constants/StringConstants.dart';
import 'package:finote_program/Models/AttendanceUserModel.dart';
import 'package:finote_program/Models/ProgramModel.dart';
import 'package:finote_program/Models/UserModel.dart';
import 'package:finote_program/features/attendance/attendance_bloc.dart';
import 'package:finote_program/features/attendance/attendance_event.dart';
import 'package:finote_program/features/attendance/attendance_state.dart';
import 'package:finote_program/utils/userUtils.dart';
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

  /// User currently being updated (shows inline progress)
  String? updatingUserId;

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
  void showStatusOptions(AttendanceUserModel member) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  "Update attendance · ${member.user.name}",
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.check_circle, color: Colors.green),
                title: const Text("Present"),
                onTap: () {
                  Navigator.pop(context);
                  updateAttendanceStatus(member.user.id, statusPresentId);
                },
              ),
              ListTile(
                leading: const Icon(Icons.cancel, color: Colors.red),
                title: const Text("Absent"),
                onTap: () {
                  Navigator.pop(context);
                  updateAttendanceStatus(member.user.id, statusAbsentId);
                },
              ),
              ListTile(
                leading:
                    const Icon(Icons.assignment_late, color: Colors.orange),
                title: const Text("By Permission"),
                onTap: () {
                  Navigator.pop(context);
                  updateAttendanceStatus(member.user.id, statusPermissionId);
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  /// 🔹 Dispatch update event for a single member
  Future<void> updateAttendanceStatus(String userId, String statusId) async {
    try {
      UserModel? userMap = await getUserFromLocal();

      setState(() {
        updatingUserId = userId;
      });

      context.read<AttendanceBloc>().add(
            UpdateProgramAttendance(
              programId: widget.program.id,
              userId: userId,
              statusId: statusId,
              controllerId: userMap!.id,
              programDate: widget.program.fullProgramDate ??
                  DateTime.now().toIso8601String(),
            ),
          );
    } catch (e) {
      setState(() {
        updatingUserId = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AttendanceBloc, AttendanceState>(
      listenWhen: (prev, curr) => curr is AttendanceError,
      listener: (context, state) {
        setState(() {
          updatingUserId = null;
        });

        if ((state as AttendanceError).message.contains("update")) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Failed to update attendance"),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: BlocBuilder<AttendanceBloc, AttendanceState>(
        builder: (context, state) {
        if (state is AttendanceLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is AttendanceError) {
          return Center(child: Text(state.message));
        }
        if (state is AttendanceLoaded_ProgramUsersList) {
          final usersList = state.usersList;

          if (usersList.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    size: 64,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No attendance taken yet',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Mark attendance from the "All" tab',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            );
          }

          // Count members by status
          int presentCount = 0;
          int absentCount = 0;
          int permissionCount = 0;
          int otherCount = 0;

          for (var member in usersList) {
            switch (member.status.toLowerCase()) {
              case 'present':
                presentCount++;
                break;
              case 'absent':
                absentCount++;
                break;
              case 'by permission':
                permissionCount++;
                break;
              default:
                otherCount++;
                break;
            }
          }

          return Column(
            children: [
              // Status summary row
              Container(
                margin: const EdgeInsets.all(12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatusCount('Present', presentCount, Colors.green),
                    _buildStatusCount('Absent', absentCount, Colors.red),
                    _buildStatusCount('Permission', permissionCount, Colors.orange),
                  ],
                ),
              ),
              // Total count
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Total: ${usersList.length} members',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // List of users
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

        return const Center(child: Text('Attendance List Page'));
      },
      ),
    );
  }

  Widget _buildStatusCount(String label, int count, Color color) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              count.toString(),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  /// 🔹 Single User Card
  Widget usersAttendanceCard(AttendanceUserModel member, int index) {
    final isUpdating = updatingUserId == member.user.id;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 3,
      child: ListTile(
        onLongPress:
            isUpdating ? null : () => showStatusOptions(member),
        title: Text(member.user.name),
        subtitle: Text(member.user.email),
        trailing: isUpdating
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: getStatusColor(member.status).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  member.status,
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