import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyTexField extends StatelessWidget {
  const MyTexField({
    super.key,
    required this.controller,
    required this.hint,
    this.maxLength = 100000,
    this.maxLines = 1,
    this.readOnly = false,
    this.obscureText = false,
    this.validator,
  });

  final TextEditingController controller;
  final String hint;
  final int maxLength;
  final bool readOnly;
  final bool obscureText;
  final int maxLines;
  final FormFieldValidator<String>? validator;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        readOnly: readOnly,
        maxLength: maxLength,
        maxLines: maxLines,
        validator: validator,
        obscureText: obscureText,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.grey, width: 0.3),
          ),
          helperText: hint,
        ),
      ),
    );
  }
}
