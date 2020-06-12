import 'package:fluttergiderhesaplama/models/harcama.dart';
import 'package:fluttergiderhesaplama/models/kategori.dart';
import 'package:sqflite/sqflite.dart';
import 'package:synchronized/synchronized.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper;
  static Database _datebase;

  DatabaseHelper._internal();

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._internal();
      return _databaseHelper;
    } else {
      return _databaseHelper;
    }
  }

  Future<Database> getDatabase() async {
    if (_datebase == null) {
      _datebase = await initDB();
      return _datebase;
    } else {
      return _datebase;
    }
  }

  Future<Database> initDB() async {
    var lock = Lock();
    Database _db;

    if (_db == null) {
      await lock.synchronized(() async {
        if (_db == null) {
          var databasesPath = await getDatabasesPath();
          var path = join(databasesPath, "app.db");
          var file = new File(path);

          // check if file exists
          if (!await file.exists()) {
            // Copy from asset
            ByteData data = await rootBundle.load(join("assets", "harcama.db"));
            List<int> bytes =
                data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
            await new File(path).writeAsBytes(bytes);
          }
          // open the database
          _db = await openDatabase(path);
        }
      });
    }

    return _db;
  }

  Future<List<Map<String, dynamic>>> kategorileriGetir() async {
    var db = await getDatabase();
    var sonuc = await db.query('kategoriler');
    return sonuc;
  }

  Future<List<Kategori>> kategoriListesiniGetir() async {
    var map = await kategorileriGetir();
    var kategoriListesi = List<Kategori>();

    for (Map m in map) {
      kategoriListesi.add(Kategori.fromMap(m));
    }
    return kategoriListesi;
  }

  Future<int> kategoriEkle(Kategori kat) async {
    var db = await getDatabase();
    var sonuc = await db.insert("kategoriler", kat.toMap());
    return sonuc;
  }

  Future<int> kategoriGuncelle(Kategori kat) async {
    var db = await getDatabase();
    var sonuc = await db.update("kategoriler", kat.toMap(),
        where: 'kategoriID=?', whereArgs: [kat.kategoriID]);
    return sonuc;
  }

  Future<int> kategoriSil(Kategori katID) async {
    var db = await getDatabase();
    var sonuc = await db
        .delete("kategoriler", where: 'kategoriID=?', whereArgs: [katID]);
    return sonuc;
  }

  Future<List<Map<String, dynamic>>> harcamalariGetir() async {
    var db = await getDatabase();
    var sonuc = await db.rawQuery(
        "select * from harcamalar inner join kategoriler on kategoriler.kategoriID=harcamalar.kategoriID order by harcamalarID Desc");
    return sonuc;
  }

  Future<List<Harcama>> harcamalarListesiniGetir() async {
    var map = await harcamalariGetir();
    var harcamaListesi = List<Harcama>();

    for (Map m in map) {
      harcamaListesi.add(Harcama.fromMap(m));
    }
    return harcamaListesi;
  }

  Future<int> harcamaEkle(Harcama har) async {
    var db = await getDatabase();
    var sonuc = await db.insert("harcamalar", har.toMap());
    return sonuc;
  }

  Future<int> harcamalariGuncelle(Harcama har) async {
    var db = await getDatabase();
    var sonuc = await db.update("harcamalar", har.toMap(),
        where: 'harcamaID=?', whereArgs: [har.harcamaID]);
    return sonuc;
  }

  Future<int> harcamaSil(Harcama harID) async {
    var db = await getDatabase();
    var sonuc = await db
        .delete("harcamalar", where: 'harcamaID=?', whereArgs: [harID]);
    return sonuc;
  }
}
