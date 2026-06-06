import 'package:flutter/material.dart';
import '../controllers/enrollment_controller.dart';
import '../controllers/student_controller.dart';
import '../controllers/course_controller.dart';
import '../controllers/educational_product_controller.dart';
import '../models/enrollment.dart';

class EnrollmentPage extends StatefulWidget {
  const EnrollmentPage({super.key});

  @override
  State<EnrollmentPage> createState() => _EnrollmentPageState();
}

class _EnrollmentPageState extends State<EnrollmentPage> {
  final controller = EnrollmentController();
  final studentController = StudentController();
  final courseController = CourseController();
  final productController = EducationalProductController();

  int? selectedStudentId;
  int? selectedCourseId;
  int? selectedProductId;

  static const _purple = Color(0xFF534AB7);
  static const _purpleLight = Color(0xFFEEEDFE);
  static const _purpleDark = Color(0xFF3C3489);
  static const _purpleMid = Color(0xFF7F77DD);

  @override
  void initState() {
    super.initState();
    loadAll();
  }

  Future<void> loadAll() async {
    await controller.loadEnrollments();
    await studentController.loadStudents();
    await courseController.loadCourses();
    await productController.loadProducts();
    setState(() {});
  }

  void _clearSelections() {
    selectedStudentId = null;
    selectedCourseId = null;
    selectedProductId = null;
  }

  bool _validateFields(BuildContext dialogContext) {
    if (selectedStudentId == null ||
        selectedCourseId == null ||
        selectedProductId == null) {
      ScaffoldMessenger.of(dialogContext).showSnackBar(
        const SnackBar(
          content: Text('Selecione todos os campos'),
          backgroundColor: _purpleDark,
        ),
      );
      return false;
    }
    return true;
  }

