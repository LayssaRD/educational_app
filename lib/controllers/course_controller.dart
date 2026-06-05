import '../models/course.dart';
import '../repositories/course_repository.dart';

class CourseController {
  final CourseRepository _repository = CourseRepository();

  List<Course> courses = [];

  Future<void> loadCourses() async {
    courses = await _repository.findAll();
  }

  Future<void> addCourse(Course course) async {
    await _repository.insert(course);
    await loadCourses();
  }

  Future<void> updateCourse(Course course) async {
    await _repository.update(course);
    await loadCourses();
  }

  Future<void> deleteCourse(int courseId) async {
    await _repository.delete(courseId);
    await loadCourses();
  }
}
