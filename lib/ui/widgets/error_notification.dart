import 'package:flutter/material.dart';
import 'package:q_overlay/q_overlay.dart';

import '../../helpers/extensions/context_extensions.dart';

class _Notification extends StatelessWidget {
  final String title;
  final String message;
  final NotificationType type;
  const _Notification(this.title, this.message, this.type, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: type == NotificationType.error
            ? context.theme.colorScheme.error
            : Colors.green.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          Text(message, style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }
}

void showNotification(
  String title,
  String message, {
  NotificationType type = NotificationType.error,
}) {
  QNotification(
    child: _Notification(title, message, type),
    backgroundDecoration: BoxDecoration(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(5),
    ),
  ).show();
}

enum NotificationType {
  error,
  success,
}
