import 'package:finote_program/View/Attendance/AttendanceCard.dart';
import 'package:finote_program/features/attendance/attendance_bloc.dart';
import 'package:finote_program/features/attendance/attendance_event.dart';
import 'package:finote_program/features/attendance/attendance_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeline_tile/timeline_tile.dart';

class Attendancepage extends StatefulWidget {
  String userId;
  Attendancepage({super.key,required this.userId});

  @override
  State<Attendancepage> createState() => _AttendancepageState();
}

class _AttendancepageState extends State<Attendancepage> {

  @override
  void initState() {
    super.initState();
    context.read<AttendanceBloc>().add(LoadAttendance(userID: widget.userId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("My Attendance",style: TextStyle(color: Colors.blueAccent),),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: BlocBuilder<AttendanceBloc, AttendanceState>(// number of date groups
          builder: (context, state) {

            if(state is AttendanceLoading){
              return const Center(child: CircularProgressIndicator());
            }else if(state is AttendanceLoaded){
              return ListView.builder(
                  itemCount: state.attendance.length,
                  itemBuilder: (context, index){
                    print("Attendance For this user amount ${state.attendance.length}");
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: TimelineTile(
                        alignment: TimelineAlign.start,
                        isFirst: index == 0,
                        isLast: index == (state.attendance.length-1),

                        indicatorStyle: IndicatorStyle(
                          width: 50,
                          height: 50,
                          indicatorXY: 0.0,
                          indicator: Icon(Icons.calendar_month, size: 14),
                        ),


                        beforeLineStyle: LineStyle(
                          color: Colors.grey.shade300,
                          thickness: 2,
                        ),

                        endChild: Align(
                          alignment: Alignment.topLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min, // prevents overflow
                            children: state.attendance[index].attendancePrograms.map((attendance)=>Attendancecard(attendance: attendance,)).toList(),
                          ),
                        ),
                      ),
                    );
                  });
            }else if (state is AttendanceError) {
              return Center(child: Text(state.message));
            }
            return const SizedBox();

        },
      ),
    );
  }
}