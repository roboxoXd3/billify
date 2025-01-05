import 'package:get/get.dart';
import '../models/category_model.dart';
import '../services/database_helper.dart';

class CategoryController extends GetxController {
  final RxList<Category> categories = <Category>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadCategories();
  }

  Future<void> loadCategories() async {
    isLoading.value = true;
    try {
      final categoryList = await DatabaseHelper.instance.getAllCategories();
      categories.assignAll(categoryList);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addCategory(Category category) async {
    await DatabaseHelper.instance.insertCategory(category);
    await loadCategories();
  }
}
