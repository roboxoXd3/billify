import 'package:flutter/material.dart';

class DefaultDropdownField<T> extends StatelessWidget {
  const DefaultDropdownField({
    super.key,
    required this.items,
    required this.hint,
    this.value,
    this.onChanged,
    this.validator,
    this.fillColor = Colors.white,
    this.filled = true,
    this.isDense = true,
    this.contentPadding,
    this.style,
    this.borderRadius = 8.0,
    this.itemBuilder,
    this.selectedBuilder,
  });

  final List<T> items;
  final T? value;
  final String hint;
  final Function(T?)? onChanged;
  final String? Function(T?)? validator;
  final bool filled;
  final Color? fillColor;
  final bool isDense;
  final EdgeInsets? contentPadding;
  final TextStyle? style;
  final double borderRadius;
  final Widget Function(BuildContext, T)? itemBuilder;
  final Widget Function(BuildContext, T?)? selectedBuilder;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: value,
      decoration: InputDecoration(
        filled: filled,
        fillColor: fillColor,
        contentPadding: contentPadding ?? const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        isDense: isDense,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: const BorderSide(
            width: 1.0,
            color: Colors.grey,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: const BorderSide(
            width: 1.0,
            color: Colors.grey,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: const BorderSide(
            width: 1.0,
            color: Colors.blue,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: const BorderSide(
            width: 1.0,
            color: Colors.red,
          ),
        ),
      ),
      style: style ?? const TextStyle(color: Colors.black, fontSize: 16), // Dropdown text color
      dropdownColor: Colors.white, // Dropdown background color
      validator: validator,
      onChanged: onChanged,
      items: items
          .map(
            (item) => DropdownMenuItem<T>(
              value: item,
              child: itemBuilder != null
                  ? itemBuilder!(context, item)
                  : Text(
                      item.toString(),
                      style: const TextStyle(
                        color: Colors.black, // Dropdown item text color
                        fontSize: 16,
                      ),
                    ),
            ),
          )
          .toList(),
      hint: Align(
        alignment: Alignment.center,
        child: Text(
          hint,
          style: const TextStyle(
            color: Colors.grey, // Hint text color
            fontSize: 16,
          ),
        ),
      ),
      selectedItemBuilder: selectedBuilder != null
          ? (context) => items
              .map((item) => selectedBuilder!(context, item))
              .toList()
          : null,
    );
  }
}
