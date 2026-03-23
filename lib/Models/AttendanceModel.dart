class AttendanceModel {
  final String title;
  final String description;
  final String startDate;

  AttendanceModel({
    required this.title,
    required this.description,
    required this.startDate,
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      title: json['program']['title'],
      description: json['program']['description'],
      startDate: json['program']['startdate'],
    );
  }
}


class GroupAttendanceModel {
  final String attendanceDate;
  final List<AttendanceModel> attendancePrograms;

  GroupAttendanceModel({
    required this.attendanceDate,
    required this.attendancePrograms,
  });

  factory GroupAttendanceModel.fromJson(Map<String, dynamic> json) {
    final List attendances = json['attendances'];

    return GroupAttendanceModel(
      attendanceDate: json['day'],
      attendancePrograms: attendances
          .map((e) => AttendanceModel.fromJson(e))
          .toList(),
    );
  }
}