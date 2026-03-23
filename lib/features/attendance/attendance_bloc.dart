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
  }

  Future<void> _onLoadAttendance(
      LoadAttendance event, Emitter<AttendanceState> emit) async {
    emit(AttendanceLoading());
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('userId') ?? '';
      final attendance =
          await AttendanceRepository(baseUrl: baseUrl).fetchAttendance(userId);
      emit(AttendanceLoaded(attendance));
    } catch (e) {
      emit(AttendanceError("Failed to fetch programs"));
    }
  }
}
