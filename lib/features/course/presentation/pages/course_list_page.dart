import 'package:flutter/material.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/supabase/supabase_config.dart';
import '../../data/datasources/course_local_datasource.dart';
import '../../data/repositories/sqlite_course_repository.dart';
import '../controllers/course_controller.dart';
import '../../domain/models/course.dart';
import 'course_form_page.dart';
import '../../data/datasources/course_remote_datasource.dart';

class CourseListPage extends StatefulWidget {
  const CourseListPage({super.key});

  @override
  State<CourseListPage> createState() => _CourseListPageState();
}

class _CourseListPageState extends State<CourseListPage> {
  late final CourseController controller;

  static const _purple = Color(0xFF534AB7);
  static const _purpleLight = Color(0xFFEEEDFE);
  static const _purpleDark = Color(0xFF3C3489);
  static const _purpleMid = Color(0xFF7F77DD);

  @override
  void initState() {
    super.initState();

    final database = AppDatabase();
    final dataSource = CourseLocalDataSource(database);
    final remoteDataSource = CourseRemoteDataSource(SupabaseConfig.client);
    final repository = SqliteCourseRepository(dataSource, remoteDataSource);

    controller = CourseController(repository);
    loadCourses();
  }

  Future<void> loadCourses() async {
    await controller.loadCourses();
    if (mounted && controller.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(controller.errorMessage!),
          backgroundColor: Colors.red,
        ),
      );
      controller.clearError();
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> _openForm({Course? course}) async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (context) => CourseFormPage(course: course)),
    );
    if (result == true) {
      loadCourses();
    }
  }

  Future<void> deleteCourse(Course course) async {
    final messenger = ScaffoldMessenger.of(context);
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Confirmar exclusão',
          style: TextStyle(color: _purpleDark, fontWeight: FontWeight.w600),
        ),
        content: Text('Deseja remover "${course.name}"?'),
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
      await controller.deleteCourse(course.courseId);
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
              content: Text('Curso removido'),
              backgroundColor: _purpleDark,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F4FF),
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Cursos',
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
        listenable: controller,
        builder: (context, child) {
          if (controller.isLoading && controller.courses.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(_purple),
              ),
            );
          }

          if (controller.courses.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.school_outlined, size: 64, color: _purpleMid),
                  SizedBox(height: 16),
                  Text(
                    'Nenhum curso cadastrado',
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
                controller.courses.length +
                (controller.courses.isNotEmpty ? 1 : 0),
            itemBuilder: (context, index) {
              if (index < controller.courses.length) {
                final course = controller.courses[index];
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
                      child: const Icon(Icons.school_outlined, color: _purple),
                    ),
                    title: Text(
                      course.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: _purpleDark,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            course.description,
                            style: const TextStyle(color: Colors.black54),
                          ),
                          const SizedBox(height: 4),
                          _chip('${course.duration}h', Icons.timer_outlined),
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
                          onPressed: () => _openForm(course: course),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete_outline,
                            color: _purple,
                          ),
                          onPressed: () => deleteCourse(course),
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
                        'Todos os cursos foram carregados.',
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
          'Novo Curso',
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
