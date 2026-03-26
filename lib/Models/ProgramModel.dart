class ProgramModel {
  final String id;
  final String title;
  final String description;
  final String startDate;

  ProgramModel({
    required this.id,
    required this.title,
    required this.description,
    required this.startDate,
  });

  factory ProgramModel.fromJson(Map<String, dynamic> json) {
    return ProgramModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      startDate: json['startdate'],
    );
  }
}