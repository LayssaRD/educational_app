import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AppDatabase {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'educational_products.db');

    return await openDatabase(
      path,
      version: 3,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE products (
            productId TEXT PRIMARY KEY,
            name TEXT NOT NULL,
            description TEXT NOT NULL,
            price REAL NOT NULL,
            stockQuantity INTEGER NOT NULL,
            updatedAt TEXT NOT NULL,
            isSynced INTEGER NOT NULL DEFAULT 0
          )
        ''');

        await db.execute('''
          CREATE TABLE courses (
            courseId TEXT PRIMARY KEY,
            name TEXT NOT NULL,
            description TEXT NOT NULL,
            duration INTEGER NOT NULL,
            updatedAt TEXT NOT NULL,
            isSynced INTEGER NOT NULL DEFAULT 0
          )
        ''');

        await db.execute('''
          CREATE TABLE students (
            studentId TEXT PRIMARY KEY,
            name TEXT NOT NULL,
            email TEXT NOT NULL,
            phone TEXT NOT NULL,
            updatedAt TEXT NOT NULL,
            isSynced INTEGER NOT NULL DEFAULT 0
          )
        ''');

        await db.execute('''
          CREATE TABLE enrollments (
            enrollmentId TEXT PRIMARY KEY,
            studentId TEXT NOT NULL,
            courseId TEXT NOT NULL,
            productId TEXT NOT NULL,
            enrollmentDate TEXT NOT NULL,
            updatedAt TEXT NOT NULL,
            isSynced INTEGER NOT NULL DEFAULT 0,
            FOREIGN KEY (studentId) REFERENCES students(studentId),
            FOREIGN KEY (courseId) REFERENCES courses(courseId),
            FOREIGN KEY (productId) REFERENCES products(productId)
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        await db.execute('DROP TABLE IF EXISTS enrollments');
        await db.execute('DROP TABLE IF EXISTS products');
        await db.execute('DROP TABLE IF EXISTS courses');
        await db.execute('DROP TABLE IF EXISTS students');

        await db.execute('''
          CREATE TABLE products (
            productId TEXT PRIMARY KEY,
            name TEXT NOT NULL,
            description TEXT NOT NULL,
            price REAL NOT NULL,
            stockQuantity INTEGER NOT NULL,
            updatedAt TEXT NOT NULL,
            isSynced INTEGER NOT NULL DEFAULT 0
          )
        ''');

        await db.execute('''
          CREATE TABLE courses (
            courseId TEXT PRIMARY KEY,
            name TEXT NOT NULL,
            description TEXT NOT NULL,
            duration INTEGER NOT NULL,
            updatedAt TEXT NOT NULL,
            isSynced INTEGER NOT NULL DEFAULT 0
          )
        ''');

        await db.execute('''
          CREATE TABLE students (
            studentId TEXT PRIMARY KEY,
            name TEXT NOT NULL,
            email TEXT NOT NULL,
            phone TEXT NOT NULL,
            updatedAt TEXT NOT NULL,
            isSynced INTEGER NOT NULL DEFAULT 0
          )
        ''');

        await db.execute('''
          CREATE TABLE enrollments (
            enrollmentId TEXT PRIMARY KEY,
            studentId TEXT NOT NULL,
            courseId TEXT NOT NULL,
            productId TEXT NOT NULL,
            enrollmentDate TEXT NOT NULL,
            updatedAt TEXT NOT NULL,
            isSynced INTEGER NOT NULL DEFAULT 0,
            FOREIGN KEY (studentId) REFERENCES students(studentId),
            FOREIGN KEY (courseId) REFERENCES courses(courseId),
            FOREIGN KEY (productId) REFERENCES products(productId)
          )
        ''');
      },
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
    );
  }
}
