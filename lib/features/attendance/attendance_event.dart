import 'package:equatable/equatable.dart';

abstract class AttendanceEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadAttendance extends AttendanceEvent {
  String? userID;

  LoadAttendance({required this.userID});
  @override
  List<Object?> get props => [userID];
}

class LoadProgramAttendanceListUsers extends AttendanceEvent {
  String? programId;

  LoadProgramAttendanceListUsers({required this.programId});
  @override
  List<Object?> get props => [programId];
}

class LoadProgramAttendanceActionTakenListUsers extends AttendanceEvent {
  String? programId;

  LoadProgramAttendanceActionTakenListUsers({required this.programId});
  @override
  List<Object?> get props => [programId];
}

class setAttendanceProgram extends AttendanceEvent {
  List<String> users;
  String programId;
  String statusId;
  String permissionReason;
  String controllerId;

  setAttendanceProgram({required this.users,required this.programId,required this.statusId,required this.permissionReason, required this.controllerId});
  @override
  List<Object?> get props => [users,programId,statusId,permissionReason,controllerId];
}