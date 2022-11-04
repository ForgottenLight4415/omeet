import 'dart:developer';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class UploadObject {
  final String claimNo;
  final double latitude;
  final double longitude;
  final String file;
  final DateTime time;

  UploadObject({
    required this.claimNo,
    required this.latitude,
    required this.longitude,
    required this.file,
    required this.time,
  });

  UploadObject.fromJson(Map<String, dynamic> object)
      : claimNo = object['claim_no'],
        latitude = object['latitude'],
        longitude = object['longitude'],
        file = object['file'],
        time = DateTime.parse(object['time']);

  Map<String, Object?> toJson() => {
        'claim_no': claimNo,
        'latitude': latitude,
        'longitude': longitude,
        'file': file,
        'time': time.toIso8601String(),
      };
}

class OMeetDatabase {
  static final OMeetDatabase instance = OMeetDatabase._init();

  static Database? _database;

  OMeetDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('omeet.db');
    return _database!;
  }

  Future<Database> _initDB(String dbName) async {
    final String dbPath = await getDatabasesPath();
    final String path = join(dbPath, dbName);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    const String tableName = 'uploads';

    const String id = 'id';
    const String claimNo = 'claim_no';
    const String latitude = 'latitude';
    const String longitude = 'longitude';
    const String file = 'file';
    const String time = 'time';

    const String idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const String doubleType = 'DOUBLE NOT NULL';
    const String textType = 'TEXT NOT NULL';
    const String timeType = 'DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL';

    await db.execute('''
    CREATE TABLE $tableName (
      $id $idType,
      $claimNo $textType,
      $latitude $doubleType,
      $longitude $doubleType,
      $file $textType UNIQUE,
      $time $timeType
    )''');
  }

  Future<int> create(UploadObject object) async {
    final db = await instance.database;
    int id = -1;
    await db.transaction((txn) async {
      id = await txn.insert('uploads', object.toJson());
    });
    return id;
  }

  Future<List<Map<String, Object?>>> show() async {
    final db = await instance.database;
    List<Map<String, Object?>> list = await db.rawQuery(
      'SELECT * FROM uploads',
    );
    return list;
  }
  
  Future<int> exists(String file) async {
    final db = await instance.database;
    List<Map<String, Object?>> list = await db.query("uploads", columns: ["id"], where: "file = ?", whereArgs: ["file"]);
    if (list.isNotEmpty) {
      return list[0]['id'] as int;
    }
    return 0;
  }

  Future<void> delete(int id) async {
    final db = await instance.database;
    await db.transaction((txn) async {
      log('Deleting: $id');
      await txn.rawDelete('DELETE FROM uploads WHERE id = ?', [id]);
    });
  }

  Future<void> close() async {
    final Database db = await instance.database;
    db.close();
  }
}
