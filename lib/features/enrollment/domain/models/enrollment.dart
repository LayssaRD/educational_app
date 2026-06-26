class Enrollment {
  final String enrollmentId;
  final String studentId;
  final String courseId;
  final String productId;
  final String enrollmentDate;
  final DateTime updatedAt;
  final bool isSynced;

  Enrollment({
    required this.enrollmentId,
    required this.studentId,
    required this.courseId,
    required this.productId,
    required this.enrollmentDate,
    required this.updatedAt,
    this.isSynced = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'enrollmentId': enrollmentId,
      'studentId': studentId,
      'courseId': courseId,
      'productId': productId,
      'enrollmentDate': enrollmentDate,
      'updatedAt': updatedAt.toIso8601String(),
      'isSynced': isSynced ? 1 : 0,
    };
  }

  factory Enrollment.fromMap(Map<String, dynamic> map) {
    return Enrollment(
      enrollmentId: map['enrollmentId'],
      studentId: map['studentId'],
      courseId: map['courseId'],
      productId: map['productId'],
      enrollmentDate: map['enrollmentDate'],
      updatedAt: DateTime.parse(map['updatedAt']),
      isSynced: map['isSynced'] == 1,
    );
  }

  Enrollment copyWith({
    String? studentId,
    String? courseId,
    String? productId,
    String? enrollmentDate,
    DateTime? updatedAt,
    bool? isSynced,
  }) {
    return Enrollment(
      enrollmentId: enrollmentId,
      studentId: studentId ?? this.studentId,
      courseId: courseId ?? this.courseId,
      productId: productId ?? this.productId,
      enrollmentDate: enrollmentDate ?? this.enrollmentDate,
      updatedAt: updatedAt ?? this.updatedAt,
      isSynced: isSynced ?? this.isSynced,
    );
  }
}
