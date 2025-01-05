import 'package:get/get.dart';
import '../models/product_model.dart';
import '../services/database_helper.dart';

class ProductController extends GetxController {
  final RxList<Product> products = <Product>[].obs;
  final RxList<Product> filteredProducts = <Product>[].obs;
  final RxBool isLoading = false.obs;
  final RxString searchQuery = ''.obs;
  final RxString selectedCategory = ''.obs;
  final RxList<Product> selectedProducts = <Product>[].obs;

  @override
  void onInit() {
    super.onInit();
    filteredProducts.assignAll([]);
    loadProducts();
  }

  void filterProducts() {
    if (searchQuery.isEmpty && selectedCategory.isEmpty) {
      filteredProducts.assignAll(products);
      return;
    }

    filteredProducts.assignAll(products.where((product) {
      bool matchesSearch = true;
      bool matchesCategory = true;

      if (searchQuery.isNotEmpty) {
        matchesSearch =
            product.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
                product.sku.toLowerCase().contains(searchQuery.toLowerCase());
      }

      if (selectedCategory.isNotEmpty) {
        matchesCategory = product.category == selectedCategory.value;
      }

      return matchesSearch && matchesCategory;
    }).toList());
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
    filterProducts();
  }

  void setSelectedCategory(String category) {
    selectedCategory.value = category;
    filterProducts();
  }

  void clearFilters() {
    searchQuery.value = '';
    selectedCategory.value = '';
    filterProducts();
  }

  Future<void> loadProducts() async {
    isLoading.value = true;
    try {
      final productList = await DatabaseHelper.instance.getAllProducts();
      products.assignAll(productList);
      filteredProducts.assignAll(productList);
      print('Loaded ${products.length} products');
    } catch (e) {
      print('Error loading products: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addProduct(Product product) async {
    try {
      isLoading.value = true;
      await DatabaseHelper.instance.insertProduct(product);
      await loadProducts();
    } catch (e) {
      print('Error adding product: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProduct(Product product) async {
    try {
      await DatabaseHelper.instance.updateProduct(product);
      await loadProducts();
    } catch (e) {
      print('Error updating product: $e');
    }
  }

  Future<void> deleteProduct(int productId) async {
    try {
      await DatabaseHelper.instance.deleteProduct(productId);
      await loadProducts();
    } catch (e) {
      print('Error deleting product: $e');
    }
  }

  void toggleProductSelection(Product product) {
    if (isProductSelected(product)) {
      selectedProducts.remove(product);
    } else {
      selectedProducts.add(product);
    }
  }

  bool isProductSelected(Product product) {
    return selectedProducts.contains(product);
  }

  void clearSelection() {
    selectedProducts.clear();
  }
}
