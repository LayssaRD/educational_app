import '../models/educational_product.dart';

abstract class EducationalProductRepository {
  Future<void> insert(EducationalProduct product);

  Future<List<EducationalProduct>> findAllProduct({int? limit, int? offset});

  Future<EducationalProduct?> getProductById(String productId);

  Future<int> updateProduct(EducationalProduct product);

  Future<int> deleteProduct(String productId);
}
