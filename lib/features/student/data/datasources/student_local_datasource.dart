import '../../../../core/database/app_database.dart';
import '../../domain/models/student.dart';

class StudentLocalDataSource {
  final AppDatabase _database;

  StudentLocalDataSource(this._database);

  Future<void> insert(Student student) async {
    final db = await _database.database;
    await db.insert('students', student.toMap());
  }

  Future<List<Student>> findAll({int? limit, int? offset}) async {
    final db = await _database.database;

    final results = await db.query(
      'students',
      orderBy: 'name ASC',
      limit: limit,
      offset: offset,
    );

    return results.map((item) => Student.fromMap(item)).toList();
  }

  Future<Student?> getById(String studentId) async {
    final db = await _database.database;

    final results = await db.query(
      'students',
      where: 'studentId = ?',
      whereArgs: [studentId],
    );

    if (results.isEmpty) return null;

    return Student.fromMap(results.first);
  }

  Future<int> update(Student student) async {
    final db = await _database.database;

    return db.update(
      'students',
      student.toMap(),
      where: 'studentId = ?',
      whereArgs: [student.studentId],
    );
  }

  Future<int> delete(String studentId) async {
    final db = await _database.database;

    return db.delete(
      'students',
      where: 'studentId = ?',
      whereArgs: [studentId],
    );
  }
}
