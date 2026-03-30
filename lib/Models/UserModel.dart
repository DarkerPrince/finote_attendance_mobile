class UserModel {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final List<dynamic>? role;
  final Map<String,dynamic>? department;
  final Map<String,dynamic>? className;
  final String? chr_name;
  // final String? image;
  final String? lastAttendance;


  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.role,
    this.department,
    this.className,
    this.chr_name,
    // this.image,
    this.lastAttendance
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'].toString(),
      name: json['name']??'',
      email: json['email']??'',
      phone: json['phone']??'',
      role: json['roles']??[],
      department: json['department']??{},
      className: json['class']??{},
      chr_name: json['chr_name']??"",
      // image: json['image']??'',
      lastAttendance: json['lastAttendance']??'',

    );
  }

  // toJson method
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'roles': role,
      'department': department,
      'class': className,
      'chr_name': chr_name,
      // 'image': image,
      'lastAttendance': lastAttendance,
    };
  }
}