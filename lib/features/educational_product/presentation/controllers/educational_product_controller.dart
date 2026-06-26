import 'package:flutter/foundation.dart';

import '../../domain/models/educational_product.dart';
import '../../domain/repositories/educational_product_repository.dart';
import '../../../../core/mixin/paginated_controller_mixin.dart';

class EducationalProductController extends ChangeNotifier
    with PaginatedControllerMixin<EducationalProduct> {
  final EducationalProductRepository _repository;

  EducationalProductController(this._repository);

  List<EducationalProduct> get products => items;

  @override
  Future<List<EducationalProduct>> fetchItems(int limit, int offset) async {
    return await _repository.findAllProduct(limit: limit, offset: offset);
  }

  Future<void> loadProducts() async {
    await initLoad();
  }

  Future<void> addProduct(EducationalProduct product) async {
    try {
      setError(null);
      await _repository.insert(product);
      await initLoad();
    } catch (e) {
      setError('Não foi possível cadastrar o produto.');
    }
  }

  Future<void> updateProduct(EducationalProduct product) async {
    try {
      setError(null);
      await _repository.updateProduct(product);
      await initLoad();
    } catch (e) {
      setError('Não foi possível atualizar o produto.');
    }
  }

  Future<void> deleteProduct(String productId) async {
    try {
      setError(null);
      await _repository.deleteProduct(productId);
      await initLoad();
    } catch (e) {
      setError('Não foi possível remover o produto.');
    }
  }
}
