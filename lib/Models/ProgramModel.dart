class ProgramModel {
  final String id;
  final String title;
  final String description;
  final String startDate;
  final String? image_url;

  ProgramModel({
    required this.id,
    required this.title,
    required this.description,
    required this.startDate,
    required this.image_url
  });

  factory ProgramModel.fromJson(Map<String, dynamic> json) {
    return ProgramModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      startDate: json['startdate'],
      image_url: json['image_url'],
    );
  }
}