import 'package:finote_program/utils/dateUtils.dart';
import 'package:intl/intl.dart';

class ProgramModel {
  final String id;
  final String title;
  final String description;
  final String startDate;
  final String? startTime;
  final String? image_url;
  final String? facebook_link;
  final String? instagram_link;
  final String? telegram_link;
  final String? tiktok_link;
  final String? youtube_link;
  final String? programtype;
  final String? location;


  ProgramModel({
    required this.id,
    required this.title,
    required this.description,
    required this.startDate,
    required this.startTime,
    required this.image_url,
    required this.facebook_link,
    required this.instagram_link,
    required this.youtube_link,
    required this.tiktok_link,
    required this.telegram_link,
    required this.programtype,
    required this.location

  });

  factory ProgramModel.fromJson(Map<String, dynamic> json) {

    final startDateData = json['startdate'] != null
        ? DateTime.parse(json['startdate'])
        : DateTime.now();

    final parsedTime  = DateFormat('h:mm a').format(startDateData);
    final parsedDate = formatDate(startDateData.toString());// fallback (optional)

    return ProgramModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      startDate: parsedDate,
      startTime: parsedTime,
      image_url: json['image_url'],
      facebook_link: json['facebook_link'],
      youtube_link: json['youtube_link'],
      tiktok_link: json['tiktok_link'],
      telegram_link: json['telegram_link'],
      instagram_link: json['instagram_link'],
      location: json['location']['title']??"",
      programtype: json['programtype']['title']??"",
    );
  }


}

