import '../../domain/models/enrollment.dart';
import '../../domain/repositories/enrollment_repository.dart';
import '../datasources/enrollment_local_datasource.dart';
import '../datasources/enrollment_remote_datasource.dart';

class SqliteEnrollmentRepository implements EnrollmentRepository {
  final EnrollmentLocalDataSource _local;
  final EnrollmentRemoteDataSource _remote;

  SqliteEnrollmentRepository(this._local, this._remote);

  @override
  Future<void> insertEnrollment(Enrollment enrollment) async {
    await _local.insert(enrollment);
    try {
      await _remote.insert(enrollment);
      await _local.update(enrollment.copyWith(isSynced: true));
    } catch (_) {}
  }

  @override
  Future<List<Enrollment>> findAllEnrollment({int? limit, int? offset}) async {
    try {
      final remoteList = await _remote.findAll();
      for (final enrollment in remoteList) {
        final local = await _local.getById(enrollment.enrollmentId);
        if (local == null) {
          await _local.insert(enrollment);
        } else {
          await _local.update(enrollment);
        }
      }
    } catch (_) {}
    return _local.findAll(limit: limit, offset: offset);
  }

  @override
  Future<Enrollment?> getEnrollmentById(String enrollmentId) async {
    try {
      final remote = await _remote.getById(enrollmentId);
      if (remote != null) {
        await _local.update(remote);
        return remote;
      }
    } catch (_) {}
    return _local.getById(enrollmentId);
  }

  @override
  Future<int> updateEnrollment(Enrollment enrollment) async {
    final result = await _local.update(enrollment.copyWith(isSynced: false));
    try {
      await _remote.update(enrollment);
      await _local.update(enrollment.copyWith(isSynced: true));
    } catch (_) {}
    return result;
  }

  @override
  Future<int> deleteEnrollment(String enrollmentId) async {
    final result = await _local.delete(enrollmentId);
    try {
      await _remote.delete(enrollmentId);
    } catch (_) {}
    return result;
  }
}
