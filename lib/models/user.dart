class User {
  final int id;
  final String name;
  final String email;
  final String studentNumber;
  final String major;
  final int classYear;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.studentNumber,
    required this.major,
    required this.classYear,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      studentNumber: json['student_number'],
      major: json['major'],
      classYear: json['class_year'],
    );
  }
}