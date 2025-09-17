import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../core/constants.dart';

class LocalDatabase {
  static final LocalDatabase _instance = LocalDatabase._internal();
  factory LocalDatabase() => _instance;
  LocalDatabase._internal();
  
  static LocalDatabase get instance => _instance;
  
  Database? _database;
  
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }
  
  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, AppConstants.dbName);
    
    return await openDatabase(
      path,
      version: AppConstants.dbVersion,
      onCreate: _onCreate,
    );
  }
  
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE cart(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        productId TEXT NOT NULL,
        productData TEXT NOT NULL,
        quantity INTEGER NOT NULL
      )
    ''');
    
    await db.execute('''
      CREATE TABLE favorites(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        productId TEXT NOT NULL UNIQUE,
        addedAt INTEGER NOT NULL
      )
    ''');
  }
  
  Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
    }
  }
}