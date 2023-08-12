import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart';

class SQLHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""
    CREATE TABLE product (
      id INTEGER PRIMARY KEY,
      name TEXT NOT NULL,
      sku TEXT NOT NULL UNIQUE,
      price REAL NOT NULL CHECK (price > 0),
      length REAL NOT NULL,
      width REAL NOT NULL,
      height REAL NOT NULL,
      volumetricWeight REAL NOT NULL,
      category TEXT NOT NULL,
      imagePath TEXT NOT NULL,
      minQty INTEGER NOT NULL,
      maxQty INTEGER NOT NULL
    )
  """);
    await database.execute("""
    CREATE TABLE cart (
      id INTEGER PRIMARY KEY,
      name TEXT NOT NULL,
      sku TEXT NOT NULL UNIQUE,
      price REAL NOT NULL CHECK (price > 0),
      product_id INTEGER NOT NULL,
      category TEXT NOT NULL,
      imagePath TEXT NOT NULL,
      quantity INTEGER NOT NULL,
      length REAL NOT NULL,
      width REAL NOT NULL,
      height REAL NOT NULL,
      volumetricWeight REAL NOT NULL,
      FOREIGN KEY (product_id) REFERENCES product (id)
    )
  """);
  }

  static Future<sql.Database> db() async {
    String databasepath = await sql.getDatabasesPath();
    String path = join(databasepath, 'myproducts.db');

    return sql.openDatabase(
      path,
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  static Future<int> addproduct(
    String name,
    String sku,
    double price,
    double length,
    double width,
    double height,
    double volumetricWeight,
    String category,
    String imagePath,
    int minQty,
    int maxQty,
  ) async {
    final db = await SQLHelper.db();
    final data = {
      'name': name,
      'sku': sku,
      'price': price,
      'length': length,
      'width': width,
      'height': height,
      'volumetricWeight': volumetricWeight,
      'category': category,
      'imagePath': imagePath,
      'minQty': minQty,
      'maxQty': maxQty,
    };
    final id = await db.insert('product', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<List<Map<String, dynamic>>> getAllCompanyDetails() async {
    final db = await SQLHelper.db();
    return db.query('product', orderBy: "id");
  }

  static Future<int> updateproduct(
    int id,
    String name,
    String sku,
    double price,
    double length,
    double width,
    double height,
    double volumetricWeight,
    String category,
    String imagePath,
    int minQty,
    int maxQty,
  ) async {
    final db = await SQLHelper.db();
    final data = {
      'name': name,
      'sku': sku,
      'price': price,
      'length': length,
      'width': width,
      'height': height,
      'volumetricWeight': volumetricWeight,
      'category': category,
      'imagePath': imagePath,
      'minQty': minQty,
      'maxQty': maxQty,
    };
    final result =
        await db.update('product', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  static Future<void> productdelete(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete("product", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      print("Something went wrong while deleting:$err");
    }
  }

  static Future<List<Map<String, dynamic>>> searchProducts(
      String searchTerm) async {
    final db = await SQLHelper.db();
    final result = await db.query('product',
        where: "name LIKE ? OR sku LIKE ? OR category LIKE ?",
        whereArgs: ['%$searchTerm%', '%$searchTerm%', '%$searchTerm%'],
        orderBy: "id");
    return result;
  }

  static Future<void> addToCart(
    int productId,
    String productName, // Add the name field as a parameter
    int quantity,
    String sku,
    double price,
    String category,
    String imagePath,
    double length,
    double width,
    double height,
    double volumetricWeight,
  ) async {
    final db = await SQLHelper.db();
    final data = {
      'product_id': productId,
      'name': productName, // Provide the name value
      'quantity': quantity,
      'sku': sku,
      'price': price,
      'category': category,
      'imagePath': imagePath,
      'length': length,
      'width': width,
      'height': height,
      'volumetricWeight': volumetricWeight,
    };
    await db.insert('cart', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  static Future<List<Map<String, dynamic>>> getAllCartDetails() async {
    final db = await SQLHelper.db();
    return db.query('cart', orderBy: "id");
  }

  static Future<void> deleteaddToCart(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete("cart", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      print("Something went wrong while deleting:$err");
    }
  }
}
