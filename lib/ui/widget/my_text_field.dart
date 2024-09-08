import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  const MyTextField(
      {super.key,
      required this.controller,
      required this.hint,
      this.maxLength = 300000,
      this.maxLines = 1,
      this.readOnly = false,
      this.obscureText = false,
      this.validator,
      this.onFieldSubmitted});

  final TextEditingController controller;
  final String hint;
  final int maxLength;
  final bool readOnly;
  final bool obscureText;
  final Function? onFieldSubmitted;
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
        onFieldSubmitted:
            onFieldSubmitted != null ? (value) => onFieldSubmitted!() : null,
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
