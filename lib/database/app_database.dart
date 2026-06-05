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
      version: 2,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE products (
            productId INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            description TEXT NOT NULL,
            price REAL NOT NULL,
            stockQuantity INTEGER NOT NULL
          )
        ''');

        await db.execute('''
          CREATE TABLE courses (
            courseId INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            description TEXT NOT NULL,
            duration INTEGER NOT NULL
          )
        ''');

        await db.execute('''
          CREATE TABLE students (
            studentId INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            email TEXT NOT NULL,
            phone TEXT NOT NULL
          )
        ''');

        await db.execute('''
          CREATE TABLE enrollments (
            enrollmentId INTEGER PRIMARY KEY AUTOINCREMENT,
            studentId INTEGER NOT NULL,
            courseId INTEGER NOT NULL,
            productId INTEGER NOT NULL,
            enrollmentDate TEXT NOT NULL,
            FOREIGN KEY (studentId) REFERENCES students(studentId),
            FOREIGN KEY (courseId) REFERENCES courses(courseId),
            FOREIGN KEY (productId) REFERENCES products(productId)
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('''
            CREATE TABLE courses (
              courseId INTEGER PRIMARY KEY AUTOINCREMENT,
              name TEXT NOT NULL,
              description TEXT NOT NULL,
              duration INTEGER NOT NULL
            )
          ''');

          await db.execute('''
            CREATE TABLE students (
              studentId INTEGER PRIMARY KEY AUTOINCREMENT,
              name TEXT NOT NULL,
              email TEXT NOT NULL,
              phone TEXT NOT NULL
            )
          ''');

          await db.execute('''
            CREATE TABLE enrollments (
              enrollmentId INTEGER PRIMARY KEY AUTOINCREMENT,
              studentId INTEGER NOT NULL,
              courseId INTEGER NOT NULL,
              productId INTEGER NOT NULL,
              enrollmentDate TEXT NOT NULL,
              FOREIGN KEY (studentId) REFERENCES students(studentId),
              FOREIGN KEY (courseId) REFERENCES courses(courseId),
              FOREIGN KEY (productId) REFERENCES products(productId)
            )
          ''');
        }
      },
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
    );
  }
}
