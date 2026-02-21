class UserModel {
  String? userId,name,email,role;
  int? yearOfJoining;
  String? departmentName;

  UserModel({this.userId,this.name, this.email, this.role, this.yearOfJoining, this.departmentName});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json["user_id"],
      name: json['name'],
      email: json['email'],
      role: json['role'],
      yearOfJoining: json['year_of_joining'],
      departmentName: json['department_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'role': role,
      'year_of_joining': yearOfJoining,
      'department_name': departmentName,
    };
  }

}