  InputDecoration _dropdownDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: _purple),
      prefixIcon: Icon(icon, color: _purpleMid, size: 20),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: _purpleMid),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: _purple, width: 2),
      ),
      filled: true,
      fillColor: _purpleLight,
    );
  }

  void showAddDialog() {
    _clearSelections();
    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Adicionar matrícula',
            style: TextStyle(color: _purpleDark, fontWeight: FontWeight.w600),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<int>(
                  value: selectedStudentId,
                  isExpanded: true,
                  decoration: _dropdownDecoration(
                    'Aluno',
                    Icons.person_outline,
                  ),
                  items: studentController.students
                      .map(
                        (s) => DropdownMenuItem(
                          value: s.studentId,
                          child: Text(s.name),
                        ),
                      )
                      .toList(),
                  onChanged: (value) =>
                      setDialogState(() => selectedStudentId = value),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<int>(
                  value: selectedCourseId,
                  isExpanded: true,
                  decoration: _dropdownDecoration(
                    'Curso',
                    Icons.school_outlined,
                  ),
                  items: courseController.courses
                      .map(
                        (c) => DropdownMenuItem(
                          value: c.courseId,
                          child: Text(c.name),
                        ),
                      )
                      .toList(),
                  onChanged: (value) =>
                      setDialogState(() => selectedCourseId = value),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<int>(
                  value: selectedProductId,
                  isExpanded: true,
                  decoration: _dropdownDecoration(
                    'Material',
                    Icons.book_outlined,
                  ),
                  items: productController.products
                      .map(
                        (p) => DropdownMenuItem(
                          value: p.productId,
                          child: Text(p.name),
                        ),
                      )
                      .toList(),
                  onChanged: (value) =>
                      setDialogState(() => selectedProductId = value),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                _clearSelections();
                Navigator.pop(dialogContext);
              },
              style: TextButton.styleFrom(foregroundColor: _purple),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (!_validateFields(dialogContext)) return;

                final messenger = ScaffoldMessenger.of(context);
                final navigator = Navigator.of(dialogContext);

                await controller.addEnrollment(
                  Enrollment(
                    studentId: selectedStudentId!,
                    courseId: selectedCourseId!,
                    productId: selectedProductId!,
                    enrollmentDate: DateTime.now().toIso8601String(),
                  ),
                );
                _clearSelections();
                navigator.pop();
                await loadAll();
                messenger.showSnackBar(
                  const SnackBar(
                    content: Text('Matrícula cadastrada com sucesso!'),
                    backgroundColor: _purpleDark,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _purple,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }

  void showEditDialog(Enrollment enrollment) {
    selectedStudentId = enrollment.studentId;
    selectedCourseId = enrollment.courseId;
    selectedProductId = enrollment.productId;

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Editar matrícula',
            style: TextStyle(color: _purpleDark, fontWeight: FontWeight.w600),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<int>(
                  value: selectedStudentId,
                  isExpanded: true,
                  decoration: _dropdownDecoration(
                    'Aluno',
                    Icons.person_outline,
                  ),
                  items: studentController.students
                      .map(
                        (s) => DropdownMenuItem(
                          value: s.studentId,
                          child: Text(s.name),
                        ),
                      )
                      .toList(),
                  onChanged: (value) =>
                      setDialogState(() => selectedStudentId = value),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<int>(
                  value: selectedCourseId,
                  isExpanded: true,
                  decoration: _dropdownDecoration(
                    'Curso',
                    Icons.school_outlined,
                  ),
                  items: courseController.courses
                      .map(
                        (c) => DropdownMenuItem(
                          value: c.courseId,
                          child: Text(c.name),
                        ),
                      )
                      .toList(),
                  onChanged: (value) =>
                      setDialogState(() => selectedCourseId = value),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<int>(
                  value: selectedProductId,
                  isExpanded: true,
                  decoration: _dropdownDecoration(
                    'Material',
                    Icons.book_outlined,
                  ),
                  items: productController.products
                      .map(
                        (p) => DropdownMenuItem(
                          value: p.productId,
                          child: Text(p.name),
                        ),
                      )
                      .toList(),
                  onChanged: (value) =>
                      setDialogState(() => selectedProductId = value),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                _clearSelections();
                Navigator.pop(dialogContext);
              },
              style: TextButton.styleFrom(foregroundColor: _purple),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (!_validateFields(dialogContext)) return;

                final messenger = ScaffoldMessenger.of(context);
                final navigator = Navigator.of(dialogContext);

                await controller.updateEnrollment(
                  Enrollment(
                    enrollmentId: enrollment.enrollmentId,
                    studentId: selectedStudentId!,
                    courseId: selectedCourseId!,
                    productId: selectedProductId!,
                    enrollmentDate: enrollment.enrollmentDate,
                  ),
                );
                _clearSelections();
                navigator.pop();
                await loadAll();
                messenger.showSnackBar(
                  const SnackBar(
                    content: Text('Matrícula atualizada com sucesso!'),
                    backgroundColor: _purpleDark,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _purple,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> deleteEnrollment(Enrollment enrollment) async {
    final studentName = studentController.students
        .firstWhere(
          (s) => s.studentId == enrollment.studentId,
          orElse: () => studentController.students.first,
        )
        .name;

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
      final messenger = ScaffoldMessenger.of(context);
      await controller.deleteEnrollment(enrollment.enrollmentId!);
      await loadAll();
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Matrícula removida'),
          backgroundColor: _purpleDark,
        ),
      );
    }
  }

  String _studentName(int id) {
    try {
      return studentController.students
          .firstWhere((s) => s.studentId == id)
          .name;
    } catch (_) {
      return 'Aluno não encontrado';
    }
  }

  String _courseName(int id) {
    try {
      return courseController.courses.firstWhere((c) => c.courseId == id).name;
    } catch (_) {
      return 'Curso não encontrado';
    }
  }

  String _productName(int id) {
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
      body: controller.enrollments.isEmpty
          ? Center(
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
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: controller.enrollments.length,
              itemBuilder: (context, index) {
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
                            enrollment.enrollmentDate.substring(0, 10),
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
                          onPressed: () => showEditDialog(enrollment),
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
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: showAddDialog,
        backgroundColor: _purple,
        foregroundColor: Colors.white,
        elevation: 2,
        child: const Icon(Icons.add),
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
