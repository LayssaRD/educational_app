import '../database/app_database.dart';
import '../models/course.dart';

class CourseRepository {
  final AppDatabase _database = AppDatabase();

  Future<int> insert(Course course) async {
    final db = await _database.database;
    return await db.insert('courses', course.toMap());
  }

  Future<List<Course>> findAll() async {
    final db = await _database.database;
    final results = await db.query('courses', orderBy: 'courseId DESC');
    return results.map((item) => Course.fromMap(item)).toList();
  }

  Future<int> update(Course course) async {
    final db = await _database.database;
    return await db.update(
      'courses',
      course.toMap(),
      where: 'courseId = ?',
      whereArgs: [course.courseId],
    );
  }

  Future<int> delete(int courseId) async {
    final db = await _database.database;
    return await db.delete(
      'courses',
      where: 'courseId = ?',
      whereArgs: [courseId],
    );
  }
}
