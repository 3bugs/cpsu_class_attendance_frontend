class Student {
  final String studentId;
  final String title;
  final String firstName;
  final String lastName;
  final String major;

  Student({
    required this.studentId,
    required this.title,
    required this.firstName,
    required this.lastName,
    required this.major,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      studentId: json['studentId'],
      title: json['title'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      major: json['major'],
    );
  }
}
