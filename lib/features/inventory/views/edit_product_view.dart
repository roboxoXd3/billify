import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/category_controller.dart';
import '../controllers/product_controller.dart';
import '../models/category_model.dart';
import '../models/product_model.dart';
import 'package:billify/Util/app_colors.dart';
import 'widgets/category_bottom_sheet.dart';

class EditProductView extends GetView<ProductController> {
  final Product product;
  final _formKey = GlobalKey<FormState>();

  EditProductView({super.key, required this.product});

  final _nameController = TextEditingController();
  final _categoryController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _costPriceController = TextEditingController();
  final _sellingPriceController = TextEditingController();
  final _currentStockController = TextEditingController();
  final _lowStockThresholdController = TextEditingController();
  final _unitController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Initialize controllers with existing product data
    _nameController.text = product.name;
    _categoryController.text = product.category;
    _descriptionController.text = product.description ?? '';
    _costPriceController.text = product.costPrice.toString();
    _sellingPriceController.text = product.sellingPrice.toString();
    _currentStockController.text = product.currentStock.toString();
    _lowStockThresholdController.text = product.lowStockThreshold.toString();
    _unitController.text = product.unit;

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
          "Edit Product",
          style: TextStyle(color: white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save_rounded, color: white),
            onPressed: _updateProduct,
          ),
          const SizedBox(width: 20),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField(
                controller: _nameController,
                label: 'Product Name',
                isRequired: true,
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () async {
                  Get.lazyPut(() => CategoryController());
                  final category = await Get.bottomSheet<Category>(
                    const CategoryBottomSheet(),
                    isScrollControlled: true,
                  );
                  if (category != null) {
                    _categoryController.text = category.name;
                  }
                  Get.delete<CategoryController>();
                },
                child: AbsorbPointer(
                  child: _buildTextField(
                    controller: _categoryController,
                    label: 'Category',
                    isRequired: true,
                    suffixIcon: const Icon(Icons.arrow_drop_down, color: white),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _descriptionController,
                label: 'Description',
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _costPriceController,
                      label: 'Cost Price',
                      isRequired: true,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      controller: _sellingPriceController,
                      label: 'Selling Price',
                      isRequired: true,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _currentStockController,
                      label: 'Current Stock',
                      isRequired: true,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      controller: _lowStockThresholdController,
                      label: 'Low Stock Alert',
                      isRequired: true,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _unitController,
                label: 'Unit (pcs, kg, etc.)',
                isRequired: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    bool isRequired = false,
    int maxLines = 1,
    TextInputType? keyboardType,
    Widget? suffixIcon,
  }) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(color: white),
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: isRequired ? '$label*' : label,
        labelStyle: TextStyle(color: white.withOpacity(0.7)),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: white.withOpacity(0.1)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: white.withOpacity(0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: white),
        ),
        suffixIcon: suffixIcon,
      ),
      validator: isRequired
          ? (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter $label';
              }
              return null;
            }
          : null,
    );
  }

  void _updateProduct() {
    if (_formKey.currentState!.validate()) {
      final updatedProduct = Product(
        id: product.id,
        name: _nameController.text,
        sku: product.sku, // Keep the original SKU
        category: _categoryController.text,
        description: _descriptionController.text,
        costPrice: double.parse(_costPriceController.text),
        sellingPrice: double.parse(_sellingPriceController.text),
        currentStock: int.parse(_currentStockController.text),
        lowStockThreshold: int.parse(_lowStockThresholdController.text),
        unit: _unitController.text,
        createdAt: product.createdAt, // Keep original creation date
        updatedAt: DateTime.now(),
      );

      controller.updateProduct(updatedProduct);
      Get.back();
      Get.snackbar(
        'Success',
        'Product updated successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    }
  }
}
