import '../models/student.dart';

abstract class StudentRepository {
  Future<void> insertStudent(Student student);

  Future<List<Student>> findAllStudent({int? limit, int? offset});

  Future<Student?> getStudentById(String studentId);

  Future<int> updateStudent(Student student);

  Future<int> deleteStudent(String studentId);
}
