import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

Future<bool> showAlertDialog(BuildContext context, String message,
    {bool showCancelButton = false}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        alignment: Alignment.center,
        content: Text(message),
        actions: <Widget>[
          if (showCancelButton)
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                context.pop(false);
              },
            ),
          TextButton(
            child: const Text('Ok'),
            onPressed: () {
              context.pop(true);
            },
          ),
        ],
      );
    },
  );
  return result ?? false;
}
