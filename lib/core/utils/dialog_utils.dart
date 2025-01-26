import 'package:flutter/material.dart';

class DialogUtils {
  static Widget createErrorDialog(String message) {
    return AlertDialog(
      title: const Text('Error'),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(navigatorKey.currentContext!),
          child: const Text('OK'),
        ),
      ],
    );
  }

  static final navigatorKey = GlobalKey<NavigatorState>();

  static void showErrorDialog(String message) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: navigatorKey.currentContext!,
        builder: (context) => createErrorDialog(message),
      );
    });
  }
}
