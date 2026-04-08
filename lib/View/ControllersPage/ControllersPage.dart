import 'package:finote_program/Models/ProgramModel.dart';
import 'package:finote_program/View/ControllersPage/ControllerAttendancePage.dart';
import 'package:finote_program/View/ControllersPage/ControllerProgramCard.dart';
import 'package:finote_program/features/programs/program_bloc.dart';
import 'package:finote_program/features/programs/program_event.dart';
import 'package:finote_program/features/programs/program_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ControllersPage extends StatefulWidget {
  String userId;
  ControllersPage({super.key,required this.userId});

  @override
  State<ControllersPage> createState() => _ControllersPageState();
}

class _ControllersPageState extends State<ControllersPage> {


  void initState() {
    super.initState();
    context.read<ProgramsBloc>().add(LoadControllerPrograms(controllerId: widget.userId));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Program Lists"),elevation: 2,),
      backgroundColor: Color(0xFFF9F9F9),
      body: BlocBuilder<ProgramsBloc, ProgramsState>(
        builder: (context , state){
          if(state is ProgramsLoading){
            return Center(child: CircularProgressIndicator(),);
          }
          else if (state is ProgramsLoaded){
            return state.programs.isEmpty? Center(child: Text("No Programs Found"),): ListView.builder(
              itemCount: state.programs.length,
              itemBuilder: (context, index)  {
                ProgramModel program = state.programs[index];
                return ControllerProgramCard(program: program,);
            },);
          }else if (state is ProgramsError){
            return Center(child: Text("Error: ${state.message}"),);
          }
          
          return Center(child: Text("Error Page"),);
        },

      ),
    );
  }
}
