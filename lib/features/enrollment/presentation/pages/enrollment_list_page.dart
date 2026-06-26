import 'package:flutter/material.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/supabase/supabase_config.dart';
import '../../../course/data/datasources/course_remote_datasource.dart';
import '../../../educational_product/data/datasources/educational_product_remote_datasource.dart';
import '../../../student/data/datasources/student_local_datasource.dart';
import '../../../student/data/datasources/student_remote_datasource.dart';
import '../../../student/data/repositories/sqlite_student_repository.dart';
import '../../../student/presentation/controllers/student_controller.dart';
import '../../../course/data/datasources/course_local_datasource.dart';
import '../../../course/data/repositories/sqlite_course_repository.dart';
import '../../../course/presentation/controllers/course_controller.dart';
import '../../../educational_product/data/datasources/educational_product_datasource.dart';
import '../../../educational_product/data/repositories/sqlite_educational_product_repository.dart';
import '../../../educational_product/presentation/controllers/educational_product_controller.dart';
import '../../data/datasources/enrollment_local_datasource.dart';
import '../../data/datasources/enrollment_remote_datasource.dart';
import '../../data/repositories/sqlite_enrollment_repository.dart';
import '../controllers/enrollment_controller.dart';
import '../../domain/models/enrollment.dart';
import 'enrollment_form_page.dart';

class EnrollmentListPage extends StatefulWidget {
  const EnrollmentListPage({super.key});

  @override
  State<EnrollmentListPage> createState() => _EnrollmentListPageState();
}

class _EnrollmentListPageState extends State<EnrollmentListPage> {
  late final EnrollmentController controller;
  late final StudentController studentController;
  late final CourseController courseController;
  late final EducationalProductController productController;

  static const _purple = Color(0xFF534AB7);
  static const _purpleLight = Color(0xFFEEEDFE);
  static const _purpleDark = Color(0xFF3C3489);
  static const _purpleMid = Color(0xFF7F77DD);

  @override
  void initState() {
    super.initState();

    final database = AppDatabase();
    final client = SupabaseConfig.client;

    final enrollmentRepository = SqliteEnrollmentRepository(
      EnrollmentLocalDataSource(database),
      EnrollmentRemoteDataSource(client),
    );
    final studentRepository = SqliteStudentRepository(
      StudentLocalDataSource(database),
      StudentRemoteDataSource(client),
    );
    final courseRepository = SqliteCourseRepository(
      CourseLocalDataSource(database),
      CourseRemoteDataSource(client),
    );
    final productRepository = SqliteEducationalProductRepository(
      EducationalProductLocalDataSource(database),
      EducationalProductRemoteDataSource(client),
    );

    controller = EnrollmentController(enrollmentRepository);
    studentController = StudentController(studentRepository);
    courseController = CourseController(courseRepository);
    productController = EducationalProductController(productRepository);

    loadAll();
  }

