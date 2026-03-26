import 'package:finote_program/Models/ProgramModel.dart';
import 'package:finote_program/Models/UserModel.dart';
import 'package:finote_program/View/ControllersPage/ControllerAttendanceTabs/ActionTakenUsersListPage.dart';
import 'package:finote_program/View/ControllersPage/ControllerAttendanceTabs/RawAttendanceListPage.dart';
import 'package:finote_program/View/Program/ProgramDetailPage.dart';
import 'package:finote_program/features/attendance/attendance_bloc.dart';
import 'package:finote_program/features/attendance/attendance_event.dart';
import 'package:finote_program/features/attendance/attendance_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// 🔹 Attendance Page
class ControllerAttendancePage extends StatefulWidget {
  ProgramModel program;
  ControllerAttendancePage({super.key , required this.program});

  @override
  State<ControllerAttendancePage> createState() =>
      _ControllerAttendancePageState();
}

class _ControllerAttendancePageState extends State<ControllerAttendancePage> with SingleTickerProviderStateMixin {

  late TabController _tabController;
  int currentTabIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _tabController = TabController(length: 2, vsync: this);

    _tabController.addListener(() {
      setState(() {
        currentTabIndex = _tabController.index;
      });
    });

    context.read<AttendanceBloc>().add(LoadProgramAttendanceListUsers(programId: widget.program.id));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }


  /// 🔹 Bulk update selected members
  // void updateSelected(String status) {
  //   setState(() {
  //     for (var member in members) {
  //       if (member.selected) {
  //         member.status = status;
  //         member.selected = false;
  //       }
  //     }
  //   });
  // }

  /// 🔹 Single update
  // void updateSingle(int index, String status) {
  //   setState(() {
  //     members[index].status = status;
  //   });
  // }

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
                // updateSingle(index, "Present");
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text("Absent"),
              onTap: () {
                // updateSingle(index, "Absent");
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text("By Permission"),
              onTap: () {
                // updateSingle(index, "By Permission");
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  int selectedCount=0;

  @override
  Widget build(BuildContext context) {
    // Count selected members for bulk actions
    // int selectedCount = members.where((m) => m.selected).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Attendance"),
        bottom: TabBar(
            controller: _tabController,
            tabs: [
              Tab(text: "All"),
              Tab(text: "Present")
             ]),
        actions: [
          IconButton(onPressed: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (builder)=>ProgramDetailPage(program: widget.program)));
          }, icon: Icon(Icons.info))
        ],
      ),
      body: TabBarView(
          controller: _tabController,
          children: [
        RawAttendanceListPage(program: widget.program),
        ActionTakenUsersListPage(program: widget.program,)
      ]),
    );
  }
}