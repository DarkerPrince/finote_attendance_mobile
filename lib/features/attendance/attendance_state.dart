import 'package:equatable/equatable.dart';
import 'package:finote_program/Models/AttendanceModel.dart';
import 'package:finote_program/Models/UserModel.dart';

abstract class AttendanceState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AttendanceInitial extends AttendanceState {}
class AttendanceLoading extends AttendanceState {}

class AttendanceLoaded extends AttendanceState {
  final List<GroupAttendanceModel> attendance;
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


class AttendanceLoaded_ProgramUsersList extends AttendanceState {
  final List<UserModel> usersList;
  AttendanceLoaded_ProgramUsersList(this.usersList);

  @override
  List<Object?> get props => [usersList];
}