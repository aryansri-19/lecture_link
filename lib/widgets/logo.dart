import 'package:flutter/material.dart';

Image logoWidget(String path) {
  return Image.asset(
    path,
    fit: BoxFit.fitWidth,
    width: 240,
    height: 170,
  );
}
