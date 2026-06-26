import 'package:flutter/material.dart';

class FormHeaderIcon extends StatelessWidget {
  final IconData icon;

  const FormHeaderIcon({super.key, required this.icon});

  static const _purple = Color(0xFF534AB7);
  static const _purpleLight = Color(0xFFEEEDFE);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 72,
        height: 72,
        decoration: BoxDecoration(color: _purpleLight, shape: BoxShape.circle),
        child: Icon(icon, color: _purple, size: 32),
      ),
    );
  }
}
