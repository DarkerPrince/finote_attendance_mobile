import 'package:equatable/equatable.dart';
import 'package:finote_program/Models/ProgramModel.dart';

abstract class ProgramsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ProgramsInitial extends ProgramsState {}
class ProgramsLoading extends ProgramsState {}
class ProgramsLoaded extends ProgramsState {
  final List<ProgramModel> programs;
  ProgramsLoaded(this.programs);

  @override
  List<Object?> get props => [programs];
}
class ProgramsError extends ProgramsState {
  final String message;
  ProgramsError(this.message);

  @override
  List<Object?> get props => [message];
}