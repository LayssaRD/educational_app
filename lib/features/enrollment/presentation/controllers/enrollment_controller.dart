import 'package:flutter/foundation.dart';

import '../../domain/models/enrollment.dart';
import '../../domain/repositories/enrollment_repository.dart';
import '../../../../core/mixin/paginated_controller_mixin.dart';

class EnrollmentController extends ChangeNotifier
    with PaginatedControllerMixin<Enrollment> {
  final EnrollmentRepository _repository;

  EnrollmentController(this._repository);

  List<Enrollment> get enrollments => items;

  @override
  Future<List<Enrollment>> fetchItems(int limit, int offset) async {
    return await _repository.findAllEnrollment(limit: limit, offset: offset);
  }

  Future<void> loadEnrollments() async {
    await initLoad();
  }

  Future<void> addEnrollment(Enrollment enrollment) async {
    try {
      setError(null);
      await _repository.insertEnrollment(enrollment);
      await initLoad();
    } catch (e) {
      setError('Não foi possível cadastrar a matrícula.');
    }
  }

  Future<void> updateEnrollment(Enrollment enrollment) async {
    try {
      setError(null);
      await _repository.updateEnrollment(enrollment);
      await initLoad();
    } catch (e) {
      setError('Não foi possível atualizar a matrícula.');
    }
  }

  Future<void> deleteEnrollment(String enrollmentId) async {
    try {
      setError(null);
      await _repository.deleteEnrollment(enrollmentId);
      await initLoad();
    } catch (e) {
      setError('Não foi possível remover a matrícula.');
    }
  }
}
