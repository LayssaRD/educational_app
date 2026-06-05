import '../database/app_database.dart';
import '../models/enrollment.dart';

class EnrollmentRepository {
  final AppDatabase _database = AppDatabase();

  Future<int> insert(Enrollment enrollment) async {
    final db = await _database.database;
    return await db.insert('enrollments', enrollment.toMap());
  }

  Future<List<Enrollment>> findAll() async {
    final db = await _database.database;
    final results = await db.query('enrollments', orderBy: 'enrollmentId DESC');
    return results.map((item) => Enrollment.fromMap(item)).toList();
  }

  Future<int> update(Enrollment enrollment) async {
    final db = await _database.database;
    return await db.update(
      'enrollments',
      enrollment.toMap(),
      where: 'enrollmentId = ?',
      whereArgs: [enrollment.enrollmentId],
    );
  }

  Future<int> delete(int enrollmentId) async {
    final db = await _database.database;
    return await db.delete(
      'enrollments',
      where: 'enrollmentId = ?',
      whereArgs: [enrollmentId],
    );
  }
}
