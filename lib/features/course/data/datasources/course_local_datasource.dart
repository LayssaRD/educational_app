import '../../../../core/database/app_database.dart';
import '../../domain/models/course.dart';

class CourseLocalDataSource {
  final AppDatabase _database;

  CourseLocalDataSource(this._database);

  Future<int> insert(Course course) async {
    final db = await _database.database;
    return db.insert('courses', course.toMap());
  }

  Future<List<Course>> findAll({int? limit, int? offset}) async {
    final db = await _database.database;

    final results = await db.query(
      'courses',
      orderBy: 'name ASC',
      limit: limit,
      offset: offset,
    );

    return results.map((e) => Course.fromMap(e)).toList();
  }

  Future<Course?> getById(String courseId) async {
    final db = await _database.database;

    final results = await db.query(
      'courses',
      where: 'courseId = ?',
      whereArgs: [courseId],
    );

    if (results.isEmpty) return null;

    return Course.fromMap(results.first);
  }

  Future<int> update(Course course) async {
    final db = await _database.database;

    return db.update(
      'courses',
      course.toMap(),
      where: 'courseId = ?',
      whereArgs: [course.courseId],
    );
  }

  Future<int> delete(String courseId) async {
    final db = await _database.database;

    return db.delete('courses', where: 'courseId = ?', whereArgs: [courseId]);
  }
}
