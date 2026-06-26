import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/models/educational_product.dart';

class EducationalProductRemoteDataSource {
  final SupabaseClient _client;

  EducationalProductRemoteDataSource(this._client);

  Future<void> insert(EducationalProduct product) async {
    await _client.from('products').insert(_toRemoteMap(product));
  }

  Future<List<EducationalProduct>> findAll() async {
    final results = await _client.from('products').select();
    return results
        .map((e) => EducationalProduct.fromMap(_toLocalMap(e)))
        .toList();
  }

  Future<EducationalProduct?> getById(String productId) async {
    final result = await _client
        .from('products')
        .select()
        .eq('product_id', productId)
        .maybeSingle();
    if (result == null) return null;
    return EducationalProduct.fromMap(_toLocalMap(result));
  }

  Future<void> update(EducationalProduct product) async {
    await _client
        .from('products')
        .update(_toRemoteMap(product))
        .eq('product_id', product.productId);
  }

  Future<void> delete(String productId) async {
    await _client.from('products').delete().eq('product_id', productId);
  }

  Map<String, dynamic> _toLocalMap(Map<String, dynamic> r) => {
    'productId': r['product_id'],
    'name': r['name'],
    'description': r['description'],
    'price': r['price'],
    'stockQuantity': r['stock_quantity'],
    'updatedAt': r['updated_at'],
    'isSynced': 1,
  };

  Map<String, dynamic> _toRemoteMap(EducationalProduct p) => {
    'product_id': p.productId,
    'name': p.name,
    'description': p.description,
    'price': p.price,
    'stock_quantity': p.stockQuantity,
    'updated_at': p.updatedAt.toIso8601String(),
  };
}
