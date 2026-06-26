import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/presentation/widgets/form/form_card_section.dart';
import '../../../../core/presentation/widgets/form/form_header_icon.dart';
import '../../../../core/presentation/widgets/form/form_section_label.dart';
import '../../../../core/presentation/widgets/form/form_submit_button.dart';
import '../../../../core/supabase/supabase_config.dart';
import '../../../student/domain/models/student.dart';
import '../../../course/domain/models/course.dart';
import '../../../educational_product/domain/models/educational_product.dart';
import '../../data/datasources/enrollment_local_datasource.dart';
import '../../data/datasources/enrollment_remote_datasource.dart';
import '../../data/repositories/sqlite_enrollment_repository.dart';
import '../../domain/models/enrollment.dart';
import '../controllers/enrollment_controller.dart';

class EnrollmentFormPage extends StatefulWidget {
  final Enrollment? enrollment;
  final List<Student> students;
  final List<Course> courses;
  final List<EducationalProduct> products;

  const EnrollmentFormPage({
    super.key,
    this.enrollment,
    required this.students,
    required this.courses,
    required this.products,
  });

  @override
  State<EnrollmentFormPage> createState() => _EnrollmentFormPageState();
}

class _EnrollmentFormPageState extends State<EnrollmentFormPage> {
  late final EnrollmentController controller;

  final _formKey = GlobalKey<FormState>();

  String? _selectedStudentId;
  String? _selectedCourseId;
  String? _selectedProductId;

  bool _isEditing = false;

  static const _purple = Color(0xFF534AB7);
  static const _purpleLight = Color(0xFFEEEDFE);
  static const _purpleDark = Color(0xFF3C3489);
  static const _purpleMid = Color(0xFF7F77DD);

  @override
  void initState() {
    super.initState();

    final database = AppDatabase();
    final dataSource = EnrollmentLocalDataSource(database);
    final remoteDataSource = EnrollmentRemoteDataSource(SupabaseConfig.client);
    final repository = SqliteEnrollmentRepository(dataSource, remoteDataSource);
    controller = EnrollmentController(repository);

    _isEditing = widget.enrollment != null;
    _selectedStudentId = widget.enrollment?.studentId;
    _selectedCourseId = widget.enrollment?.courseId;
    _selectedProductId = widget.enrollment?.productId;
  }

  @override
  void dispose() {
    controller.dispose();
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

  InputDecoration _dropdownDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: _purple),
      prefixIcon: Icon(icon, color: _purpleMid, size: 20),
      filled: true,
      fillColor: _purpleLight,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: _purpleMid),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: _purple, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.redAccent, width: 2),
      ),
    );
  }

  Future<void> _saveForm() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedStudentId == null ||
        _selectedCourseId == null ||
        _selectedProductId == null) {
      _showSnackBar('Selecione todos os campos.', isError: true);
      return;
    }

    final studentName = widget.students
        .firstWhere((s) => s.studentId == _selectedStudentId)
        .name;

    try {
      if (_isEditing) {
        final updatedEnrollment = widget.enrollment!.copyWith(
          studentId: _selectedStudentId!,
          courseId: _selectedCourseId!,
          productId: _selectedProductId!,
          updatedAt: DateTime.now(),
          isSynced: false,
        );
        await controller.updateEnrollment(updatedEnrollment);

        if (controller.errorMessage == null) {
          _showSnackBar('Matrícula de $studentName atualizada com sucesso!');
          if (mounted) Navigator.of(context).pop(true);
        } else {
          _showSnackBar(
            'Erro ao atualizar: ${controller.errorMessage}',
            isError: true,
          );
        }
      } else {
        final newEnrollment = Enrollment(
          enrollmentId: const Uuid().v4(),
          studentId: _selectedStudentId!,
          courseId: _selectedCourseId!,
          productId: _selectedProductId!,
          enrollmentDate: DateTime.now().toIso8601String(),
          updatedAt: DateTime.now(),
          isSynced: false,
        );
        await controller.addEnrollment(newEnrollment);

        if (controller.errorMessage == null) {
          _showSnackBar('Matrícula de $studentName cadastrada com sucesso!');
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
          _isEditing ? 'Detalhes da Matrícula' : 'Nova Matrícula',
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
                const FormHeaderIcon(icon: Icons.assignment_outlined),
                const SizedBox(height: 32),
                FormCardSection(
                  title: 'Dados da Matrícula',
                  children: [
                    const FormSectionLabel(text: 'Aluno'),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      initialValue: _selectedStudentId,
                      isExpanded: true,
                      decoration: _dropdownDecoration(
                        'Selecione o aluno',
                        Icons.person_outline,
                      ),
                      items: widget.students
                          .map(
                            (s) => DropdownMenuItem(
                              value: s.studentId,
                              child: Text(s.name),
                            ),
                          )
                          .toList(),
                      onChanged: (value) =>
                          setState(() => _selectedStudentId = value),
                      validator: (value) =>
                          value == null ? 'Selecione um aluno.' : null,
                    ),
                    const SizedBox(height: 20),
                    const FormSectionLabel(text: 'Curso'),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      initialValue: _selectedCourseId,
                      isExpanded: true,
                      decoration: _dropdownDecoration(
                        'Selecione o curso',
                        Icons.school_outlined,
                      ),
                      items: widget.courses
                          .map(
                            (c) => DropdownMenuItem(
                              value: c.courseId,
                              child: Text(c.name),
                            ),
                          )
                          .toList(),
                      onChanged: (value) =>
                          setState(() => _selectedCourseId = value),
                      validator: (value) =>
                          value == null ? 'Selecione um curso.' : null,
                    ),
                    const SizedBox(height: 20),
                    const FormSectionLabel(text: 'Material'),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      initialValue: _selectedProductId,
                      isExpanded: true,
                      decoration: _dropdownDecoration(
                        'Selecione o material',
                        Icons.book_outlined,
                      ),
                      items: widget.products
                          .map(
                            (p) => DropdownMenuItem(
                              value: p.productId,
                              child: Text(p.name),
                            ),
                          )
                          .toList(),
                      onChanged: (value) =>
                          setState(() => _selectedProductId = value),
                      validator: (value) =>
                          value == null ? 'Selecione um material.' : null,
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                FormSubmitButton(
                  label: _isEditing
                      ? 'Salvar Alterações'
                      : 'Cadastrar Matrícula',
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
