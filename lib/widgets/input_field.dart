import 'package:flutter/material.dart';
import 'package:lecture_link/utils/colors.dart';

TextField inputField(String text, IconData icon, bool isPass,
    TextEditingController controller, bool isLoading) {
  // bool visibility = false;
  return TextField(
    enabled: !isLoading,
    controller: controller,
    obscureText: isPass,
    enableSuggestions: !isPass,
    autocorrect: !isPass,
    cursorColor: Colors.white,
    style: TextStyle(color: textColor),
    decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.grey),
        // suffixIcon: isPass
        //     ? IconButton(
        //         icon: Icon(
        //           visibility ? Icons.visibility : Icons.visibility_off,
        //         ),
        //         onPressed: () {
        //           visibility = !visibility;
        //         })
        //     : null,
        // labelText: text,
        // labelStyle: const TextStyle(color: textColor),
        hintText: text,
        filled: true,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        fillColor: Colors.white.withValues(),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(width: 0, style: BorderStyle.none))),
    keyboardType:
        isPass ? TextInputType.visiblePassword : TextInputType.emailAddress,
  );
}
