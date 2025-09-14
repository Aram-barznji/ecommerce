import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../../core/constants.dart';

class LocalDB {
  static final LocalDB _instance = LocalDB._internal();
  factory LocalDB() => _instance;
  LocalDB._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, Constants.dbName);

    return await openDatabase(
      path,
      version: Constants.dbVersion,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE ${Constants.userTable}(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL,
        password TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE ${Constants.productTable}(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        description TEXT,
        price REAL NOT NULL
      )
    ''');

    // Insert sample products
    await db.insert(Constants.productTable, {
      'name': 'Wireless Headphones',
      'description': 'Noise-cancelling over-ear headphones',
      'price': 99.99,
    });
    await db.insert(Constants.productTable, {
      'name': 'Smartphone',
      'description': 'Latest Android phone with high-res camera',
      'price': 699.99,
    });
    await db.insert(Constants.productTable, {
      'name': 'Laptop',
      'description': 'Ultra-thin laptop for work and play',
      'price': 1299.99,
    });
  }
}