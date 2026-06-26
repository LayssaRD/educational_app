import 'package:flutter/material.dart';

class FormCardSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const FormCardSection({
    super.key,
    required this.title,
    required this.children,
  });

  static const _purpleDark = Color(0xFF3C3489);
  static const _purpleBorder = Color(0xFFAFA9EC);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _purpleBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: _purpleDark,
            ),
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }
}
