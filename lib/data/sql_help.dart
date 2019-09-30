import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'book.dart';

abstract class BaseData {
  Map<String, dynamic> toMap();

  fromMap(Map<String, dynamic> map);

  String getPrimayKey();

  String getTableName();
}

class SqlHelp {
  static const String DB_NAME = "base";

  factory SqlHelp() => _sharedInstance();

  static SqlHelp _instance;
  var dbPath;

  static SqlHelp _sharedInstance() {
    if (_instance == null) {
      _instance = SqlHelp._();
    }
    return _instance;
  }

  SqlHelp._() {
    _createDb();
  }

  String _getType(value) {
    String typeName;
    ;
    if (value.runtimeType == bool) {
      typeName = "TEXT";
    } else if (value.runtimeType == int) {
      typeName = "INTEGER";
    } else {
      typeName = "TEXT";
    }
    return typeName;
  }

  //创建数据库
  _createDb() async {
    //获取数据库文件路径
    var dbPath = await getDatabasesPath();
    this.dbPath = join(dbPath, DB_NAME);
    _createTable(Book());
  }

  _createTable(BaseData data) async {
    Database db = await openDatabase(dbPath);
    String name = data.getTableName();
    Map<String, dynamic> tempMap = data.toMap();
    var sql = "create table if not exists $name(";
    String primaryKey = data.getPrimayKey();
    if (null == primaryKey)
      sql += "id integer PRIMARY KEY autoincrement";
    else {
      String valueType = _getType(tempMap[primaryKey]);
      sql += "$primaryKey $valueType PRIMARY KEY";
    }
    tempMap.remove(primaryKey);

    tempMap.forEach((key, value) {
      sql += ", $key " + _getType(value);
    });

    sql += ")";

    print(sql);
    await db.execute(sql);
    await db.close();
  }

  //打开数据库，获取数据库对象
  _open() async {
    if (null == dbPath) {
      var path = await getDatabasesPath();
      dbPath = join(path, DB_NAME);
    }
    return await openDatabase(dbPath);
  }

  insertOrReplace(BaseData data) async {
    String tabaName = data.getTableName();
    Database db = await _open();
    String culmns = "";
    String values = "";
    Map<String, dynamic> tempMap = data.toMap();
    tempMap.forEach((key, value) {
      culmns += ", $key";
      if (value.runtimeType != int)
        values += ",'" + value.toString() + "'";
      else
        values += "," + value.toString();
    });
    culmns = culmns.substring(2);
    values = values.substring(1);
    String sql = "INSERT OR REPLACE INTO $tabaName($culmns) VALUES ($values)";
    print(sql);
    //开启事务
    await db.transaction((txn) async {
      int id = await txn.rawInsert(sql);
      print('id:' + id.toString());
    });
    await db.close();
  }

  Future<List<Map>> queryAll(BaseData data) async {
    String tabaName = data.getTableName();
    Database db = await _open();
    List<Map> list = await db.rawQuery("SELECT * FROM $tabaName");
    await db.close();
    return list;
  }

//  add(String tabaName, BaseData data) async {
//    Database db = await _open();
//
//    String sql =
//        "INSERT INTO user_table(username,pwd) VALUES('$username','$pwd')";
//    //开启事务
//    await db.transaction((txn) async {
//      int id = await txn.rawInsert(sql);
//      print("$id");
//    });
//    await db.close();
//  }

  _delete() async {
    Database db = await _open();

    //删除最近一条
    String sql =
        "DELETE FROM user_table where id in (select id from user_table order by id desc limit 1)";
    int count = await db.rawDelete(sql);

    await db.close();
  }

  _update() async {
    Database db = await _open();
    String sql = "UPDATE user_table SET pwd = ? WHERE id = ?";
    int count = await db.rawUpdate(sql, ["654321", '1']);
    print(count);
    await db.close();
  }

  //批量增、改、删数据
  _batch() async {
    Database db = await _open();
    var batch = db.batch();
    batch.insert("user_table", {"username": "batchName1"});
    batch.update("user_table", {"username": "batchName2"},
        where: "username = ?", whereArgs: ["batchName1"]);
    batch.delete("user_table", where: "username = ?", whereArgs: ["Leon"]);
    //返回每个数据库操作的结果组成的数组 [6, 3, 0]：新增返回id=6，修改了3条数据，删除了0条数据
    var results = await batch.commit();
    await db.close();
  }

  _queryNum() async {
    Database db = await _open();
    int count = Sqflite.firstIntValue(await db.rawQuery(""));
    await db.close();
  }

  _query() async {
    Database db = await _open();
    List<Map> list = await db.rawQuery("");
    await db.close();
  }
}
