import '../models/course.dart';

abstract class CourseRepository {
  Future<void> insert(Course course);

  Future<List<Course>> findAllCourse({int? limit, int? offset});

  Future<Course?> getCourseById(String courseId);

  Future<int> updateCourse(Course course);

  Future<int> deleteCourse(String courseId);
}
