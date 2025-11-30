import 'package:flutter/material.dart';

class SendNotificationCheckBox extends StatelessWidget {
  final Function(bool) onChanged;

  final ValueNotifier<bool> sendNotificationNotifier =
      ValueNotifier<bool>(false);

  SendNotificationCheckBox({
    super.key,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 50),
        ValueListenableBuilder<bool>(
          valueListenable: sendNotificationNotifier,
          builder: (context, value, child) {
            return Checkbox(
              value: value,
              onChanged: (newValue) {
                sendNotificationNotifier.value = newValue!;
                onChanged(newValue);
              },
            );
          },
        ),
        const Text('Send notifications.'),
        const SizedBox(width: 5),
        const Tooltip(
          message: 'Notify users about new song',
          child: Icon(Icons.help_outline, size: 16),
        ),
      ],
    );
  }
}
