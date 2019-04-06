import 'dart:async';

import 'package:account_managment/dao/DatabaseHelper.dart';
import 'package:account_managment/model/Account.dart';
import 'package:sqflite/sqflite.dart';


class AccountDAO {

  DatabaseHelper dh = new DatabaseHelper();

  static final String _ACCOUNTS_TABLE_NAME = 'accounts';
  static final String _HOPPIES_TABLE_NAME = 'hoppies';

   static String get CREATE_ACCOUNTS_TABLE =>
       "CREATE TABLE $_ACCOUNTS_TABLE_NAME ("
           "  id INTEGER PRIMARY KEY"
           ", firstName TEXT"
           ", lastName TEXT"
           ", job INTEGER"
           ", bod INTEGER"
           ", sex INTEGER"
           ", active INTEGER"
           ", comment TEXT"
           ", power REAL"
           ")";

  static String get CREATE_HOPPIES_TABLE =>
      "CREATE TABLE $_HOPPIES_TABLE_NAME ("
          "  id INTEGER PRIMARY KEY"
          ", ACNT_ID INTEGER"
          ", HPY_ID INTEGER"
          ")";

  Future<void> insert(Account o) async {
    final Database db = await dh.database;
    final b = db.batch();
    b.insert(_ACCOUNTS_TABLE_NAME
        , o.toMap()
        , conflictAlgorithm: ConflictAlgorithm.replace
    );

//    int acntId = 0;//TODO
//    o.hoppies.forEach((hpy) {
//      b.insert(_HOPPIES_TABLE_NAME
//          , {"ACNT_ID": acntId, "HPY_ID": hpy.code}
//          , conflictAlgorithm: ConflictAlgorithm.fail
//      );
//    });
    b.commit(noResult: true);
  }

  Future<void> insertBatch(List<Account> list) async {
    final Database db = await dh.database;
    final b = db.batch();
    list.forEach((o) {
      b.insert(_ACCOUNTS_TABLE_NAME
          , o.toMap()
          , conflictAlgorithm: ConflictAlgorithm.replace
      );

//    int acntId = 0;//TODO
//    o.hoppies.forEach((hpy) {
//      b.insert(_HOPPIES_TABLE_NAME
//          , {"ACNT_ID": acntId, "HPY_ID": hpy.code}
//          , conflictAlgorithm: ConflictAlgorithm.fail
//      );
//    });
    });
    b.commit(noResult: true);
  }

  Future<void> update(Account o) async {
    final Database db = await dh.database;
    await db.update(_ACCOUNTS_TABLE_NAME
        , o.toMap()
        , where: "id = ?"
        , whereArgs: [o.id]
    );
  }

  Future<void> delete(Account o) async {
    final Database db = await dh.database;
    await db.delete(_ACCOUNTS_TABLE_NAME
        , where: "id = ?"
        , whereArgs: [o.id]
    );
  }

  Future<List<Account>> all() async {
    final Database db = await dh.database;
    final List<Map<String, dynamic>> maps = await db.query(_ACCOUNTS_TABLE_NAME);
    return List.generate(maps.length, (i) {
          return Account.fromMap(maps[i]);
        }
    );
  }
  
}