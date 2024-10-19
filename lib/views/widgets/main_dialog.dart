import 'package:flutter/material.dart';

class MainDialog {
  final BuildContext context;
  final String title;
  final String content;
  final List<Map<String, VoidCallback>>? actions;

  MainDialog({
    required this.context,
    required this.title,
    required this.content,
    this.actions,
  });

  void showAlertDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        content: Text(
          content,
          style: Theme.of(context).textTheme.labelMedium,
        ),
        actions: actions?.map((action) {
          return TextButton(
            onPressed: () {
              action.values.first();
              Navigator.of(context).pop();
            },
            child: Text(action.keys.first),
          );
        }).toList() ??
            [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
      ),
    );
  }
}
