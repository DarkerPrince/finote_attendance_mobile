import 'package:equatable/equatable.dart';

abstract class ProgramsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadPrograms extends ProgramsEvent {
  String userId;
  LoadPrograms({required this.userId});
}

class LoadControllerPrograms extends ProgramsEvent {
  String controllerId;
  LoadControllerPrograms({required this.controllerId});

  @override
  List<Object?> get props => [controllerId];
}