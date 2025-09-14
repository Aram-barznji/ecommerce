import 'package:sqflite/sqflite.dart';
import '../data_sources/local_db.dart';
import '../../core/constants.dart';

abstract class AuthRepository {
  Future<bool> login(String username, String password);
  Future<bool> isLoggedIn();
  Future<void> logout();
}

class AuthRepositoryImpl implements AuthRepository {
  final LocalDB localDB;

  AuthRepositoryImpl(this.localDB);

  @override
  Future<bool> login(String username, String password) async {
    final db = await localDB.database;
    final result = await db.query(
      Constants.userTable,
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );

    if (result.isEmpty) {
      // Insert user for one-time login (simulate registration)
      await db.insert(Constants.userTable, {
        'username': username,
        'password': password,
      });
      return true;
    }
    return true;
  }

  @override
  Future<bool> isLoggedIn() async {
    final db = await localDB.database;
    final result = await db.query(Constants.userTable);
    return result.isNotEmpty;
  }

  @override
  Future<void> logout() async {
    final db = await localDB.database;
    await db.delete(Constants.userTable);
  }
}