  Future<void> loadAll() async {
    await controller.loadEnrollments();
    await studentController.loadStudents();
    await courseController.loadCourses();
    await productController.loadProducts();

    if (mounted) {
      final error =
          controller.errorMessage ??
          studentController.errorMessage ??
          courseController.errorMessage ??
          productController.errorMessage;

      if (error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error), backgroundColor: Colors.red),
        );
        controller.clearError();
        studentController.clearError();
        courseController.clearError();
        productController.clearError();
      }
    }
  }

  @override
  void dispose() {
    controller.dispose();
    studentController.dispose();
    courseController.dispose();
    productController.dispose();
    super.dispose();
  }

  Future<void> _openForm({Enrollment? enrollment}) async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) => EnrollmentFormPage(
          enrollment: enrollment,
          students: studentController.students,
          courses: courseController.courses,
          products: productController.products,
        ),
      ),
    );
    if (result == true) {
      loadAll();
    }
  }

  Future<void> deleteEnrollment(Enrollment enrollment) async {
    final messenger = ScaffoldMessenger.of(context);
    final studentName = _studentName(enrollment.studentId);

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Confirmar exclusão',
          style: TextStyle(color: _purpleDark, fontWeight: FontWeight.w600),
        ),
        content: Text('Deseja remover a matrícula de "$studentName"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            style: TextButton.styleFrom(foregroundColor: _purple),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: _purple,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await controller.deleteEnrollment(enrollment.enrollmentId);
      if (mounted) {
        if (controller.errorMessage != null) {
          messenger.showSnackBar(
            SnackBar(
              content: Text(controller.errorMessage!),
              backgroundColor: Colors.red,
            ),
          );
          controller.clearError();
        } else {
          messenger.showSnackBar(
            const SnackBar(
              content: Text('Matrícula removida'),
              backgroundColor: _purpleDark,
            ),
          );
        }
      }
    }
  }

  String _studentName(String id) {
    try {
      return studentController.students
          .firstWhere((s) => s.studentId == id)
          .name;
    } catch (_) {
      return 'Aluno não encontrado';
    }
  }

  String _courseName(String id) {
    try {
      return courseController.courses.firstWhere((c) => c.courseId == id).name;
    } catch (_) {
      return 'Curso não encontrado';
    }
  }

  String _productName(String id) {
    try {
      return productController.products
          .firstWhere((p) => p.productId == id)
          .name;
    } catch (_) {
      return 'Material não encontrado';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F4FF),
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Matrículas',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        backgroundColor: _purple,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: ListenableBuilder(
        listenable: Listenable.merge([
          controller,
          studentController,
          courseController,
          productController,
        ]),
        builder: (context, child) {
          final isInitialLoading =
              (controller.isLoading && controller.enrollments.isEmpty) ||
              (studentController.isLoading &&
                  studentController.students.isEmpty) ||
              (courseController.isLoading &&
                  courseController.courses.isEmpty) ||
              (productController.isLoading &&
                  productController.products.isEmpty);

          if (isInitialLoading) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(_purple),
              ),
            );
          }

          if (controller.enrollments.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.assignment_outlined, size: 64, color: _purpleMid),
                  SizedBox(height: 16),
                  Text(
                    'Nenhuma matrícula cadastrada',
                    style: TextStyle(color: _purple, fontSize: 16),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            controller: controller.scrollController,
            padding: const EdgeInsets.all(12),
            itemCount:
                controller.enrollments.length +
                (controller.enrollments.isNotEmpty ? 1 : 0),
            itemBuilder: (context, index) {
              if (index < controller.enrollments.length) {
                final enrollment = controller.enrollments[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: Color(0xFFAFA9EC)),
                  ),
                  color: Colors.white,
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    leading: CircleAvatar(
                      backgroundColor: _purpleLight,
                      child: const Icon(
                        Icons.assignment_outlined,
                        color: _purple,
                      ),
                    ),
                    title: Text(
                      _studentName(enrollment.studentId),
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: _purpleDark,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children: [
                          _chip(
                            _courseName(enrollment.courseId),
                            Icons.school_outlined,
                          ),
                          _chip(
                            _productName(enrollment.productId),
                            Icons.book_outlined,
                          ),
                          _chip(
                            enrollment.enrollmentDate.length >= 10
                                ? enrollment.enrollmentDate.substring(0, 10)
                                : enrollment.enrollmentDate,
                            Icons.calendar_today_outlined,
                          ),
                        ],
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.edit_outlined,
                            color: _purpleMid,
                          ),
                          onPressed: () => _openForm(enrollment: enrollment),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete_outline,
                            color: _purple,
                          ),
                          onPressed: () => deleteEnrollment(enrollment),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                if (controller.isLoadingMore) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(_purple),
                      ),
                    ),
                  );
                } else if (!controller.hasMore) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(
                      child: Text(
                        'Todas as matrículas foram carregadas.',
                        style: TextStyle(color: Colors.black38, fontSize: 13),
                      ),
                    ),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              }
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(),
        backgroundColor: _purple,
        foregroundColor: Colors.white,
        elevation: 4,
        icon: const Icon(Icons.add),
        label: const Text(
          'Nova Matrícula',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _chip(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: _purpleLight,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: _purple),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: _purpleDark,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
