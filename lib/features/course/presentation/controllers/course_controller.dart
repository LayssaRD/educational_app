import 'package:flutter/foundation.dart';

import '../../domain/models/course.dart';
import '../../domain/repositories/course_repository.dart';
import '../../../../core/mixin/paginated_controller_mixin.dart';

class CourseController extends ChangeNotifier
    with PaginatedControllerMixin<Course> {
  final CourseRepository _repository;

  CourseController(this._repository);

  List<Course> get courses => items;

  @override
  Future<List<Course>> fetchItems(int limit, int offset) async {
    return await _repository.findAllCourse(limit: limit, offset: offset);
  }

  Future<void> loadCourses() async {
    await initLoad();
  }

  Future<void> addCourse(Course course) async {
    try {
      setError(null);
      await _repository.insert(course);
      await initLoad();
    } catch (e) {
      setError('Não foi possível cadastrar o curso.');
    }
  }

  Future<void> updateCourse(Course course) async {
    try {
      setError(null);
      await _repository.updateCourse(course);
      await initLoad();
    } catch (e) {
      setError('Não foi possível atualizar o curso.');
    }
  }

  Future<void> deleteCourse(String courseId) async {
    try {
      setError(null);
      await _repository.deleteCourse(courseId);
      await initLoad();
    } catch (e) {
      setError('Não foi possível remover o curso.');
    }
  }
}
