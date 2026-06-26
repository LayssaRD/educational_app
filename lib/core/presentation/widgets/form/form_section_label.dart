import 'package:flutter/material.dart';

class FormSectionLabel extends StatelessWidget {
  final String text;

  const FormSectionLabel({super.key, required this.text});

  static const _purpleDark = Color(0xFF3C3489);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: _purpleDark,
      ),
    );
  }
}
