import 'package:finote_program/Models/ProgramModel.dart';
import 'package:finote_program/Repository/programsRepository.dart';
import 'package:finote_program/features/programs/program_event.dart';
import 'package:finote_program/features/programs/program_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProgramsBloc extends Bloc<ProgramsEvent, ProgramsState> {

   // ✅ cache per userId
  final Map<String, List<ProgramModel>> _cachedPrograms = {};

  ProgramsBloc() : super(ProgramsInitial()) {
    on<LoadPrograms>(_onLoadPrograms);
    on<LoadControllerPrograms>(_onLoadControllersPrograms);
  }


 Future<void> _onLoadPrograms(
      LoadPrograms event, Emitter<ProgramsState> emit) async {

    final userId = event.userId;

    // ✅ Return cached data for this specific user
    if (_cachedPrograms.containsKey(userId) && !event.forceRefresh) {
      emit(ProgramsLoaded(_cachedPrograms[userId]!));
      return;
    }

    emit(ProgramsLoading());

    try {
      final programs =
          await ProgramsRepository().fetchPrograms(userId);

      // ✅ store per user
      _cachedPrograms[userId] = programs;

      emit(ProgramsLoaded(programs));
    } catch (e) {
      print("Error fetching programs: $e");
      emit(ProgramsError("Failed to fetch programs ${e.toString()}"));
    }
  }


  Future<void> _onLoadControllersPrograms(
      LoadControllerPrograms event, Emitter<ProgramsState> emit) async {
     emit(ProgramsLoading());
    try {
      final programs = await ProgramsRepository().fetchControllerProgramsRepository(event.controllerId);
      emit(ProgramsLoaded(programs));
    } catch (e) {
      print("Error fetching programs: $e");
      emit(ProgramsError("Failed to fetch programs ${e.toString()}"));
    }
  }
}