import 'package:finote_program/View/Program/ProgramDetailPage.dart';
import 'package:finote_program/utils/dateUtils.dart';
import 'package:flutter/material.dart';

class Programcard extends StatelessWidget {
  String title;
  String description;
  String startDate;
  Programcard({super.key , required this.title , required this.description, required this.startDate});

  @override
  Widget build(BuildContext context) {
    Map<String, String> programDetailInfo = {
      "title": title,
      "description":
          "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
      "image":
          "https://images.squarespace-cdn.com/content/v1/5759a0b362cd94a47d9c6242/1465498218086-IO3IIO7FP8QBHL6N585H/slide3.jpg?format=1500w",
      "date": "June 12, 2024",
      "author": "M/r Alebachew Demisse"
    };
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (builder) => ProgramDetailPage(
                title: programDetailInfo['title'] ?? "",
                description: programDetailInfo['description'] ?? "description",
                imageUrl: programDetailInfo['image'] ?? "imageUrl",
                date: programDetailInfo['date'] ?? "date",
                author: programDetailInfo['author'] ?? "author")));
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
                          title,
                          maxLines: 2, // how many lines you want
                          overflow: TextOverflow.ellipsis, // adds ...
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    Wrap(
                      children: [
                        Text(
                          description,
                          maxLines: 2, // how many lines you want
                          overflow: TextOverflow.ellipsis, // adds ...
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    Text(
                      formatDate(startDate),
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
