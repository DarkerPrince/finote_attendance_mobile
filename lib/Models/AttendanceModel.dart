class AttendanceModel {
  final String title;
  final String description;
  final String startDate;
  final String status;

  AttendanceModel({
    required this.title,
    required this.description,
    required this.startDate,
    required this.status
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      title: json['program']['title'],
      description: json['program']['description'],
      startDate: json['program']['startdate'],
      status: json['status']['name']
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