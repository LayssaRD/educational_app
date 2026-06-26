import 'package:flutter/material.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/supabase/supabase_config.dart';
import '../../data/datasources/student_local_datasource.dart';
import '../../data/datasources/student_remote_datasource.dart';
import '../../data/repositories/sqlite_student_repository.dart';
import '../controllers/student_controller.dart';
import '../../domain/models/student.dart';
import 'student_form_page.dart';

class StudentListPage extends StatefulWidget {
  const StudentListPage({super.key});

  @override
  State<StudentListPage> createState() => _StudentListPageState();
}

class _StudentListPageState extends State<StudentListPage> {
  late final StudentController controller;

  static const _purple = Color(0xFF534AB7);
  static const _purpleLight = Color(0xFFEEEDFE);
  static const _purpleDark = Color(0xFF3C3489);
  static const _purpleMid = Color(0xFF7F77DD);

  @override
  void initState() {
    super.initState();

    final database = AppDatabase();
    final dataSource = StudentLocalDataSource(database);
    final remoteDataSource = StudentRemoteDataSource(SupabaseConfig.client);
    final repository = SqliteStudentRepository(dataSource, remoteDataSource);

    controller = StudentController(repository);
    loadStudents();
  }

  Future<void> loadStudents() async {
    await controller.loadStudents();
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

  Future<void> _openForm({Student? student}) async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) => StudentFormPage(student: student),
      ),
    );
    if (result == true) {
      loadStudents();
    }
  }

  Future<void> deleteStudent(Student student) async {
    final messenger = ScaffoldMessenger.of(context);
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Confirmar exclusão',
          style: TextStyle(color: _purpleDark, fontWeight: FontWeight.w600),
        ),
        content: Text('Deseja remover "${student.name}"?'),
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
      await controller.deleteStudent(student.studentId);
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
              content: Text('Aluno removido'),
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
          'Alunos',
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
          if (controller.isLoading && controller.students.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(_purple),
              ),
            );
          }

          if (controller.students.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.person_outline, size: 64, color: _purpleMid),
                  SizedBox(height: 16),
                  Text(
                    'Nenhum aluno cadastrado',
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
                controller.students.length +
                (controller.students.isNotEmpty ? 1 : 0),
            itemBuilder: (context, index) {
              if (index < controller.students.length) {
                final student = controller.students[index];
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
                      child: const Icon(Icons.person_outline, color: _purple),
                    ),
                    title: Text(
                      student.name,
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
                          _chip(student.email, Icons.email_outlined),
                          _chip(student.phone, Icons.phone_outlined),
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
                          onPressed: () => _openForm(student: student),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete_outline,
                            color: _purple,
                          ),
                          onPressed: () => deleteStudent(student),
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
                        'Todos os alunos foram carregados.',
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
          'Novo Aluno',
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
