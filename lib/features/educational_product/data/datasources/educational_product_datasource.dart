import '../../../../core/database/app_database.dart';
import '../../domain/models/educational_product.dart';

class EducationalProductLocalDataSource {
  final AppDatabase _database;

  EducationalProductLocalDataSource(this._database);

  Future<void> insert(EducationalProduct product) async {
    final db = await _database.database;
    await db.insert('products', product.toMap());
  }

  Future<List<EducationalProduct>> findAll({int? limit, int? offset}) async {
    final db = await _database.database;

    final results = await db.query(
      'products',
      orderBy: 'name ASC',
      limit: limit,
      offset: offset,
    );

    return results.map((e) => EducationalProduct.fromMap(e)).toList();
  }

  Future<EducationalProduct?> getById(String productId) async {
    final db = await _database.database;

    final results = await db.query(
      'products',
      where: 'productId = ?',
      whereArgs: [productId],
    );

    if (results.isEmpty) return null;

    return EducationalProduct.fromMap(results.first);
  }

  Future<int> update(EducationalProduct product) async {
    final db = await _database.database;

    return db.update(
      'products',
      product.toMap(),
      where: 'productId = ?',
      whereArgs: [product.productId],
    );
  }

  Future<int> delete(String productId) async {
    final db = await _database.database;

    return db.delete(
      'products',
      where: 'productId = ?',
      whereArgs: [productId],
    );
  }
}
