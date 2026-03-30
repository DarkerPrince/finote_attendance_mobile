import 'package:finote_program/Models/AttendanceModel.dart';
import 'package:finote_program/utils/colorUtils.dart';
import 'package:flutter/material.dart';

class Attendancecard extends StatelessWidget {
  AttendanceModel attendance;
  Attendancecard({super.key,required this.attendance});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.only(top: 2,bottom: 2, right: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 50,
            width: 50,
            child: Icon(Icons.calendar_view_day),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6)
              ,
              color: Colors.blueAccent.withOpacity(0.3),
            ),
          ),
          const SizedBox(width: 12),
          // 📄 Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 📌 Title
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 200,
                      child: Text(
                        attendance.title,
                        maxLines: 1, // how many lines you want
                        overflow: TextOverflow.ellipsis, // adds ...
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),

                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: getStatusColor(attendance.status),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        attendance.status,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 4),

                Text(
                  attendance.description,
                  maxLines: 2, // how many lines you want
                  overflow: TextOverflow.ellipsis, // adds ...
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                // 🟢 Status

                SizedBox(height: 6),

                // 👤 Handled by
                Text(
                  "at ${attendance.startDate}",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
