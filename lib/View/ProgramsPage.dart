import 'package:finote_program/View/Program/ProgramCard.dart';
import 'package:finote_program/View/Program/ProgramCardShimmer.dart';
import 'package:finote_program/features/programs/program_bloc.dart';
import 'package:finote_program/features/programs/program_event.dart';
import 'package:finote_program/features/programs/program_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProgramsPage extends StatefulWidget {
  String userId;
  ProgramsPage({super.key, required this.userId});

  @override
  State<ProgramsPage> createState() => _ProgramsPageState();
}

class _ProgramsPageState extends State<ProgramsPage> {
  @override
  void initState() {
    super.initState();

    print("ProgramsPage initialized with userId: ${widget.userId}");

    // ✅ Trigger the load programs event when page opens
    context
        .read<ProgramsBloc>()
        .add(LoadPrograms(userId: widget.userId, forceRefresh: false));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Programs Page", style: TextStyle(color: Colors.blue)),
        elevation: 2,
        shadowColor: Colors.blueAccent.withOpacity(0.2),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: BlocBuilder<ProgramsBloc, ProgramsState>(
        builder: (context, state) {
          if (state is ProgramsLoading) {
            return ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) => const ProgramCardShimmer(),
            );
          } else if (state is ProgramsLoaded) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<ProgramsBloc>().add(
                      LoadPrograms(
                        userId: widget.userId,
                        forceRefresh: true, // force API call
                      ),
                    );
              },
              child: state.programs.isEmpty
                  ? ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: const [
                        SizedBox(height: 300), // ensure scrollable
                        Center(child: Text("No Programs Found")),
                      ],
                    )
                  : ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(12),
                      itemCount: state.programs.length,
                      itemBuilder: (context, index) {
                        return Programcard(
                          program: state.programs[index],
                        );
                      },
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
