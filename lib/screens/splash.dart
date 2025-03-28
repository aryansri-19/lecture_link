import 'package:flutter/material.dart';
import 'package:lecture_link/utils/colors.dart';

import 'layout_screen.dart';
import 'login.dart';

class SplashScreen extends StatefulWidget {
  final bool loggedIn;
  const SplashScreen({super.key, required this.loggedIn});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigatetohome();
  }

  _navigatetohome() async {
    await Future.delayed(const Duration(milliseconds: 2000), () {});
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder:
            (context) =>
                widget.loggedIn ? const LayoutScreen() : const LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mobileBackground,
      body: Center(
        child: SizedBox(
          height: 240,
          width: 240,
          child: Image.asset('assets/img/LLlogo.png'),
        ),
      ),
    );
  }
}
