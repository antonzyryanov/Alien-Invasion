import 'package:flutter/material.dart';

class MenuActionItem {
  const MenuActionItem({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;
}
