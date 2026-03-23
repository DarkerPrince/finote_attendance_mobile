import 'package:equatable/equatable.dart';

abstract class ProgramsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadPrograms extends ProgramsEvent {}