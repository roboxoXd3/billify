import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/category_controller.dart';
import '../controllers/product_controller.dart';
import '../models/category_model.dart';
import '../models/product_model.dart';
import 'package:billify/Util/app_colors.dart';
import 'package:billify/features/inventory/views/widgets/category_bottom_sheet.dart';

class AddProductView extends GetView<ProductController> {
  AddProductView({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _skuController = TextEditingController();
  final _categoryController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _costPriceController = TextEditingController();
  final _sellingPriceController = TextEditingController();
  final _currentStockController = TextEditingController();
  final _lowStockThresholdController = TextEditingController();
  final _unitController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
          "Add Product",
          style: TextStyle(color: white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save_rounded, color: white),
            onPressed: _saveProduct,
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
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Required';
                        if (double.tryParse(value) == null)
                          return 'Invalid number';
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      controller: _sellingPriceController,
                      label: 'Selling Price',
                      isRequired: true,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Required';
                        if (double.tryParse(value) == null)
                          return 'Invalid number';
                        return null;
                      },
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
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Required';
                        if (int.tryParse(value) == null)
                          return 'Invalid number';
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      controller: _lowStockThresholdController,
                      label: 'Low Stock Alert',
                      isRequired: true,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Required';
                        if (int.tryParse(value) == null)
                          return 'Invalid number';
                        return null;
                      },
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
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveProduct,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Save Product',
                    style: TextStyle(
                      color: bgColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
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
    String? Function(String?)? validator,
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
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red),
        ),
        suffixIcon: suffixIcon,
      ),
      validator: validator ??
          (isRequired
              ? (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter $label';
                  }
                  return null;
                }
              : null),
    );
  }

  String _generateSKU(String productName, String category) {
    final timestamp =
        DateTime.now().millisecondsSinceEpoch.toString().substring(8);

    final namePrefix = productName
        .replaceAll(RegExp(r'[^A-Za-z]'), '')
        .toUpperCase()
        .padRight(3)
        .substring(0, 3);

    final catPrefix = category
        .replaceAll(RegExp(r'[^A-Za-z]'), '')
        .toUpperCase()
        .padRight(2)
        .substring(0, 2);

    return '$namePrefix-$catPrefix-$timestamp';
  }

  void _saveProduct() {
    if (_formKey.currentState!.validate()) {
      final sku = _generateSKU(_nameController.text, _categoryController.text);

      final product = Product(
        name: _nameController.text,
        sku: sku,
        category: _categoryController.text,
        description: _descriptionController.text,
        costPrice: double.parse(_costPriceController.text),
        sellingPrice: double.parse(_sellingPriceController.text),
        currentStock: int.parse(_currentStockController.text),
        lowStockThreshold: int.parse(_lowStockThresholdController.text),
        unit: _unitController.text,
      );

      controller.addProduct(product);
      Get.back();
    }
  }
}
