// ignore_for_file: must_be_immutable

import 'package:billify/Util/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum DefaultTextFieldType { defaultText }

class DefaultTextField extends StatelessWidget {
  const DefaultTextField({
    super.key,
    this.formFieldKey,
    this.initialValue,
    required this.hint,
    this.prefixIcon,
    this.prefixIconData,
    this.prefixAction,
    this.suffixIcon,
    this.suffixIconData,
    this.suffixIconColor,
    this.suffixAction,
    this.suffixIconSize = 20,
    this.onChange,
    this.validator,
    this.selectedDate,
    this.selectedTime,
    this.filled = true,
    this.fillColor,
    this.readOnly = false,
    this.isDense = true,
    this.onTap,
    this.onFieldSubmitClick,
    this.controller,
    this.focusNode,
    this.keyboardType,
    this.textInputAction,
    this.type = DefaultTextFieldType.defaultText,
    this.prefix,
    this.suffix,
    this.prefixIconConstraints,
    this.onDateSelection,
    this.onTimeSelection,
    this.maxLines = 1,
    this.minLines = 1,
    this.obscureText = false,
    this.inputFormatters,
    this.showClearButton = false,
    this.onClear,
    this.pickerFirstDate,
    this.pickerLastDate,
    this.initialDate,
    this.style,
    this.textAlign,
    this.onEditingComplete,
    this.contentPadding,
    this.scrollPadding = const EdgeInsets.all(20),
    this.textCapitalization,
    this.autoValidaMode
  });

  final GlobalKey<FormFieldState>? formFieldKey;
  final String? initialValue;
  final String hint;
  final IconData? prefixIconData;
  final Widget? prefixIcon;
  final IconData? suffixIconData;
  final Color? suffixIconColor;
  final Widget? suffixIcon;
  final Function()? prefixAction;
  final Function()? suffixAction;
  final double suffixIconSize;
  final Function(String)? onChange;
  final String? Function(String?)? validator;
  final bool filled;
  final DateTime? selectedDate;
  final TimeOfDay? selectedTime;
  final Color? fillColor;
  final bool readOnly;
  final bool isDense;
  final Function()? onTap;
  final Function(String)? onFieldSubmitClick;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final DefaultTextFieldType type;
  final BoxConstraints? prefixIconConstraints;
  final Widget? prefix;
  final Widget? suffix;
  final Function(DateTime)? onDateSelection;
  final Function(TimeOfDay)? onTimeSelection;
  final int? maxLines;
  final int? minLines;
  final bool obscureText;
  final List<TextInputFormatter>? inputFormatters;
  final bool showClearButton;
  final Function()? onClear;
  final DateTime? pickerFirstDate;
  final DateTime? pickerLastDate;
  final DateTime? initialDate;
  final TextStyle? style;
  final TextAlign? textAlign;
  final Function()? onEditingComplete;
  final EdgeInsets? contentPadding;
  final EdgeInsets scrollPadding;
  final TextCapitalization? textCapitalization;
  final AutovalidateMode? autoValidaMode;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: formFieldKey,
      scrollPadding: scrollPadding,
      onEditingComplete: onEditingComplete,
      autovalidateMode: autoValidaMode ?? AutovalidateMode.onUserInteraction,
      initialValue: initialValue,
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboardType,
      textCapitalization: textCapitalization ?? TextCapitalization.sentences,
      textInputAction: textInputAction,
      onChanged: onChange,
      onFieldSubmitted: onFieldSubmitClick,
      validator: validator,
      readOnly: type == DefaultTextFieldType.defaultText ? readOnly : true,
      obscureText: obscureText,
      inputFormatters: inputFormatters ?? [AllowSpaceAfterTextFormatter()],
      textAlign: textAlign ?? TextAlign.start,
      onTap: type == DefaultTextFieldType.defaultText
          ? onTap
          : () async {
              
            },
      maxLines: maxLines,
      minLines: minLines,
      style: style ?? const TextStyle(color: Colors.black),
      textAlignVertical: TextAlignVertical.center,
      decoration: InputDecoration(
        filled: filled,
        fillColor: fillColor ?? Colors.white,
        contentPadding: contentPadding,
        isDense: isDense,
        errorMaxLines: 2,
        hintText: hint,
      
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(
            width: 1.0,
            color: borderLineColor,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(
            width: 1.0,
            color: borderLineColor,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(
            width: 1.0,
            color: Colors.red,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(
            width: 1.0,
            color: borderLineColor,
          ),
        ),
        hintStyle: const TextStyle(color: secondaryTextColor,fontSize: 14,fontWeight: FontWeight.w400),
        prefixIconConstraints: prefixIconConstraints,
        prefix: prefix,
        prefixIcon: prefixIcon ?? (prefixIconData != null
            ? IconButton(
                onPressed: prefixAction,
                icon: Icon(
                  prefixIconData,
                  size: 20,
                  color: Theme.of(context)
                      .inputDecorationTheme
                      .prefixStyle
                      ?.color,
                ),
              )
            : null),
        suffix: suffix,
        suffixIcon: showClearButton
            ? GestureDetector(
                onTap: () {
                  controller?.clear();
                  if (onClear != null) onClear!();
                },
                child: const Icon(
                  Icons.clear,
                  size: 20,
                ),
              )
            : suffixIcon ?? (suffixIconData != null
                ? IconButton(
                    onPressed: suffixAction,
                    icon: Icon(
                      suffixIconData!,
                      size: suffixIconSize,
                      color: suffixIconColor ??
                          Theme.of(context)
                              .inputDecorationTheme
                              .prefixStyle
                              ?.color,
                    ),
                  )
                : null),
      ),
    );
  }
}

class AllowSpaceAfterTextFormatter extends TextInputFormatter {
  final RegExp _emojiRegExp = RegExp(
    r'[\u{1F600}-\u{1F64F}\u{1F300}-\u{1F5FF}\u{1F680}-\u{1F6FF}\u{1F700}-\u{1F77F}\u{1F780}-\u{1F7FF}\u{1F800}-\u{1F8FF}\u{1F900}-\u{1F9FF}\u{1FA00}-\u{1FA6F}\u{1FA70}-\u{1FAFF}\u{2600}-\u{26FF}\u{2700}-\u{27BF}\u{2300}-\u{23FF}\u{2B50}\u{1F004}\u{1F0CF}\u{2B06}\u{2194}\u{21A9}\u{21AA}\u{2934}\u{2935}\u{25AA}\u{25AB}\u{25FE}\u{25FD}\u{2B06}\u{2194}\u{2934}\u{2935}]',
    unicode: true,
    caseSensitive: false,
  );

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (_emojiRegExp.hasMatch(newValue.text)) {
      return oldValue; // Disallow the input
    }

    if (newValue.text.isEmpty ||
        !newValue.text.startsWith(' ') ||
        newValue.text.trim().isNotEmpty) {
      return newValue;
    }

    return oldValue;
  }
}
