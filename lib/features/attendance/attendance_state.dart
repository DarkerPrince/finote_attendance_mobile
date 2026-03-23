import 'package:equatable/equatable.dart';
import 'package:finote_program/Models/AttendanceModel.dart';

abstract class AttendanceState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AttendanceInitial extends AttendanceState {}
class AttendanceLoading extends AttendanceState {}
class AttendanceLoaded extends AttendanceState {
  final List<AttendanceModel> attendance;
  AttendanceLoaded(this.attendance);

  @override
  List<Object?> get props => [attendance];
}
class AttendanceError extends AttendanceState {
  final String message;
  AttendanceError(this.message);

  @override
  List<Object?> get props => [message];
}