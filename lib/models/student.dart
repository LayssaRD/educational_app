class Student {
  final int? studentId;
  final String name;
  final String email;
  final String phone;

  Student({
    this.studentId,
    required this.name,
    required this.email,
    required this.phone,
  });

  Map<String, dynamic> toMap() {
    return {
      'studentId': studentId,
      'name': name,
      'email': email,
      'phone': phone,
    };
  }

  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      studentId: map['studentId'],
      name: map['name'],
      email: map['email'],
      phone: map['phone'],
    );
  }
}
