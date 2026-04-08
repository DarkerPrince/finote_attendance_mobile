import 'package:finote_program/Models/AttendanceUserModel.dart';
import 'package:finote_program/Models/UserModel.dart';
import 'package:finote_program/Repository/attendanceRepository.dart';
import 'package:finote_program/features/attendance/attendance_event.dart';
import 'package:finote_program/features/attendance/attendance_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AttendanceBloc extends Bloc<AttendanceEvent, AttendanceState> {


  AttendanceBloc() : super(AttendanceInitial()) {
    on<LoadAttendance>(_onLoadAttendance);
    on<SetAttendanceProgram>(_setAttendanceForProgram);
    on<LoadProgramAttendanceListUsers>(_onLoadProgramUsersAttendance);
    on<LoadProgramAttendanceActionTakenListUsers>(_onLoadProgramUsersActionTakenAttendance);
    // on<UpdateProgramAttendance>(_onupdateAttendance);
  }

  Future<void> _onLoadAttendance(
      LoadAttendance event, Emitter<AttendanceState> emit) async {
    emit(AttendanceLoading());
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('userId') ?? '';
      final attendance = await AttendanceRepository().fetchAttendance(userId);
      emit(AttendanceLoaded(attendance));
    } catch (e) {
      emit(AttendanceError("Failed to fetch programs"));
    }
  }

  Future<void> _onLoadProgramUsersAttendance(
      LoadProgramAttendanceListUsers event, Emitter<AttendanceState> emit) async {
    emit(AttendanceLoading());
    try {
      print(event.programId);

      final attendance = await AttendanceRepository().fetchProgramAttendanceUsersList(event.programId);

      emit(AttendanceLoaded_ProgramUsersList(attendance));
    } catch (e) {
      print("error on attendance fetch $e");
      emit(AttendanceError("Failed to fetch programs"));
    }
  }

  Future<void> _onLoadProgramUsersActionTakenAttendance(
      LoadProgramAttendanceActionTakenListUsers event, Emitter<AttendanceState> emit) async {
    emit(AttendanceLoading());
    try {
      print(event.programId);
      final attendance = await AttendanceRepository().fetchProgramActionTakenAttendanceUsersList(event.programId);

      emit(AttendanceLoaded_ProgramUsersList(attendance));
    } catch (e) {
      print("error on attendance fetch $e");
      emit(AttendanceError("Failed to fetch programs"));
    }
  }



  Future<void> _setAttendanceForProgram(
      SetAttendanceProgram event, Emitter<AttendanceState> emit) async {

    try {
      await AttendanceRepository().addAttendanceSystem(
        event.programId,
        event.controllerId,
        event.statusId,
        event.users,
        event.permissionReason,
        event.programDate
      );

      List<AttendanceUserModel> currentUsers = [];

      if (state is AttendanceLoaded_ProgramUsersList) {
        currentUsers = List.from(
          (state as AttendanceLoaded_ProgramUsersList).usersList,
        );
      }

      /// ✅ OPTION 1: REMOVE updated users (your current behavior)
      currentUsers.removeWhere(
            (item) => event.users.contains(item.user.id),
      );

      emit(AttendanceLoaded_ProgramUsersList(currentUsers));

    } catch (e) {
      emit(AttendanceError("Failed to update attendance: $e"));
    }
  }
}

//   Future<void> _setAttendanceForProgram(
//       setAttendanceProgram event, Emitter<AttendanceState> emit) async {
//     emit(AttendanceLoading());
//
//     print("Attendance is Updaing with the details");
//     try {
//       await AttendanceRepository(baseUrl: baseUrl).addAttendanceSystem(event.programId,event.controllerId,event.statusId,event.users,event.permissionReason);
//       emit(AttendanceUpdated('Updated Attendance'));
//     } catch (e) {
//       print("The error is $e");
//       emit(AttendanceError("Failed to fetch programs"));
//     }
//   }
// }
