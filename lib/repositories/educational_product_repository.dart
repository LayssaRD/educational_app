import '../database/app_database.dart';
import '../models/educational_product.dart';

class EducationalProductRepository {
  final AppDatabase _database = AppDatabase();

  Future<int> insert(EducationalProduct product) async {
    final db = await _database.database;
    return await db.insert('products', product.toMap());
  }

  Future<List<EducationalProduct>> findAll() async {
    final db = await _database.database;
    final results = await db.query('products', orderBy: 'productId DESC');
    return results.map((item) => EducationalProduct.fromMap(item)).toList();
  }

  Future<int> update(EducationalProduct product) async {
    final db = await _database.database;
    return await db.update(
      'products',
      product.toMap(),
      where: 'productId = ?',
      whereArgs: [product.productId],
    );
  }

  Future<int> delete(int productId) async {
    final db = await _database.database;
    return await db.delete(
      'products',
      where: 'productId = ?',
      whereArgs: [productId],
    );
  }
}
