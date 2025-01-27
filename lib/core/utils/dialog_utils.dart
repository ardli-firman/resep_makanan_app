import 'package:flutter/material.dart';

class DialogUtils {
  static Widget createDialog(String message,
      {bool isError = false, Function()? onPress}) {
    onPress ??= () {
      Navigator.pop(navigatorKey.currentContext!);
    };

    return AlertDialog(
      title: Text(isError ? 'Error' : 'Berhasil'),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: onPress,
          child: const Text('Tutup'),
        ),
      ],
    );
  }

  static final navigatorKey = GlobalKey<NavigatorState>();

  static void showErrorDialog(String message) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: navigatorKey.currentContext!,
        builder: (context) => createDialog(message, isError: true),
      );
    });
  }

  static void showInfoDialog(String message, {Function()? onPress}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: navigatorKey.currentContext!,
        builder: (context) => createDialog(message, onPress: onPress),
      );
    });
  }
}
