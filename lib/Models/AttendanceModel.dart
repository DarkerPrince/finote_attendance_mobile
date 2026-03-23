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