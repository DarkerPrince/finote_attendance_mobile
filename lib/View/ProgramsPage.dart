import 'package:finote_program/View/Program/ProgramCard.dart';
import 'package:finote_program/features/programs/program_bloc.dart';
import 'package:finote_program/features/programs/program_event.dart';
import 'package:finote_program/features/programs/program_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProgramsPage extends StatefulWidget {
  String userId;
  ProgramsPage({super.key, required this.userId });

  @override
  State<ProgramsPage> createState() => _ProgramsPageState();
}

class _ProgramsPageState extends State<ProgramsPage> {
  @override
  void initState() {
    super.initState();
    
    // ✅ Trigger the load programs event when page opens
    context.read<ProgramsBloc>().add(LoadPrograms(userId: widget.userId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Programs Page",style: TextStyle(color: Colors.blue)) ,elevation: 2,shadowColor: Colors.blueAccent.withOpacity(0.2), backgroundColor: Colors.white,),
      backgroundColor: Colors.white,
      body: BlocBuilder<ProgramsBloc, ProgramsState>(
        builder: (context, state) {
          if (state is ProgramsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProgramsLoaded) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: state.programs
                    .map((program) => Programcard(
                  program: program,
                ))
                    .toList(),
              ),
            );
          } else if (state is ProgramsError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox();
        },
      ),
    );
  }
}