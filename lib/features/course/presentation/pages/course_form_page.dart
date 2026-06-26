import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/presentation/widgets/form/custom_text_form_field.dart';
import '../../../../core/presentation/widgets/form/form_card_section.dart';
import '../../../../core/presentation/widgets/form/form_header_icon.dart';
import '../../../../core/presentation/widgets/form/form_section_label.dart';
import '../../../../core/presentation/widgets/form/form_submit_button.dart';
import '../../../../core/supabase/supabase_config.dart';
import '../../data/datasources/course_local_datasource.dart';
import '../../data/repositories/sqlite_course_repository.dart';
import '../../domain/models/course.dart';
import '../controllers/course_controller.dart';
import '../../data/datasources/course_remote_datasource.dart';

class CourseFormPage extends StatefulWidget {
  final Course? course;

  const CourseFormPage({super.key, this.course});

  @override
  State<CourseFormPage> createState() => _CourseFormPageState();
}

class _CourseFormPageState extends State<CourseFormPage> {
  late final CourseController controller;

  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _durationController;

  bool _isEditing = false;

  static const _purple = Color(0xFF534AB7);
  static const _purpleDark = Color(0xFF3C3489);

  @override
  void initState() {
    super.initState();

    final database = AppDatabase();
    final dataSource = CourseLocalDataSource(database);
    final remoteDataSource = CourseRemoteDataSource(SupabaseConfig.client);
    final repository = SqliteCourseRepository(dataSource, remoteDataSource);
    controller = CourseController(repository);

    _isEditing = widget.course != null;
    _nameController = TextEditingController(text: widget.course?.name ?? '');
    _descriptionController = TextEditingController(text: widget.course?.description ?? '');
    _durationController = TextEditingController(text: widget.course?.duration.toString() ?? '');
  }

  @override
  void dispose() {
    controller.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: isError ? Colors.redAccent : _purpleDark,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<void> _saveForm() async {
    if (!_formKey.currentState!.validate()) return;

    final name = _nameController.text.trim();
    final description = _descriptionController.text.trim();
    final duration = int.tryParse(_durationController.text.trim()) ?? 0;

    try {
      if (_isEditing) {
        final updatedCourse = widget.course!.copyWith(
          name: name,
          description: description,
          duration: duration,
          updatedAt: DateTime.now(),
          isSynced: false,
        );
        await controller.updateCourse(updatedCourse);

        if (controller.errorMessage == null) {
          _showSnackBar('$name atualizado com sucesso!');
          if (mounted) Navigator.of(context).pop(true);
        } else {
          _showSnackBar(
            'Erro ao atualizar: ${controller.errorMessage}',
            isError: true,
          );
        }
      } else {
        final newCourse = Course(
          courseId: const Uuid().v4(),
          name: name,
          description: description,
          duration: duration,
          updatedAt: DateTime.now(),
          isSynced: false,
        );
        await controller.addCourse(newCourse);

        if (controller.errorMessage == null) {
          _showSnackBar('$name cadastrado com sucesso!');
          if (mounted) Navigator.of(context).pop(true);
        } else {
          _showSnackBar(
            'Erro ao cadastrar: ${controller.errorMessage}',
            isError: true,
          );
        }
      }
    } catch (e) {
      _showSnackBar('Erro ao salvar informações: $e', isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F4FF),
      appBar: AppBar(
        title: Text(
          _isEditing ? 'Detalhes do Curso' : 'Novo Curso',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: _purpleDark,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(false),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: _purple),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: const Color(0xFFE2E8F0), height: 1),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const FormHeaderIcon(icon: Icons.school_outlined),
                const SizedBox(height: 32),
                FormCardSection(
                  title: 'Informações do Curso',
                  children: [
                    const FormSectionLabel(text: 'Nome do Curso'),
                    const SizedBox(height: 8),
                    CustomTextFormField(
                      controller: _nameController,
                      hintText: 'Ex: Engenharia de Software',
                      prefixIcon: Icons.school_outlined,
                      textCapitalization: TextCapitalization.sentences,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'O nome do curso é obrigatório.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    const FormSectionLabel(text: 'Descrição'),
                    const SizedBox(height: 8),
                    CustomTextFormField(
                      controller: _descriptionController,
                      hintText: 'Descreva o curso',
                      prefixIcon: Icons.description_outlined,
                      textCapitalization: TextCapitalization.sentences,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'A descrição é obrigatória.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    const FormSectionLabel(text: 'Duração (horas)'),
                    const SizedBox(height: 8),
                    CustomTextFormField(
                      controller: _durationController,
                      hintText: 'Ex: 40',
                      prefixIcon: Icons.timer_outlined,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'A duração é obrigatória.';
                        }
                        if (int.tryParse(value.trim()) == null) {
                          return 'Informe um número válido.';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                FormSubmitButton(
                  label: _isEditing ? 'Salvar Alterações' : 'Cadastrar Curso',
                  onPressed: _saveForm,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
