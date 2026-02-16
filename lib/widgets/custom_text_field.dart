import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String labelText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final bool obscureText;
  final TextInputType keyboardType;
  final int? maxLength;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final bool readOnly;
  final int? maxLines;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.labelText,
    this.prefixIcon,   
    this.suffixIcon, 
    this.obscureText = false,
    this.readOnly = false, // default is editable
    this.keyboardType = TextInputType.text,
    this.maxLength,
    this.validator,
    this.onChanged,
    this.onTap,
    this.maxLines=1,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      readOnly: readOnly,
      keyboardType: keyboardType,
      validator: validator,
      maxLines: maxLines,
      maxLength: maxLength,
      onChanged: onChanged,
      onTap: onTap,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
        suffixIcon: suffixIcon != null ? Icon(suffixIcon) : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: const Color.fromRGBO(29, 78, 216, 1)),
        ),
      //   errorBorder: OutlineInputBorder(
      //     borderSide: BorderSide(color: Colors.red), // 👈 Error border color
      //   ),
      //   focusedErrorBorder: OutlineInputBorder(
      //     borderSide: BorderSide(color: Colors.orange), // 👈 Focused error color
      //  ),
      ),
    );
  }
}

