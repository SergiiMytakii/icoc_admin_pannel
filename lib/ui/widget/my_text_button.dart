import 'package:flutter/material.dart';

class MyTextButton extends StatelessWidget {
  final String label;
  final Function onPressed;
  const MyTextButton({super.key, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => onPressed(),
      child: Text(
        label,
        style: const TextStyle(fontSize: 20),
      ),
    );
  }
}
