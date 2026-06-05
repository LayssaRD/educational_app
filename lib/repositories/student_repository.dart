import '../database/app_database.dart';
import '../models/student.dart';

class StudentRepository {
  final AppDatabase _database = AppDatabase();

  Future<int> insert(Student student) async {
    final db = await _database.database;
    return await db.insert('students', student.toMap());
  }

  Future<List<Student>> findAll() async {
    final db = await _database.database;
    final results = await db.query('students', orderBy: 'studentId DESC');
    return results.map((item) => Student.fromMap(item)).toList();
  }

  Future<int> update(Student student) async {
    final db = await _database.database;
    return await db.update(
      'students',
      student.toMap(),
      where: 'studentId = ?',
      whereArgs: [student.studentId],
    );
  }

  Future<int> delete(int studentId) async {
    final db = await _database.database;
    return await db.delete(
      'students',
      where: 'studentId = ?',
      whereArgs: [studentId],
    );
  }
}
