import 'package:finote_program/Models/ProgramModel.dart';
import 'package:finote_program/Models/UserModel.dart';
import 'package:finote_program/features/attendance/attendance_bloc.dart';
import 'package:finote_program/features/attendance/attendance_event.dart';
import 'package:finote_program/features/attendance/attendance_state.dart';
import 'package:finote_program/utils/userUtils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 🔹 Raw Attendance Page
class RawAttendanceListPage extends StatefulWidget {
  final ProgramModel program;
  RawAttendanceListPage({super.key, required this.program});

  @override
  State<RawAttendanceListPage> createState() => _RawAttendanceListPageState();
}

class _RawAttendanceListPageState extends State<RawAttendanceListPage> {
  /// Selected user IDs
  Set<String> selectedAttendanceUser = {};

  @override
  void initState() {
    super.initState();
    context.read<AttendanceBloc>().add(
        LoadProgramAttendanceListUsers(programId: widget.program.id));

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

  /// 🔹 Show status options for single user
  void showStatusOptions(int index) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text("Present"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text("Absent"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text("By Permission"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  /// 🔹 Toggle user selection
  void toggleSelection(String memberId) {
    setState(() {
      if (selectedAttendanceUser.contains(memberId)) {
        selectedAttendanceUser.remove(memberId);
      } else {
        selectedAttendanceUser.add(memberId);
      }
    });
  }

  Set<String> completedAttendanceUsers = {};

  /// 🔹 Bulk action callback
  bulkAction(String status,bool isPermission) async{
    print("Updating users ${selectedAttendanceUser.toList()} to $status");

     UserModel? userMap  = await getUserFromLocal();

    // TODO: Dispatch your Bloc event here for bulk update
    context.read<AttendanceBloc>().add(setAttendanceProgram(
      users: selectedAttendanceUser.toList(),
      statusId: status,
      permissionReason: "Permission Reason",
      programId: widget.program.id,
      controllerId: userMap!.id
    ));

    setState(() {
      // completedAttendanceUsers.addAll(selectedAttendanceUser);
      selectedAttendanceUser.clear(); // clear selection after action
    });

  }

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
            children: [
              /// 🔹 Selected count
              if (selectedAttendanceUser.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                      "Selected: ${selectedAttendanceUser.length}"),
                ),

              /// 🔹 Bulk action buttons
              bulkActionsButtons(),

              /// 🔹 Users list
              Expanded(
                child: ListView.builder(
                  itemCount: usersList.length,
                  itemBuilder: (context, index) {
                    final member = usersList[index];
                    return userAttendanceCard(member, index);
                  },
                ),
              ),
            ],
          );
        }

        return const Center(child: Text('Attendance List Page'));
      },
    );
  }

  /// 🔹 Bulk action buttons
  Widget bulkActionsButtons() {
    final isEnabled = selectedAttendanceUser.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
            onPressed: isEnabled ? () => bulkAction("2549bf8f-8bfb-48ba-9fc0-ec606472c6a2",false) : null,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text("Present"),
          ),
          ElevatedButton(
            onPressed: isEnabled ? () => bulkAction("02a27517-b5ab-4e9d-a6cb-89de56a6c03a",false) : null,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Absent"),
          ),
          ElevatedButton(
            onPressed: isEnabled ? () => bulkAction("40d11aab-f71a-470a-abfd-4c620b895f0e",true) : null,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: const Text("Permission"),
          ),
        ],
      ),
    );
  }

  /// 🔹 Check if user is selected
  bool checkIfUserIsSelected(String memberId) { return selectedAttendanceUser.contains(memberId); }

  /// 🔹 Single user card
  Widget userAttendanceCard(UserModel member, int index) {

    if (completedAttendanceUsers.contains(member.id)) {
      return const SizedBox.shrink(); // hidden
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 3,
      color: checkIfUserIsSelected(member.id)
          ? Colors.blue.withOpacity(0.08)
          : Colors.white,
      child: ListTile(
        onLongPress: () => toggleSelection(member.id),
        onTap: () {
          if (selectedAttendanceUser.isNotEmpty) {
            toggleSelection(member.id);
          } else {
            showStatusOptions(index);
          }
        },
        leading: Checkbox(
          value: checkIfUserIsSelected(member.id),
          onChanged: (_) => toggleSelection(member.id),
        ),
        title: Text(member.name),
        subtitle: Text(member.email),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: getStatusColor("Present").withOpacity(0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            'status', // TODO: Replace with actual member status
            style: TextStyle(
              color: getStatusColor("Present"),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}