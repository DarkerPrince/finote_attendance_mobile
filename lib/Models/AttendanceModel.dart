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
    final program = json['program'];
    final status = json['status'];
    return AttendanceModel(
      title: program is Map ? program['title'] ?? "" : "",
      description: program is Map ? program['description'] ?? "" : "",
      startDate: program is Map ? program['startdate'] ?? "" : "",
      status: status is Map ? status['name'] ?? "" : ""
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
    final attendances = json['attendances'];

    final List<AttendanceModel> programs = attendances is List
        ? attendances.map((e) => AttendanceModel.fromJson(e as Map<String, dynamic>)).toList()
        : [];

    return GroupAttendanceModel(
      attendanceDate: json['day'] ?? "",
      attendancePrograms: programs,
    );
  }
}