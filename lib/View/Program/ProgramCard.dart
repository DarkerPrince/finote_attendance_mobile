import 'package:finote_program/Models/ProgramModel.dart';
import 'package:finote_program/View/Program/ProgramDetailPage.dart';
import 'package:finote_program/utils/dateUtils.dart';
import 'package:flutter/material.dart';

class Programcard extends StatelessWidget {
  ProgramModel program;
  Programcard({super.key , required this.program});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (builder) => ProgramDetailPage(
                program: program,)));
      },
      child: Container(
        width: MediaQuery.of(context).size.width,

        decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.grey.shade300, // line color
                width: 1, // thickness
              ),
            ),),
        padding: EdgeInsets.symmetric(vertical: 12),
        // margin: EdgeInsets.all(4),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "PostedBy - temertKefel - 1hr",
                      style: TextStyle(fontSize: 12),
                    ),
                    Wrap(
                      children: [
                        Text(
                          program.title,
                          maxLines: 2, // how many lines you want
                          overflow: TextOverflow.ellipsis, // adds ...
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    Wrap(
                      children: [
                        Text(
                          program.description,
                          maxLines: 2, // how many lines you want
                          overflow: TextOverflow.ellipsis, // adds ...
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    Text(
                      formatDate(program.startDate),
                      style: TextStyle(color: Colors.blueAccent),
                    ),
                    // IconButton(onPressed: () {}, icon: Icon(Icons.bookmark_add))
                  ],
                ),
              ),
              SizedBox(
                width: 12,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.3,
                height: MediaQuery.of(context).size.width * 0.3,
                decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.all(Radius.circular(12))),
              )
            ],
          ),
        ),
      ),
    );
  }
}
