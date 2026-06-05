import '../models/enrollment.dart';
import '../repositories/enrollment_repository.dart';

class EnrollmentController {
  final EnrollmentRepository _repository = EnrollmentRepository();

  List<Enrollment> enrollments = [];

  Future<void> loadEnrollments() async {
    enrollments = await _repository.findAll();
  }

  Future<void> addEnrollment(Enrollment enrollment) async {
    await _repository.insert(enrollment);
    await loadEnrollments();
  }

  Future<void> updateEnrollment(Enrollment enrollment) async {
    await _repository.update(enrollment);
    await loadEnrollments();
  }

  Future<void> deleteEnrollment(int enrollmentId) async {
    await _repository.delete(enrollmentId);
    await loadEnrollments();
  }
}
