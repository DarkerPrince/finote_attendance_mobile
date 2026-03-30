import 'package:finote_program/Models/ProgramModel.dart';
import 'package:finote_program/View/ControllersPage/ControllerAttendancePage.dart';
import 'package:finote_program/utils/dateUtils.dart';
import 'package:flutter/material.dart';

class ControllerProgramCard extends StatelessWidget {
  ProgramModel program;

  ControllerProgramCard({
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
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        padding: const EdgeInsets.all(20),
        height: 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: const Color(0xFFF7F9FD),
          border: Border.all(color: Colors.grey.shade300),
            boxShadow: [
              BoxShadow(color: Colors.grey.withOpacity(0.2),spreadRadius: 1,blurRadius: 8,blurStyle: BlurStyle.outer)
            ]
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// 🔹 TOP ROW
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.backup_table_sharp, size: 28),
                Text(
                  formatDate(program.startDate),
                ),
              ],
            ),

            const Spacer(),

            /// 🔹 TITLE
            Text(
              program.title,
              maxLines: 1, // how many lines you want
              overflow: TextOverflow.ellipsis, // adds ...
              style: const TextStyle(
                fontSize: 20,
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 4),

            /// 🔹 SUBTITLE
            Text(
              program.description,
              maxLines: 1, // how many lines you want
              overflow: TextOverflow.ellipsis, // adds ...
              style: const TextStyle(
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 12),

            /// 🔹 BOTTOM ROW
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.list_alt, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      "View Details",
                    ),
                  ],
                ),

                Icon(Icons.arrow_forward_ios, size: 16),
              ],
            ),
          ],
        ),
      ),
    );
  }
}