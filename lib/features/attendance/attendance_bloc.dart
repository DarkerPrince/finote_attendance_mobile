import 'package:finote_program/Models/UserModel.dart';
import 'package:finote_program/Repository/attendanceRepository.dart';
import 'package:finote_program/Repository/programsRepository.dart';
import 'package:finote_program/features/attendance/attendance_event.dart';
import 'package:finote_program/features/attendance/attendance_state.dart';
import 'package:finote_program/features/programs/program_event.dart';
import 'package:finote_program/features/programs/program_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AttendanceBloc extends Bloc<AttendanceEvent, AttendanceState> {
  String baseUrl;

  AttendanceBloc({required this.baseUrl}) : super(AttendanceInitial()) {
    on<LoadAttendance>(_onLoadAttendance);
    on<setAttendanceProgram>(_setAttendanceForProgram);
    on<LoadProgramAttendanceListUsers>(_onLoadProgramUsersAttendance);
    on<LoadProgramAttendanceActionTakenListUsers>(_onLoadProgramUsersActionTakenAttendance);

  }

  Future<void> _onLoadAttendance(
      LoadAttendance event, Emitter<AttendanceState> emit) async {
    emit(AttendanceLoading());
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('userId') ?? '';
      final attendance = await AttendanceRepository(baseUrl: baseUrl).fetchAttendance(userId);
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
      final attendance = await AttendanceRepository(baseUrl: baseUrl).fetchProgramAttendanceUsersList(event.programId);

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
      final attendance = await AttendanceRepository(baseUrl: baseUrl).fetchProgramActionTakenAttendanceUsersList(event.programId);

      emit(AttendanceLoaded_ProgramUsersList(attendance));
    } catch (e) {
      print("error on attendance fetch $e");
      emit(AttendanceError("Failed to fetch programs"));
    }
  }



  Future<void> _setAttendanceForProgram(
      setAttendanceProgram event, Emitter<AttendanceState> emit) async {

    print("Set Attendance Methid is not event Outputting $state");
    // final oreviousState = state;
    // emit(AttendanceLoading());

    try {
      // Call API
      await AttendanceRepository(baseUrl: baseUrl).addAttendanceSystem(
        event.programId,
        event.controllerId,
        event.statusId,
        event.users,
        event.permissionReason,
      );

      // Get current users from state
      List<UserModel> currentUsers = [];
      if (state is AttendanceLoaded_ProgramUsersList) {
        print("Output Model is now $state");
        currentUsers = List.from((state as AttendanceLoaded_ProgramUsersList).usersList);
      }

      // Mark updated users as hidden/completed
      currentUsers.removeWhere((user) => event.users.contains(user.id));



      // Emit the updated list without fetching again
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
