import 'package:flutter/material.dart';

class FormSubmitButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const FormSubmitButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  static const _purple = Color(0xFF534AB7);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: _purple,
          foregroundColor: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
      ),
    );
  }
}
