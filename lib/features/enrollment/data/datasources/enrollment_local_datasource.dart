import '../../../../core/database/app_database.dart';
import '../../domain/models/enrollment.dart';

class EnrollmentLocalDataSource {
  final AppDatabase _database;

  EnrollmentLocalDataSource(this._database);

  Future<void> insert(Enrollment enrollment) async {
    final db = await _database.database;
    await db.insert('enrollments', enrollment.toMap());
  }

  Future<List<Enrollment>> findAll({int? limit, int? offset}) async {
    final db = await _database.database;

    final results = await db.query(
      'enrollments',
      orderBy: 'enrollmentId DESC',
      limit: limit,
      offset: offset,
    );

    return results.map((e) => Enrollment.fromMap(e)).toList();
  }

  Future<Enrollment?> getById(String enrollmentId) async {
    final db = await _database.database;

    final results = await db.query(
      'enrollments',
      where: 'enrollmentId = ?',
      whereArgs: [enrollmentId],
    );

    if (results.isEmpty) return null;

    return Enrollment.fromMap(results.first);
  }

  Future<int> update(Enrollment enrollment) async {
    final db = await _database.database;

    return db.update(
      'enrollments',
      enrollment.toMap(),
      where: 'enrollmentId = ?',
      whereArgs: [enrollment.enrollmentId],
    );
  }

  Future<int> delete(String enrollmentId) async {
    final db = await _database.database;

    return db.delete(
      'enrollments',
      where: 'enrollmentId = ?',
      whereArgs: [enrollmentId],
    );
  }
}
