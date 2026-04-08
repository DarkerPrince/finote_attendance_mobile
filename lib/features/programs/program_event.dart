import 'package:equatable/equatable.dart';

abstract class ProgramsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}


class LoadPrograms extends ProgramsEvent {
  final String userId;
  final bool forceRefresh;

  LoadPrograms({required this.userId, this.forceRefresh = false});

  @override
  List<Object?> get props => [userId, forceRefresh];
}

class LoadControllerPrograms extends ProgramsEvent {
  String controllerId;
  LoadControllerPrograms({required this.controllerId});

  @override
  List<Object?> get props => [controllerId];
}