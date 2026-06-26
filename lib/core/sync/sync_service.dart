import 'package:sqflite/sqflite.dart';
import '../database/app_database.dart';
import '../../features/course/data/datasources/course_remote_datasource.dart';
import '../../features/course/domain/models/course.dart';
import '../../features/educational_product/data/datasources/educational_product_remote_datasource.dart';
import '../../features/educational_product/domain/models/educational_product.dart';
import '../../features/enrollment/data/datasources/enrollment_remote_datasource.dart';
import '../../features/enrollment/domain/models/enrollment.dart';
import '../../features/student/data/datasources/student_remote_datasource.dart';
import '../../features/student/domain/models/student.dart';

class SyncService {
  final AppDatabase _database;
  final CourseRemoteDataSource _courseRemote;
  final EducationalProductRemoteDataSource _productRemote;
  final StudentRemoteDataSource _studentRemote;
  final EnrollmentRemoteDataSource _enrollmentRemote;

  SyncService({
    required AppDatabase database,
    required CourseRemoteDataSource courseRemote,
    required EducationalProductRemoteDataSource productRemote,
    required StudentRemoteDataSource studentRemote,
    required EnrollmentRemoteDataSource enrollmentRemote,
  }) : _database = database,
       _courseRemote = courseRemote,
       _productRemote = productRemote,
       _studentRemote = studentRemote,
       _enrollmentRemote = enrollmentRemote;

  Future<void> syncAll() async {
    await Future.wait([
      _syncCourses(),
      _syncProducts(),
      _syncStudents(),
      _syncEnrollments(),
    ]);
  }

  Future<void> _syncCourses() async {
    final db = await _database.database;
    final pending = await _getPending(db, 'courses');
    for (final map in pending) {
      try {
        final course = Course.fromMap(map);
        await _courseRemote.insert(course);
        await _markSynced(db, 'courses', 'courseId', course.courseId);
      } catch (_) {}
    }
  }

  Future<void> _syncProducts() async {
    final db = await _database.database;
    final pending = await _getPending(db, 'products');
    for (final map in pending) {
      try {
        final product = EducationalProduct.fromMap(map);
        await _productRemote.insert(product);
        await _markSynced(db, 'products', 'productId', product.productId);
      } catch (_) {}
    }
  }

  Future<void> _syncStudents() async {
    final db = await _database.database;
    final pending = await _getPending(db, 'students');
    for (final map in pending) {
      try {
        final student = Student.fromMap(map);
        await _studentRemote.insert(student);
        await _markSynced(db, 'students', 'studentId', student.studentId);
      } catch (_) {}
    }
  }

  Future<void> _syncEnrollments() async {
    final db = await _database.database;
    final pending = await _getPending(db, 'enrollments');
    for (final map in pending) {
      try {
        final enrollment = Enrollment.fromMap(map);
        await _enrollmentRemote.insert(enrollment);
        await _markSynced(
          db,
          'enrollments',
          'enrollmentId',
          enrollment.enrollmentId,
        );
      } catch (_) {}
    }
  }

  Future<List<Map<String, dynamic>>> _getPending(
    Database db,
    String table,
  ) async {
    return db.query(table, where: 'isSynced = ?', whereArgs: [0]);
  }

  Future<void> _markSynced(
    Database db,
    String table,
    String idColumn,
    String id,
  ) async {
    await db.update(
      table,
      {'isSynced': 1},
      where: '$idColumn = ?',
      whereArgs: [id],
    );
  }
}
