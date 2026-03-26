import 'package:finote_program/Repository/programsRepository.dart';
import 'package:finote_program/features/programs/program_event.dart';
import 'package:finote_program/features/programs/program_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProgramsBloc extends Bloc<ProgramsEvent, ProgramsState> {
  String baseUrl;

  ProgramsBloc({required this.baseUrl}) : super(ProgramsInitial()) {
    on<LoadPrograms>(_onLoadPrograms);
    on<LoadControllerPrograms>(_onLoadControllersPrograms);
  }

  Future<void> _onLoadPrograms(
      LoadPrograms event, Emitter<ProgramsState> emit) async {
    emit(ProgramsLoading());
    try {
      final programs = await ProgramsRepository(baseUrl: baseUrl).fetchPrograms();
      emit(ProgramsLoaded(programs));
    } catch (e) {
      emit(ProgramsError("Failed to fetch programs"));
    }
  }

  Future<void> _onLoadControllersPrograms(
      LoadControllerPrograms event, Emitter<ProgramsState> emit) async {
    emit(ProgramsLoading());
    try {
      final programs = await ProgramsRepository(baseUrl: baseUrl).fetchControllerProgramsRepository(event.controllerId);
      emit(ProgramsLoaded(programs));
    } catch (e) {
      emit(ProgramsError("Failed to fetch programs"));
    }
  }
}