import 'package:flutter/material.dart';

abstract final class DailyTasksStyles {
  static const dark = Color(0xFF121212);
  static const accent = Color(0xFFBBF246);
  static const fieldBackground = Color(0xFFF2F2F7);
  static const secondaryText = Color(0xFF9B9EA1);

  static const screenTitle = TextStyle(
    fontFamily: 'Unbounded',
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: dark,
  );

  static const body = TextStyle(fontFamily: 'Lato', fontSize: 16, color: dark);

  static const helper = TextStyle(
    fontFamily: 'Lato',
    fontSize: 14,
    color: secondaryText,
  );

  static final inputDecoration = InputDecoration(
    filled: true,
    fillColor: fieldBackground,
    labelStyle: body,
    floatingLabelStyle: body,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: const BorderSide(color: accent, width: 1.5),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: const BorderSide(color: dark, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: const BorderSide(color: Colors.redAccent, width: 2),
    ),
  );

  static final primaryButton = FilledButton.styleFrom(
    backgroundColor: dark,
    foregroundColor: Colors.white,
    minimumSize: const Size.fromHeight(52),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    textStyle: const TextStyle(
      fontFamily: 'Unbounded',
      fontSize: 13,
      fontWeight: FontWeight.bold,
    ),
  );
}
