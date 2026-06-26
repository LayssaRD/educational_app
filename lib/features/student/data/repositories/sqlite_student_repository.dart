import '../../domain/models/student.dart';
import '../../domain/repositories/student_repository.dart';
import '../datasources/student_local_datasource.dart';
import '../datasources/student_remote_datasource.dart';

class SqliteStudentRepository implements StudentRepository {
  final StudentLocalDataSource _local;
  final StudentRemoteDataSource _remote;

  SqliteStudentRepository(this._local, this._remote);

  @override
  Future<void> insertStudent(Student student) async {
    await _local.insert(student);
    try {
      await _remote.insert(student);
      await _local.update(student.copyWith(isSynced: true));
    } catch (_) {}
  }

  @override
  Future<List<Student>> findAllStudent({int? limit, int? offset}) async {
    try {
      final remoteList = await _remote.findAll();
      for (final student in remoteList) {
        final local = await _local.getById(student.studentId);
        if (local == null) {
          await _local.insert(student);
        } else {
          await _local.update(student);
        }
      }
    } catch (_) {}
    return _local.findAll(limit: limit, offset: offset);
  }

  @override
  Future<Student?> getStudentById(String studentId) async {
    try {
      final remote = await _remote.getById(studentId);
      if (remote != null) {
        await _local.update(remote);
        return remote;
      }
    } catch (_) {}
    return _local.getById(studentId);
  }

  @override
  Future<int> updateStudent(Student student) async {
    final result = await _local.update(student.copyWith(isSynced: false));
    try {
      await _remote.update(student);
      await _local.update(student.copyWith(isSynced: true));
    } catch (_) {}
    return result;
  }

  @override
  Future<int> deleteStudent(String studentId) async {
    final result = await _local.delete(studentId);
    try {
      await _remote.delete(studentId);
    } catch (_) {}
    return result;
  }
}
