import '../models/enrollment.dart';

abstract class EnrollmentRepository {
  Future<void> insertEnrollment(Enrollment enrollment);

  Future<List<Enrollment>> findAllEnrollment({int? limit, int? offset});

  Future<Enrollment?> getEnrollmentById(String enrollmentId);

  Future<int> updateEnrollment(Enrollment enrollment);

  Future<int> deleteEnrollment(String enrollmentId);
}
