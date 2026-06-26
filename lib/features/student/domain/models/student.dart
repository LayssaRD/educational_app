class Student {
  final String studentId;
  final String name;
  final String email;
  final String phone;
  final DateTime updatedAt;
  final bool isSynced;

  Student({
    required this.studentId,
    required this.name,
    required this.email,
    required this.phone,
    required this.updatedAt,
    this.isSynced = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'studentId': studentId,
      'name': name,
      'email': email,
      'phone': phone,
      'updatedAt': updatedAt.toIso8601String(),
      'isSynced': isSynced ? 1 : 0,
    };
  }

  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      studentId: map['studentId'],
      name: map['name'],
      email: map['email'],
      phone: map['phone'],
      updatedAt: DateTime.parse(map['updatedAt']),
      isSynced: map['isSynced'] == 1,
    );
  }

  Student copyWith({
    String? name,
    String? email,
    String? phone,
    DateTime? updatedAt,
    bool? isSynced,
  }) {
    return Student(
      studentId: studentId,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      updatedAt: updatedAt ?? this.updatedAt,
      isSynced: isSynced ?? this.isSynced,
    );
  }
}
