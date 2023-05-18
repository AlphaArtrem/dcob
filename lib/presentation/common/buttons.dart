import 'package:flutter/material.dart';

Widget primaryButton(
    {required VoidCallback onTap,
    required String text,
    bool isFilled = true,
    double fontSize = 18.0}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.cyan),
        borderRadius: BorderRadius.circular(12.0),
        color: isFilled ? Colors.cyan : Colors.transparent,
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: isFilled ? Colors.white : Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: fontSize,
        ),
      ),
    ),
  );
}
