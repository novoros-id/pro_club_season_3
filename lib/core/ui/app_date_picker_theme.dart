import 'package:flutter/material.dart';

const Color _dark = Color(0xFF121A1F);
const Color _accent = Color(0xFFBBF246);
const Color _fieldBackground = Color(0xFFF2F2F7);
const Color _border = Color(0xFFD8DADF);
const Color _secondaryText = Color(0xFF9B9EA1);

Widget appDatePickerBuilder(BuildContext context, Widget? child) {
  return Theme(
    data: Theme.of(context).copyWith(
      colorScheme: const ColorScheme.light(
        primary: _accent,
        onPrimary: _dark,
        surface: Colors.white,
        onSurface: _dark,
      ),
      datePickerTheme: DatePickerThemeData(
        backgroundColor: Colors.white,
        headerBackgroundColor: Colors.white,
        headerForegroundColor: _dark,
        todayForegroundColor: const WidgetStatePropertyAll<Color>(_dark),
        todayBackgroundColor: const WidgetStatePropertyAll<Color>(
          Color(0x33BBF246),
        ),
        todayBorder: BorderSide.none,
        headerHeadlineStyle: const TextStyle(
          fontFamily: 'Unbounded',
          fontSize: 18,
          height: 1.2,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.4,
        ),
        cancelButtonStyle: const ButtonStyle(
          minimumSize: WidgetStatePropertyAll<Size>(Size(0, 38)),
          padding: WidgetStatePropertyAll<EdgeInsetsGeometry>(
            EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          backgroundColor: WidgetStatePropertyAll<Color>(Colors.transparent),
          foregroundColor: WidgetStatePropertyAll<Color>(_secondaryText),
          overlayColor: WidgetStatePropertyAll<Color>(Color(0x0D121A1F)),
          textStyle: WidgetStatePropertyAll<TextStyle>(
            TextStyle(
              fontFamily: 'Unbounded',
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        confirmButtonStyle: ButtonStyle(
          minimumSize: const WidgetStatePropertyAll<Size>(Size(0, 38)),
          padding: const WidgetStatePropertyAll<EdgeInsetsGeometry>(
            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
          shape: const WidgetStatePropertyAll<OutlinedBorder>(StadiumBorder()),
          elevation: const WidgetStatePropertyAll<double>(0),
          overlayColor: const WidgetStatePropertyAll<Color>(_accent),
          textStyle: const WidgetStatePropertyAll<TextStyle>(
            TextStyle(
              fontFamily: 'Unbounded',
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
          backgroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
            if (states.contains(WidgetState.disabled)) {
              return const Color(0xFFE3E4E8);
            }

            if (states.contains(WidgetState.pressed) ||
                states.contains(WidgetState.focused)) {
              return _accent;
            }

            return _dark;
          }),
          foregroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
            if (states.contains(WidgetState.disabled)) {
              return _secondaryText;
            }

            if (states.contains(WidgetState.pressed) ||
                states.contains(WidgetState.focused)) {
              return _dark;
            }

            return Colors.white;
          }),
        ),
      ),
      inputDecorationTheme: InputDecorationThemeData(
        isDense: true,
        filled: true,
        fillColor: _fieldBackground,
        constraints: const BoxConstraints(minHeight: 56),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 13,
        ),
        labelStyle: const TextStyle(
          fontFamily: 'Lato',
          fontSize: 14,
          color: _secondaryText,
        ),
        floatingLabelStyle: const TextStyle(
          fontFamily: 'Lato',
          fontSize: 14,
          color: _secondaryText,
        ),
        hintStyle: const TextStyle(
          fontFamily: 'Lato',
          fontSize: 16,
          color: _secondaryText,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: _border, width: 1.4),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: _border, width: 1.4),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: _accent, width: 2),
        ),
      ),
      textTheme: const TextTheme(
        headlineSmall: TextStyle(
          fontFamily: 'Unbounded',
          fontWeight: FontWeight.bold,
          color: _dark,
        ),
        bodyLarge: TextStyle(fontFamily: 'Lato', color: _dark),
        labelLarge: TextStyle(
          fontFamily: 'Unbounded',
          fontWeight: FontWeight.bold,
          color: _dark,
        ),
      ),
      dialogTheme: const DialogThemeData(backgroundColor: Colors.white),
    ),
    child: child!,
  );
}
