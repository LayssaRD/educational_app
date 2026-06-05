import '../models/student.dart';
import '../repositories/student_repository.dart';

class StudentController {
  final StudentRepository _repository = StudentRepository();

  List<Student> students = [];

  Future<void> loadStudents() async {
    students = await _repository.findAll();
  }

  Future<void> addStudent(Student student) async {
    await _repository.insert(student);
    await loadStudents();
  }

  Future<void> updateStudent(Student student) async {
    await _repository.update(student);
    await loadStudents();
  }

  Future<void> deleteStudent(int studentId) async {
    await _repository.delete(studentId);
    await loadStudents();
  }
}
