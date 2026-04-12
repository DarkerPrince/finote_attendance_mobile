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

  String PRESENT_ID = "2549bf8f-8bfb-48ba-9fc0-ec606472c6a2";
  String ABSENT_ID = "02a27517-b5ab-4e9d-a6cb-89de56a6c03a";
  String BYPERMISSION_ID = "40d11aab-f71a-470a-abfd-4c620b895f0e";


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
    context.read<AttendanceBloc>().add(SetAttendanceProgram(
      users: selectedAttendanceUser.toList(),
      statusId: status,
      permissionReason: "Nothing",
      programId: widget.program.id,
      controllerId: userMap!.id,
      programDate: widget.program.fullProgramDate??DateTime.now().toIso8601String() ));

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
                    return userAttendanceCard(member.user, index);
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

    return isEnabled?Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
            onPressed: isEnabled ? () => bulkAction("2549bf8f-8bfb-48ba-9fc0-ec606472c6a2",false) : null,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green ,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8), // smaller = less rounded
              ),
            ),
            child: const Text("Present" ,style: TextStyle(color: Colors.white),),
          ),
          ElevatedButton(
            onPressed: isEnabled ? () => bulkAction("02a27517-b5ab-4e9d-a6cb-89de56a6c03a",false) : null,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8), // smaller = less rounded
              ),
            ),
            child: const Text("Absent",style: TextStyle(color: Colors.white),),
          ),
          ElevatedButton(
            onPressed: isEnabled ? () => bulkAction("40d11aab-f71a-470a-abfd-4c620b895f0e",true) : null,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8), // smaller = less rounded
              ),
            ),
            child: Text("Permission",style: TextStyle(color: isEnabled ? Colors.black:Colors.white),),
          ),
        ],
      ),
    ):Container();
  }

  /// 🔹 Check if user is selected
  bool checkIfUserIsSelected(String memberId) { return selectedAttendanceUser.contains(memberId); }

  /// 🔹 Single user card
  Widget userAttendanceCard(UserModel member, int index) {

    if (completedAttendanceUsers.contains(member.id)) {
      return const SizedBox.shrink(); // hidden
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: checkIfUserIsSelected(member.id)
            ? Colors.blueAccent.withOpacity(0.2)
            : Colors.white,
        border: Border.all(color: Colors.grey.shade400)
      ),
      child: ListTile(
        dense: true,
        onLongPress: () => toggleSelection(member.id),
        onTap: () => toggleSelection(member.id),
        leading: Checkbox(
          value: checkIfUserIsSelected(member.id),
          onChanged: (_) => toggleSelection(member.id),
        ),
        title: Text(member.name ,style: TextStyle(fontSize: 16 , fontWeight: FontWeight.w500),),
        subtitle: Text(member.email==''?"email@finote1619.com":member.email),
        // trailing: Container(
        //   padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        //   decoration: BoxDecoration(
        //     color: getStatusColor("Present").withOpacity(0.2),
        //     borderRadius: BorderRadius.circular(10),
        //   ),
        //   child: Text(
        //     'status', // TODO: Replace with actual member status
        //     style: TextStyle(
        //       color: getStatusColor("Present"),
        //       fontWeight: FontWeight.bold,
        //     ),
        //   ),
        // ),
      ),
    );
  }
}