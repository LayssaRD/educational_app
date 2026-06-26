import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/models/enrollment.dart';

class EnrollmentRemoteDataSource {
  final SupabaseClient _client;

  EnrollmentRemoteDataSource(this._client);

  Future<void> insert(Enrollment enrollment) async {
    await _client.from('enrollments').insert(_toRemoteMap(enrollment));
  }

  Future<List<Enrollment>> findAll() async {
    final results = await _client.from('enrollments').select();
    return results.map((e) => Enrollment.fromMap(_toLocalMap(e))).toList();
  }

  Future<Enrollment?> getById(String enrollmentId) async {
    final result = await _client
        .from('enrollments')
        .select()
        .eq('enrollment_id', enrollmentId)
        .maybeSingle();
    if (result == null) return null;
    return Enrollment.fromMap(_toLocalMap(result));
  }

  Future<void> update(Enrollment enrollment) async {
    await _client
        .from('enrollments')
        .update(_toRemoteMap(enrollment))
        .eq('enrollment_id', enrollment.enrollmentId);
  }

  Future<void> delete(String enrollmentId) async {
    await _client
        .from('enrollments')
        .delete()
        .eq('enrollment_id', enrollmentId);
  }

  Map<String, dynamic> _toLocalMap(Map<String, dynamic> r) => {
    'enrollmentId': r['enrollment_id'],
    'studentId': r['student_id'],
    'courseId': r['course_id'],
    'productId': r['product_id'],
    'enrollmentDate': r['enrollment_date'],
    'updatedAt': r['updated_at'],
    'isSynced': 1,
  };

  Map<String, dynamic> _toRemoteMap(Enrollment e) => {
    'enrollment_id': e.enrollmentId,
    'student_id': e.studentId,
    'course_id': e.courseId,
    'product_id': e.productId,
    'enrollment_date': e.enrollmentDate,
    'updated_at': e.updatedAt.toIso8601String(),
  };
}
