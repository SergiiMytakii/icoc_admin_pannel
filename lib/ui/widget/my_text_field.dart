import 'package:flutter/material.dart';

class MyTexField extends StatelessWidget {
  const MyTexField({
    super.key,
    required this.controller,
    required this.hint,
    this.maxLength = 100000,
    this.maxLines = 1,
    this.readOnly = false,
    this.validator,
  });

  final TextEditingController controller;
  final String hint;
  final int maxLength;
  final bool readOnly;
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
