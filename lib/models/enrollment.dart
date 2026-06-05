class Enrollment {
  final int? enrollmentId;
  final int studentId;
  final int courseId;
  final int productId;
  final String enrollmentDate;

  Enrollment({
    this.enrollmentId,
    required this.studentId,
    required this.courseId,
    required this.productId,
    required this.enrollmentDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'enrollmentId': enrollmentId,
      'studentId': studentId,
      'courseId': courseId,
      'productId': productId,
      'enrollmentDate': enrollmentDate,
    };
  }

  factory Enrollment.fromMap(Map<String, dynamic> map) {
    return Enrollment(
      enrollmentId: map['enrollmentId'],
      studentId: map['studentId'],
      courseId: map['courseId'],
      productId: map['productId'],
      enrollmentDate: map['enrollmentDate'],
    );
  }
}
