import 'package:educational_products_app/core/supabase/supabase_config.dart';
import 'package:educational_products_app/features/student/data/datasources/student_remote_datasource.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/presentation/widgets/form/custom_text_form_field.dart';
import '../../../../core/presentation/widgets/form/form_card_section.dart';
import '../../../../core/presentation/widgets/form/form_header_icon.dart';
import '../../../../core/presentation/widgets/form/form_section_label.dart';
import '../../../../core/presentation/widgets/form/form_submit_button.dart';
import '../../data/datasources/student_local_datasource.dart';
import '../../data/repositories/sqlite_student_repository.dart';
import '../../domain/models/student.dart';
import '../controllers/student_controller.dart';

class StudentFormPage extends StatefulWidget {
  final Student? student;

  const StudentFormPage({super.key, this.student});

  @override
  State<StudentFormPage> createState() => _StudentFormPageState();
}

class _StudentFormPageState extends State<StudentFormPage> {
  late final StudentController controller;

  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;

  bool _isEditing = false;

  static const _purple = Color(0xFF534AB7);
  static const _purpleDark = Color(0xFF3C3489);

  @override
  void initState() {
    super.initState();

    final database = AppDatabase();
    final dataSource = StudentLocalDataSource(database);
    final remoteDataSource = StudentRemoteDataSource(SupabaseConfig.client);
    final repository = SqliteStudentRepository(dataSource, remoteDataSource);
    controller = StudentController(repository);

    _isEditing = widget.student != null;
    _nameController = TextEditingController(text: widget.student?.name ?? '');
    _emailController = TextEditingController(text: widget.student?.email ?? '');
    _phoneController = TextEditingController(text: widget.student?.phone ?? '');
  }

  @override
  void dispose() {
    controller.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
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
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();

    try {
      if (_isEditing) {
        final updatedStudent = widget.student!.copyWith(
          name: name,
          email: email,
          phone: phone,
          updatedAt: DateTime.now(),
          isSynced: false,
        );
        await controller.updateStudent(updatedStudent);

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
        final newStudent = Student(
          studentId: const Uuid().v4(),
          name: name,
          email: email,
          phone: phone,
          updatedAt: DateTime.now(),
          isSynced: false,
        );
        await controller.addStudent(newStudent);

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
          _isEditing ? 'Detalhes do Aluno' : 'Novo Aluno',
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
                const FormHeaderIcon(icon: Icons.person_outline),
                const SizedBox(height: 32),
                FormCardSection(
                  title: 'Informações do Aluno',
                  children: [
                    const FormSectionLabel(text: 'Nome'),
                    const SizedBox(height: 8),
                    CustomTextFormField(
                      controller: _nameController,
                      hintText: 'Ex: João da Silva',
                      prefixIcon: Icons.person_outline,
                      textCapitalization: TextCapitalization.words,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'O nome é obrigatório.';
                        }
                        if (value.trim().length < 2) {
                          return 'O nome deve ter pelo menos 2 caracteres.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    const FormSectionLabel(text: 'E-mail'),
                    const SizedBox(height: 8),
                    CustomTextFormField(
                      controller: _emailController,
                      hintText: 'Ex: joao@email.com',
                      prefixIcon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'O e-mail é obrigatório.';
                        }
                        if (!value.contains('@') || !value.contains('.')) {
                          return 'Informe um e-mail válido.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    const FormSectionLabel(text: 'Telefone'),
                    const SizedBox(height: 8),
                    CustomTextFormField(
                      controller: _phoneController,
                      hintText: 'Ex: (45) 99999-9999',
                      prefixIcon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'O telefone é obrigatório.';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                FormSubmitButton(
                  label: _isEditing ? 'Salvar Alterações' : 'Cadastrar Aluno',
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
