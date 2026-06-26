import '../../domain/models/educational_product.dart';
import '../../domain/repositories/educational_product_repository.dart';
import '../datasources/educational_product_datasource.dart';
import '../datasources/educational_product_remote_datasource.dart';

class SqliteEducationalProductRepository
    implements EducationalProductRepository {
  final EducationalProductLocalDataSource _local;
  final EducationalProductRemoteDataSource _remote;

  SqliteEducationalProductRepository(this._local, this._remote);

  @override
  Future<void> insert(EducationalProduct product) async {
    await _local.insert(product);
    try {
      await _remote.insert(product);
      await _local.update(product.copyWith(isSynced: true));
    } catch (_) {}
  }

  @override
  Future<List<EducationalProduct>> findAllProduct({
    int? limit,
    int? offset,
  }) async {
    try {
      final remoteList = await _remote.findAll();
      for (final product in remoteList) {
        final local = await _local.getById(product.productId);
        if (local == null) {
          await _local.insert(product);
        } else {
          await _local.update(product);
        }
      }
    } catch (_) {}
    return _local.findAll(limit: limit, offset: offset);
  }

  @override
  Future<EducationalProduct?> getProductById(String productId) async {
    try {
      final remote = await _remote.getById(productId);
      if (remote != null) {
        await _local.update(remote);
        return remote;
      }
    } catch (_) {}
    return _local.getById(productId);
  }

  @override
  Future<int> updateProduct(EducationalProduct product) async {
    final result = await _local.update(product.copyWith(isSynced: false));
    try {
      await _remote.update(product);
      await _local.update(product.copyWith(isSynced: true));
    } catch (_) {}
    return result;
  }

  @override
  Future<int> deleteProduct(String productId) async {
    final result = await _local.delete(productId);
    try {
      await _remote.delete(productId);
    } catch (_) {}
    return result;
  }
}
