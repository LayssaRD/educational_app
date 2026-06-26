import '../../domain/models/course.dart';
import '../../domain/repositories/course_repository.dart';
import '../datasources/course_local_datasource.dart';
import '../datasources/course_remote_datasource.dart';

class SqliteCourseRepository implements CourseRepository {
  final CourseLocalDataSource _local;
  final CourseRemoteDataSource _remote;

  SqliteCourseRepository(this._local, this._remote);

  @override
  Future<void> insert(Course course) async {
    await _local.insert(course);
    try {
      await _remote.insert(course);
      await _local.update(course.copyWith(isSynced: true));
    } catch (_) {}
  }

  @override
  Future<List<Course>> findAllCourse({int? limit, int? offset}) async {
    try {
      final remoteList = await _remote.findAll();
      for (final course in remoteList) {
        final local = await _local.getById(course.courseId);
        if (local == null) {
          await _local.insert(course);
        } else {
          await _local.update(course);
        }
      }
    } catch (_) {}
    return _local.findAll(limit: limit, offset: offset);
  }

  @override
  Future<Course?> getCourseById(String courseId) async {
    try {
      final remote = await _remote.getById(courseId);
      if (remote != null) {
        await _local.update(remote);
        return remote;
      }
    } catch (_) {}
    return _local.getById(courseId);
  }

  @override
  Future<int> updateCourse(Course course) async {
    final result = await _local.update(course.copyWith(isSynced: false));
    try {
      await _remote.update(course);
      await _local.update(course.copyWith(isSynced: true));
    } catch (_) {}
    return result;
  }

  @override
  Future<int> deleteCourse(String courseId) async {
    final result = await _local.delete(courseId);
    try {
      await _remote.delete(courseId);
    } catch (_) {}
    return result;
  }
}
