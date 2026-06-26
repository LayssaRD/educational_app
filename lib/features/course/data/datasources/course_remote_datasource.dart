import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/models/course.dart';

class CourseRemoteDataSource {
  final SupabaseClient _client;

  CourseRemoteDataSource(this._client);

  Future<void> insert(Course course) async {
    await _client.from('courses').insert(_toRemoteMap(course));
  }

  Future<List<Course>> findAll() async {
    final results = await _client.from('courses').select();
    return results.map((e) => Course.fromMap(_toLocalMap(e))).toList();
  }

  Future<Course?> getById(String courseId) async {
    final result = await _client
        .from('courses')
        .select()
        .eq('course_id', courseId)
        .maybeSingle();
    if (result == null) return null;
    return Course.fromMap(_toLocalMap(result));
  }

  Future<void> update(Course course) async {
    await _client
        .from('courses')
        .update(_toRemoteMap(course))
        .eq('course_id', course.courseId);
  }

  Future<void> delete(String courseId) async {
    await _client.from('courses').delete().eq('course_id', courseId);
  }

  Map<String, dynamic> _toLocalMap(Map<String, dynamic> r) => {
    'courseId': r['course_id'],
    'name': r['name'],
    'description': r['description'],
    'duration': r['duration'],
    'updatedAt': r['updated_at'],
    'isSynced': 1,
  };

  Map<String, dynamic> _toRemoteMap(Course c) => {
    'course_id': c.courseId,
    'name': c.name,
    'description': c.description,
    'duration': c.duration,
    'updated_at': c.updatedAt.toIso8601String(),
  };
}
