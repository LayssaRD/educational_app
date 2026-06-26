import 'package:flutter/foundation.dart';

import '../../../../core/mixin/paginated_controller_mixin.dart';
import '../../domain/models/student.dart';
import '../../domain/repositories/student_repository.dart';

class StudentController extends ChangeNotifier
    with PaginatedControllerMixin<Student> {
  final StudentRepository _repository;

  StudentController(this._repository);

  List<Student> get students => items;

  @override
  Future<List<Student>> fetchItems(int limit, int offset) {
    return _repository.findAllStudent(limit: limit, offset: offset);
  }

  Future<void> loadStudents() async {
    await initLoad();
  }

  Future<void> addStudent(Student student) async {
    try {
      setError(null);
      await _repository.insertStudent(student);
      await initLoad();
    } catch (e) {
      setError('Não foi possível cadastrar o aluno.');
    }
  }

  Future<void> updateStudent(Student student) async {
    try {
      setError(null);
      await _repository.updateStudent(student);
      await initLoad();
    } catch (e) {
      setError('Não foi possível atualizar o aluno.');
    }
  }

  Future<void> deleteStudent(String studentId) async {
    try {
      setError(null);
      await _repository.deleteStudent(studentId);
      await initLoad();
    } catch (e) {
      setError('Não foi possível remover o aluno.');
    }
  }
}
