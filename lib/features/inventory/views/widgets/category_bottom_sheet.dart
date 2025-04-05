import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/category_controller.dart';
import '../../models/category_model.dart';
import 'package:billify/Util/app_colors.dart';

class CategoryBottomSheet extends GetView<CategoryController> {
  const CategoryBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight:
            MediaQuery.of(context).size.height * 0.7, // 70% of screen height
      ),
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Select Category',
                style: TextStyle(
                  color: white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle_outline, color: white),
                onPressed: () => _showAddCategoryDialog(context),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            // Wrap ListView with Expanded
            child: Obx(
              () => controller.isLoading.value
                  ? const Center(child: CircularProgressIndicator(color: white))
                  : controller.categories.isEmpty
                      ? const Center(
                          child: Text(
                            'No categories found',
                            style: TextStyle(color: white),
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: controller.categories.length,
                          itemBuilder: (context, index) {
                            final category = controller.categories[index];
                            return ListTile(
                              title: Text(
                                category.name,
                                style: const TextStyle(color: white),
                              ),
                              onTap: () => Get.back(result: category),
                            );
                          },
                        ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddCategoryDialog(BuildContext context) {
    final nameController = TextEditingController();
    final descController = TextEditingController();

    Get.dialog(
      Dialog(
        backgroundColor: bgColor,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                style: const TextStyle(color: white),
                decoration: const InputDecoration(
                  labelText: 'Category Name',
                  labelStyle: TextStyle(color: white),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: white),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descController,
                style: const TextStyle(color: white),
                decoration: const InputDecoration(
                  labelText: 'Description (Optional)',
                  labelStyle: TextStyle(color: white),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: white),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (nameController.text.isNotEmpty) {
                    controller.addCategory(
                      Category(
                        name: nameController.text,
                        description: descController.text,
                      ),
                    );
                    Get.back();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: white,
                ),
                child: const Text(
                  'Add Category',
                  style: TextStyle(color: bgColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
