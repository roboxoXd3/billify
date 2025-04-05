import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/product_model.dart';
import '../models/category_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('inventory.db', 2);
    return _database!;
  }

  Future<Database> _initDB(String filePath, int version) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    // Uncomment this line temporarily to reset the database
    // await deleteDatabase(path);

    return await openDatabase(
      path,
      version: version,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    // Create categories table first
    await db.execute('''
      CREATE TABLE categories(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        description TEXT,
        createdAt INTEGER NOT NULL
      )
    ''');

    // Then create products table with foreign key
    await db.execute('''
      CREATE TABLE products(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        sku TEXT NOT NULL,
        category TEXT NOT NULL,
        description TEXT,
        costPrice REAL NOT NULL,
        sellingPrice REAL NOT NULL,
        currentStock INTEGER NOT NULL,
        lowStockThreshold INTEGER NOT NULL,
        unit TEXT NOT NULL,
        createdAt INTEGER NOT NULL,
        updatedAt INTEGER NOT NULL
      )
    ''');

    // Add bills table
    await db.execute('''
      CREATE TABLE bills(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        billNumber TEXT,
        customerName TEXT,
        customerAge TEXT,
        customerPhone TEXT,
        customerLocation TEXT,
        grandTotal TEXT,
        createdAt TEXT,
        productType TEXT
      )
    ''');

    // Add bill_items table for products in each bill
    await db.execute('''
      CREATE TABLE bill_items(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        billId INTEGER,
        productName TEXT,
        quantity INTEGER,
        amount REAL,
        totalAmount REAL,
        FOREIGN KEY (billId) REFERENCES bills (id)
      )
    ''');
  }

  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Create bills table
      await db.execute('''
        CREATE TABLE bills(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          billNumber TEXT,
          customerName TEXT,
          customerAge TEXT,
          customerPhone TEXT,
          customerLocation TEXT,
          grandTotal TEXT,
          createdAt TEXT,
          productType TEXT
        )
      ''');

      // Create bill_items table
      await db.execute('''
        CREATE TABLE bill_items(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          billId INTEGER,
          productName TEXT,
          quantity INTEGER,
          amount REAL,
          totalAmount REAL,
          FOREIGN KEY (billId) REFERENCES bills (id)
        )
      ''');
    }
  }

  // CRUD Operations
  Future<int> insertProduct(Product product) async {
    final db = await database;
    try {
      final id = await db.insert('products', {
        'name': product.name,
        'sku': product.sku,
        'category': product.category,
        'description': product.description,
        'costPrice': product.costPrice,
        'sellingPrice': product.sellingPrice,
        'currentStock': product.currentStock,
        'lowStockThreshold': product.lowStockThreshold,
        'unit': product.unit,
        'createdAt': DateTime.now().millisecondsSinceEpoch,
        'updatedAt': DateTime.now().millisecondsSinceEpoch,
      });
      print('Product inserted with id: $id'); // Debug print
      return id;
    } catch (e) {
      print('Error inserting product: $e');
      rethrow;
    }
  }

  Future<List<Product>> getAllProducts() async {
    final db = await database;
    try {
      final List<Map<String, dynamic>> maps = await db.query('products');
      print('Retrieved ${maps.length} products from db'); // Debug print
      return List.generate(maps.length, (i) {
        return Product(
          id: maps[i]['id'],
          name: maps[i]['name'],
          sku: maps[i]['sku'],
          category: maps[i]['category'],
          description: maps[i]['description'],
          costPrice: maps[i]['costPrice'],
          sellingPrice: maps[i]['sellingPrice'],
          currentStock: maps[i]['currentStock'],
          lowStockThreshold: maps[i]['lowStockThreshold'],
          unit: maps[i]['unit'],
          createdAt: DateTime.fromMillisecondsSinceEpoch(maps[i]['createdAt']),
          updatedAt: DateTime.fromMillisecondsSinceEpoch(maps[i]['updatedAt']),
        );
      });
    } catch (e) {
      print('Error getting products: $e');
      return [];
    }
  }

  Future<Product?> getProduct(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'products',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Product.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updateProduct(Product product) async {
    final db = await database;
    return await db.update(
      'products',
      product.toMap(),
      where: 'id = ?',
      whereArgs: [product.id],
    );
  }

  Future<int> deleteProduct(int id) async {
    final db = await database;
    return await db.delete(
      'products',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Category CRUD operations
  Future<int> insertCategory(Category category) async {
    final db = await database;
    return await db.insert('categories', category.toMap());
  }

  Future<List<Category>> getAllCategories() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('categories');
    return List.generate(maps.length, (i) => Category.fromMap(maps[i]));
  }

  // Add methods to save and retrieve bills
  Future<int> insertBill(Map<String, dynamic> customerDetails) async {
    final db = await database;
    return await db.insert('bills', {
      'billNumber': customerDetails['billNumber'],
      'customerName': customerDetails['name'],
      'customerAge': customerDetails['age'],
      'customerPhone': customerDetails['phoneNumber'],
      'customerLocation': customerDetails['location'],
      'grandTotal': customerDetails['grandTotal'],
      'createdAt': customerDetails['createdAt'],
      'productType': customerDetails['productType'],
    });
  }

  Future<void> insertBillItems(
      int billId, List<Map<String, dynamic>> products) async {
    final db = await database;
    final batch = db.batch();

    for (var product in products) {
      batch.insert('bill_items', {
        'billId': billId,
        'productName': product['productName'],
        'quantity': int.parse(product['qty']),
        'amount': double.parse(product['amount']),
        'totalAmount': double.parse(product['totalAmount']),
      });
    }

    await batch.commit();
  }

  Future<List<Map<String, dynamic>>> getAllBills() async {
    final db = await database;
    return await db.query('bills', orderBy: 'createdAt DESC');
  }

  Future<List<Map<String, dynamic>>> getBillItems(int billId) async {
    final db = await database;
    return await db.query(
      'bill_items',
      where: 'billId = ?',
      whereArgs: [billId],
    );
  }

  Future<void> deleteBill(String billNumber) async {
    final db = await database;

    // First get the bill ID
    final List<Map<String, dynamic>> bills = await db.query(
      'bills',
      where: 'billNumber = ?',
      whereArgs: [billNumber],
    );

    if (bills.isNotEmpty) {
      final billId = bills.first['id'];

      // Delete bill items first (due to foreign key constraint)
      await db.delete(
        'bill_items',
        where: 'billId = ?',
        whereArgs: [billId],
      );

      // Then delete the bill
      await db.delete(
        'bills',
        where: 'billNumber = ?',
        whereArgs: [billNumber],
      );
    }
  }

  Future<Product?> getProductByName(String name) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'products',
      where: 'name = ?',
      whereArgs: [name],
    );
    if (maps.isNotEmpty) {
      return Product.fromMap(maps.first);
    }
    return null;
  }

  Future<void> updateProductStock(String sku, int newStock) async {
    final db = await database;
    await db.update(
      'products',
      {'currentStock': newStock},
      where: 'sku = ?',
      whereArgs: [sku],
    );
  }
}
