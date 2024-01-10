import 'package:flutter/material.dart';

Widget topic(
    String topic, Color color1, Color color2, IconData icon, double textwidth) {
  return Container(
    width: 144,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [color1, color2],
      ),
    ),
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon),
          const SizedBox(
            width: 10,
          ),
          Text(
            topic,
            style: TextStyle(fontSize: textwidth, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    ),
  );
}
