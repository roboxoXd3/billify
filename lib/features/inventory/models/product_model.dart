class Product {
  final int? id; // Changed from String to int for SQLite auto-increment
  final String name;
  final String sku;
  final String category;
  final String description;
  final double costPrice;
  final double sellingPrice;
  final int currentStock;
  final int lowStockThreshold;
  final String unit;
  final DateTime createdAt;
  final DateTime updatedAt;

  Product({
    this.id,
    required this.name,
    required this.sku,
    required this.category,
    required this.description,
    required this.costPrice,
    required this.sellingPrice,
    required this.currentStock,
    required this.lowStockThreshold,
    required this.unit,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : this.createdAt = createdAt ?? DateTime.now(),
        this.updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'sku': sku,
      'category': category,
      'description': description,
      'costPrice': costPrice,
      'sellingPrice': sellingPrice,
      'currentStock': currentStock,
      'lowStockThreshold': lowStockThreshold,
      'unit': unit,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'],
      sku: map['sku'],
      category: map['category'],
      description: map['description'],
      costPrice: map['costPrice'],
      sellingPrice: map['sellingPrice'],
      currentStock: map['currentStock'],
      lowStockThreshold: map['lowStockThreshold'],
      unit: map['unit'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt']),
    );
  }
}
