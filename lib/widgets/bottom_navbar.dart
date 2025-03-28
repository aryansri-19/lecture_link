import 'package:flutter/material.dart';

import '../utils/colors.dart';

BottomNavigationBarItem bottomNavItem(
    IconData icon, Color color, String label) {
  return BottomNavigationBarItem(
    icon: Icon(
      icon,
      color: color,
      size: 28,
    ),
    label: '',
    backgroundColor: primaryColor,
  );
}
