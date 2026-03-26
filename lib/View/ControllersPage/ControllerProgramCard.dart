import 'package:finote_program/Models/ProgramModel.dart';
import 'package:finote_program/View/ControllersPage/ControllerAttendancePage.dart';
import 'package:flutter/material.dart';

class ProgramCard extends StatelessWidget {
  ProgramModel program;

  ProgramCard({
    super.key,
    required this.program,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (builder)=>ControllerAttendancePage(program: program)));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        padding: const EdgeInsets.all(20),
        height: 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            colors: [
              Color(0xFF4A00E0),
              Color(0xFF8E2DE2),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: Offset(0, 6),
            ),
          ],
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// 🔹 TOP ROW
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.event, color: Colors.white, size: 28),
                Text(
                  program.startDate,
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),

            const Spacer(),

            /// 🔹 TITLE
            Text(
              program.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 4),

            /// 🔹 SUBTITLE
            Text(
              program.description,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 12),

            /// 🔹 BOTTOM ROW
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.location_on, color: Colors.white70, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      "location",
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),

                Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
              ],
            ),
          ],
        ),
      ),
    );
  }
}