import 'package:finote_program/Models/ProgramModel.dart';
import 'package:finote_program/Models/UserModel.dart';
import 'package:finote_program/features/attendance/attendance_bloc.dart';
import 'package:finote_program/features/attendance/attendance_event.dart';
import 'package:finote_program/features/attendance/attendance_state.dart';
import 'package:finote_program/utils/userUtils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// 🔹 Raw Attendance Page
class RawAttendanceListPage extends StatefulWidget {
  final ProgramModel program;

  const RawAttendanceListPage({super.key, required this.program});

  @override
  State<RawAttendanceListPage> createState() =>
      _RawAttendanceListPageState();
}

class _RawAttendanceListPageState
    extends State<RawAttendanceListPage> {

  /// Selected user IDs
  Set<String> selectedAttendanceUser = {};

  /// Optimistically removed users
  Set<String> completedAttendanceUsers = {};

  @override
  void initState() {
    super.initState();
    context.read<AttendanceBloc>().add(
      LoadProgramAttendanceListUsers(programId: widget.program.id),
    );
  }

  /// 🔹 Toggle selection
  void toggleSelection(String memberId) {
    setState(() {
      if (selectedAttendanceUser.contains(memberId)) {
        selectedAttendanceUser.remove(memberId);
      } else {
        selectedAttendanceUser.add(memberId);
      }
    });
  }

  /// 🔥 OPTIMISTIC BULK ACTION
  Future<void> bulkAction(String status, bool isPermission) async {
    final selected = Set<String>.from(selectedAttendanceUser);

    /// 🔥 Step 1: Optimistic UI update
    setState(() {
      completedAttendanceUsers.addAll(selected);
      selectedAttendanceUser.clear();
    });

    try {
      UserModel? userMap = await getUserFromLocal();

      context.read<AttendanceBloc>().add(
        SetAttendanceProgram(
          users: selected.toList(),
          statusId: status,
          permissionReason: "Nothing",
          programId: widget.program.id,
          controllerId: userMap!.id,
          programDate: widget.program.fullProgramDate ??
              DateTime.now().toIso8601String(),
        ),
      );
    } catch (e) {
      /// ❌ Rollback if something crashes immediately
      setState(() {
        completedAttendanceUsers.removeAll(selected);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AttendanceBloc, AttendanceState>(
      listener: (context, state) {
        /// ❌ API failed → rollback UI
        if (state is AttendanceError) {
          setState(() {
            completedAttendanceUsers.clear();
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Failed to update attendance"),
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

            /// 🔥 Filter out optimistically removed users
            final filteredUsers = usersList
                .where((u) =>
                    !completedAttendanceUsers.contains(u.user.id))
                .toList();

            return Column(
              children: [
                /// 🔹 Selected count
                if (selectedAttendanceUser.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Selected: ${selectedAttendanceUser.length}",
                    ),
                  ),

                /// 🔹 Bulk buttons
                bulkActionsButtons(),

                /// 🔹 Users list
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredUsers.length,
                    itemBuilder: (context, index) {
                      final member = filteredUsers[index];
                      return userAttendanceCard(member.user);
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

  /// 🔹 Bulk action buttons
  Widget bulkActionsButtons() {
    final isEnabled = selectedAttendanceUser.isNotEmpty;

    if (!isEnabled) return const SizedBox();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
            onPressed: () => bulkAction(
                "2549bf8f-8bfb-48ba-9fc0-ec606472c6a2", false),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
            ),
            child: const Text("Present",
                style: TextStyle(color: Colors.white)),
          ),
          ElevatedButton(
            onPressed: () => bulkAction(
                "02a27517-b5ab-4e9d-a6cb-89de56a6c03a", false),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text("Absent",
                style: TextStyle(color: Colors.white)),
          ),
          ElevatedButton(
            onPressed: () => bulkAction(
                "40d11aab-f71a-470a-abfd-4c620b895f0e", true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
            ),
            child: const Text("Permission",
                style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }

  /// 🔹 Check selection
  bool isSelected(String memberId) {
    return selectedAttendanceUser.contains(memberId);
  }

  /// 🔹 User Card
  Widget userAttendanceCard(UserModel member) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: isSelected(member.id)
            ? Colors.blueAccent.withOpacity(0.2)
            : Colors.white,
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: ListTile(
        dense: true,
        onTap: () => toggleSelection(member.id),
        onLongPress: () => toggleSelection(member.id),
        leading: Checkbox(
          value: isSelected(member.id),
          onChanged: (_) => toggleSelection(member.id),
        ),
        title: Text(
          member.name,
          style: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.w500),
        ),
        subtitle: Text(
          member.email.isEmpty
              ? "email@finote1619.com"
              : member.email,
        ),
      ),
    );
  }
}