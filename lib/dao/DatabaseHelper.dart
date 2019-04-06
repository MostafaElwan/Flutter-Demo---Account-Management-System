import 'dart:io';

import 'package:account_managment/dao/AccountDAO.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class DatabaseHelper {

  static final String _DB_NAME = "account_managment.db";
  static final int _DB_VERSION = 2;

  static DatabaseHelper _instance;

  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    if(_instance == null)
      _instance = DatabaseHelper._createInstance();

    return _instance;
  }

  static Database _db;

  Future<Database> get database async {
    if(_db != null)
      return _db;
    _db = await _initDb();
    return _db;
  }

  _initDb() async {
    var theDb = await openDatabase(
      join(await getDatabasesPath(), _DB_NAME),
      version: _DB_VERSION,
      onCreate: (db, v) {
        db.execute(AccountDAO.CREATE_ACCOUNTS_TABLE);
        return db.execute(AccountDAO.CREATE_HOPPIES_TABLE);
      },
    );
    return theDb;
  }

}