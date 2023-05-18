import 'package:dcob/main.dart';
import 'package:dcob/presentation/common/buttons.dart';
import 'package:flutter/material.dart';

void showDialogue({required String title, required String text}) {
  showDialog(
    context: navigationKey.currentContext!,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(
          text,
          textAlign: TextAlign.justify,
        ),
        actions: [
          primaryButton(
            text: 'Close',
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}