import 'package:flutter/material.dart';
// import 'package:lecture_link/utils/colors.dart';

Container inputButton(BuildContext context, bool isLogin, Function onTap) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 50,
    margin: const EdgeInsets.only(bottom: 20),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
    child: ElevatedButton(
      onPressed: () {
        onTap();
      },
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.pressed)) {
              return Colors.black26;
            } else {
              return Colors.white;
            }
          }),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)))),
      child: Text(
        isLogin ? 'Get In The Zone' : 'Join The Journey',
        style: const TextStyle(
            color: Colors.blueGrey, fontWeight: FontWeight.bold, fontSize: 16),
      ),
    ),
  );
}
