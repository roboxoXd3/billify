import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/category_controller.dart';
import '../controllers/product_controller.dart';
import 'package:billify/Util/app_colors.dart';
import 'add_product_view.dart';
import 'edit_product_view.dart';

class ProductListView extends GetView<ProductController> {
  const ProductListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isSelecting = Get.arguments?['isSelecting'] ?? false;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          padding: EdgeInsets.zero,
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: white),
        ),
        title: const Text(
          "Inventory",
          style: TextStyle(color: white),
        ),
        actions: isSelecting
            ? [
                TextButton(
                  onPressed: () {
                    Get.back(result: controller.selectedProducts);
                  },
                  child: Text(
                    'Done',
                    style: TextStyle(
                      color: white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ]
            : null,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(20),
            child: TextField(
              style: const TextStyle(color: white),
              onChanged: controller.setSearchQuery,
              decoration: InputDecoration(
                hintText: 'Search by name or SKU',
                hintStyle: TextStyle(color: white.withOpacity(0.5)),
                prefixIcon: const Icon(Icons.search, color: white),
                filled: true,
                fillColor: Colors.white.withOpacity(0.1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: white.withOpacity(0.1)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: white),
                ),
              ),
            ),
          ),

          // Category Filter
          GetX<CategoryController>(
            init: CategoryController(),
            builder: (categoryController) {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: const Text('All'),
                        selected: controller.selectedCategory.isEmpty,
                        onSelected: (_) => controller.clearFilters(),
                        backgroundColor: white.withAlpha(51),
                        selectedColor: white,
                        labelStyle: TextStyle(
                          color: controller.selectedCategory.isEmpty
                              ? bgColor
                              : white,
                          fontWeight: FontWeight.w500,
                        ),
                        side: BorderSide(color: white.withOpacity(0.5)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    ...categoryController.categories.map((category) {
                      final isSelected =
                          controller.selectedCategory.value == category.name;
                      return Container(
                        margin: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(category.name),
                          selected: isSelected,
                          onSelected: (_) =>
                              controller.setSelectedCategory(category.name),
                          backgroundColor:
                              const Color(0xFF4A90E2).withAlpha(100),
                          selectedColor: white,
                          labelStyle: TextStyle(
                            color: isSelected ? bgColor : white,
                            fontWeight:
                                isSelected ? FontWeight.bold : FontWeight.w500,
                          ),
                          side: BorderSide(
                            color: isSelected ? white : const Color(0xFF4A90E2),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              );
            },
          ),

          // Product List
          Expanded(
            child: Obx(
              () => controller.isLoading.value
                  ? const Center(child: CircularProgressIndicator(color: white))
                  : controller.filteredProducts.isEmpty
                      ? Center(
                          child: Text(
                            'No products found',
                            style: TextStyle(
                              color: white.withOpacity(0.7),
                              fontSize: 16,
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: controller.filteredProducts.length,
                          padding: const EdgeInsets.all(20),
                          itemBuilder: (context, index) {
                            final product = controller.filteredProducts[index];
                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              decoration: BoxDecoration(
                                color: white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: white.withOpacity(0.1),
                                    blurRadius: 6,
                                  ),
                                ],
                              ),
                              child: ListTile(
                                onTap: isSelecting
                                    ? () {
                                        controller
                                            .toggleProductSelection(product);
                                      }
                                    : null,
                                leading: isSelecting
                                    ? Obx(() => Checkbox(
                                          value: controller
                                              .isProductSelected(product),
                                          onChanged: (_) => controller
                                              .toggleProductSelection(product),
                                          activeColor: white,
                                          checkColor: bgColor,
                                        ))
                                    : null,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                title: Text(
                                  product.name,
                                  style: const TextStyle(
                                    color: bgColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 4),
                                    Text(
                                      'SKU: ${product.sku}',
                                      style: const TextStyle(color: bgColor),
                                    ),
                                    Text(
                                      'Category: ${product.category}',
                                      style: const TextStyle(color: bgColor),
                                    ),
                                  ],
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          '₹${product.sellingPrice}',
                                          style: const TextStyle(
                                            color: bgColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text(
                                          'Stock: ${product.currentStock}',
                                          style: TextStyle(
                                            color: product.currentStock <=
                                                    product.lowStockThreshold
                                                ? Colors.red
                                                : Colors.green,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    PopupMenuButton(
                                      icon: const Icon(Icons.more_vert,
                                          color: bgColor),
                                      itemBuilder: (context) => [
                                        PopupMenuItem(
                                          child: const Text('Edit'),
                                          onTap: () {
                                            // Add slight delay to avoid animation issues
                                            Future.delayed(
                                              const Duration(milliseconds: 50),
                                              () => Get.to(() =>
                                                  EditProductView(
                                                      product: product)),
                                            );
                                          },
                                        ),
                                        PopupMenuItem(
                                          child: const Text('Delete'),
                                          onTap: () {
                                            // Add delete confirmation dialog
                                            Future.delayed(
                                              const Duration(milliseconds: 50),
                                              () => Get.dialog(
                                                AlertDialog(
                                                  title: const Text(
                                                      'Delete Product'),
                                                  content: const Text(
                                                      'Are you sure you want to delete this product?'),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () =>
                                                          Get.back(),
                                                      child:
                                                          const Text('Cancel'),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        controller
                                                            .deleteProduct(
                                                                product.id!);
                                                        Get.back();
                                                      },
                                                      child: const Text(
                                                          'Delete',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.red)),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: white,
        onPressed: () => Get.to(() => AddProductView()),
        child: const Icon(Icons.add, color: bgColor),
      ),
    );
  }
}
