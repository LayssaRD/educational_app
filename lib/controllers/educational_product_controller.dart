import '../models/educational_product.dart';
import '../repositories/educational_product_repository.dart';

class EducationalProductController {
  final EducationalProductRepository _repository =
      EducationalProductRepository();

  List<EducationalProduct> products = [];

  Future<void> loadProducts() async {
    products = await _repository.findAll();
  }

  Future<void> addProduct(EducationalProduct product) async {
    await _repository.insert(product);
    await loadProducts();
  }

  Future<void> updateProduct(EducationalProduct product) async {
    await _repository.update(product);
    await loadProducts();
  }

  Future<void> deleteProduct(int productId) async {
    await _repository.delete(productId);
    await loadProducts();
  }
}
