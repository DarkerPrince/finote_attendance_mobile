import 'package:finote_program/Models/ProgramModel.dart';
import 'package:finote_program/View/Program/InfoItem.dart';
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
          child: Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(color: Colors.blueAccent.withOpacity(0.2),borderRadius: BorderRadius.circular(12)),
                          padding: EdgeInsets.symmetric(vertical: 2,horizontal: 6),
                          child: Text(
                            program.programtype??"Other",
                            style: TextStyle(fontSize: 12 ,color: Colors.blueAccent ),
                          ),
                        ),
                      const SizedBox(height: 4,),
                        Wrap(
                          children: [
                            Text(
                              program.title,
                              maxLines: 1, // how many lines you want
                              overflow: TextOverflow.ellipsis, // adds ...
                              style: TextStyle(fontWeight: FontWeight.w600 ,fontSize: 16),
                            ),
                          ],
                        ),
                        SizedBox(height: 4,),
                        Wrap(
                          children: [
                            Text(
                              program.description,
                              maxLines: 2, // how many lines you want
                              overflow: TextOverflow.ellipsis, // adds ...
                              style: TextStyle(fontWeight: FontWeight.w400,fontSize: 14),
                            ),
                          ],
                        ),
                        SizedBox(height: 8,),
                        Text(
                          '@finote1619',
                          style: TextStyle(color: Colors.blueGrey),
                        ),
                        // IconButton(onPressed: () {}, icon: Icon(Icons.bookmark_add))
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Hero(
                    tag: program.id,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.3,
                      height: MediaQuery.of(context).size.width * 0.3,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blueAccent.withOpacity(0.5),
                            blurRadius: 12,
                          )
                        ],
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.blueAccent.withOpacity(0.5),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: (program.image_url == null || program.image_url!.isEmpty)
                            ? Center(
                          child: Icon(Icons.church, color: Colors.white, size: 32),
                        )
                            : Image.network(
                          program.image_url!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 12,),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white, // cleaner background
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.blueGrey),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    /// DATE
                    InfoItem(
                      icon: Icons.calendar_month_rounded,
                      label: program.startDate??"", // using your ProgramModel helper
                    ),

                    /// TIME
                    InfoItem(
                      icon: Icons.access_time,
                      label: program.startTime??"",
                    ),

                    /// LOCATION
                    InfoItem(
                      icon: Icons.location_on_outlined,
                      label: program.location ?? "No location",
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
