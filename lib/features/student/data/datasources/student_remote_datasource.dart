import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/models/student.dart';

class StudentRemoteDataSource {
  final SupabaseClient _client;

  StudentRemoteDataSource(this._client);

  Future<void> insert(Student student) async {
    await _client.from('students').insert(_toRemoteMap(student));
  }

  Future<List<Student>> findAll() async {
    final results = await _client.from('students').select();
    return results.map((e) => Student.fromMap(_toLocalMap(e))).toList();
  }

  Future<Student?> getById(String studentId) async {
    final result = await _client
        .from('students')
        .select()
        .eq('student_id', studentId)
        .maybeSingle();
    if (result == null) return null;
    return Student.fromMap(_toLocalMap(result));
  }

  Future<void> update(Student student) async {
    await _client
        .from('students')
        .update(_toRemoteMap(student))
        .eq('student_id', student.studentId);
  }

  Future<void> delete(String studentId) async {
    await _client.from('students').delete().eq('student_id', studentId);
  }

  Map<String, dynamic> _toLocalMap(Map<String, dynamic> r) => {
    'studentId': r['student_id'],
    'name': r['name'],
    'email': r['email'],
    'phone': r['phone'],
    'updatedAt': r['updated_at'],
    'isSynced': 1,
  };

  Map<String, dynamic> _toRemoteMap(Student s) => {
    'student_id': s.studentId,
    'name': s.name,
    'email': s.email,
    'phone': s.phone,
    'updated_at': s.updatedAt.toIso8601String(),
  };
}
