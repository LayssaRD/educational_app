import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/presentation/widgets/form/custom_text_form_field.dart';
import '../../../../core/presentation/widgets/form/form_card_section.dart';
import '../../../../core/presentation/widgets/form/form_header_icon.dart';
import '../../../../core/presentation/widgets/form/form_section_label.dart';
import '../../../../core/presentation/widgets/form/form_submit_button.dart';
import '../../data/datasources/educational_product_datasource.dart';
import '../../data/datasources/educational_product_remote_datasource.dart';
import '../../data/repositories/sqlite_educational_product_repository.dart';
import '../../domain/models/educational_product.dart';
import '../controllers/educational_product_controller.dart';
import '../../../../core/supabase/supabase_config.dart';

class EducationalProductFormPage extends StatefulWidget {
  final EducationalProduct? product;

  const EducationalProductFormPage({super.key, this.product});

  @override
  State<EducationalProductFormPage> createState() =>
      _EducationalProductFormPageState();
}

class _EducationalProductFormPageState
    extends State<EducationalProductFormPage> {
  late final EducationalProductController controller;

  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _priceController;
  late final TextEditingController _stockController;

  bool _isEditing = false;

  static const _purple = Color(0xFF534AB7);
  static const _purpleDark = Color(0xFF3C3489);

  @override
  void initState() {
    super.initState();

    final database = AppDatabase();
    final dataSource = EducationalProductLocalDataSource(database);
    final remoteDataSource = EducationalProductRemoteDataSource(
      SupabaseConfig.client,
    );
    final repository = SqliteEducationalProductRepository(
      dataSource,
      remoteDataSource,
    );
    controller = EducationalProductController(repository);

    _isEditing = widget.product != null;
    _nameController = TextEditingController(text: widget.product?.name ?? '');
    _descriptionController = TextEditingController(
      text: widget.product?.description ?? '',
    );
    _priceController = TextEditingController(
      text: widget.product?.price.toString() ?? '',
    );
    _stockController = TextEditingController(
      text: widget.product?.stockQuantity.toString() ?? '',
    );
  }

  @override
  void dispose() {
    controller.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _stockController.dispose();
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
    final price = double.tryParse(_priceController.text.trim()) ?? 0.0;
    final stock = int.tryParse(_stockController.text.trim()) ?? 0;

    try {
      if (_isEditing) {
        final updatedProduct = widget.product!.copyWith(
          name: name,
          description: description,
          price: price,
          stockQuantity: stock,
          updatedAt: DateTime.now(),
          isSynced: false,
        );
        await controller.updateProduct(updatedProduct);

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
        final newProduct = EducationalProduct(
          productId: const Uuid().v4(),
          name: name,
          description: description,
          price: price,
          stockQuantity: stock,
          updatedAt: DateTime.now(),
          isSynced: false,
        );
        await controller.addProduct(newProduct);

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
          _isEditing ? 'Detalhes do Produto' : 'Novo Produto',
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
                const FormHeaderIcon(icon: Icons.inventory_2_outlined),
                const SizedBox(height: 32),
                FormCardSection(
                  title: 'Informações do Produto',
                  children: [
                    const FormSectionLabel(text: 'Nome'),
                    const SizedBox(height: 8),
                    CustomTextFormField(
                      controller: _nameController,
                      hintText: 'Ex: Apostila de Matemática',
                      prefixIcon: Icons.label_outline,
                      textCapitalization: TextCapitalization.sentences,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'O nome do produto é obrigatório.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    const FormSectionLabel(text: 'Descrição'),
                    const SizedBox(height: 8),
                    CustomTextFormField(
                      controller: _descriptionController,
                      hintText: 'Descreva o produto',
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
                    const FormSectionLabel(text: 'Preço (R\$)'),
                    const SizedBox(height: 8),
                    CustomTextFormField(
                      controller: _priceController,
                      hintText: 'Ex: 49.90',
                      prefixIcon: Icons.attach_money,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'O preço é obrigatório.';
                        }
                        if (double.tryParse(value.trim()) == null) {
                          return 'Informe um valor válido.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    const FormSectionLabel(text: 'Quantidade em Estoque'),
                    const SizedBox(height: 8),
                    CustomTextFormField(
                      controller: _stockController,
                      hintText: 'Ex: 100',
                      prefixIcon: Icons.inventory_2_outlined,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'A quantidade é obrigatória.';
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
                  label: _isEditing ? 'Salvar Alterações' : 'Cadastrar Produto',
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
