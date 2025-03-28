import 'package:flutter/material.dart';
import 'package:lecture_link/screens/layout_screen.dart';
import 'package:lecture_link/screens/signup.dart';
import 'package:lecture_link/widgets/input_field.dart';
import 'package:lecture_link/widgets/logo.dart';
import 'package:lecture_link/widgets/snack_bar.dart';

import '../server/auth_methods.dart';
import '../widgets/button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void login() async {
    setState(() {
      isLoading = true;
    });
    String res = await AuthMethods().loginUser(
      email: _emailController.text,
      password: _passwordController.text,
    );
    if (res == 'Success') {
      setState(() {
        isLoading = false;
      });
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LayoutScreen()),
      );
    } else {
      showSnackBar(context, res);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              screenWidth * 0.1,
              screenHeight * 0.2,
              screenWidth * 0.1,
              0,
            ),
            child: Column(
              children: [
                logoWidget('assets/img/LLlogo.png'),
                const Text(
                  'Lecture Link',
                  style: TextStyle(fontFamily: 'OoohBaby', fontSize: 30),
                ),
                SizedBox(height: screenHeight * 0.03),
                inputField(
                  'Domain Email',
                  Icons.email,
                  false,
                  _emailController,
                  isLoading,
                ),
                SizedBox(height: screenHeight * 0.03),
                inputField(
                  'Knock-Knock, Password Please',
                  Icons.lock,
                  true,
                  _passwordController,
                  isLoading,
                ),
                SizedBox(height: screenHeight * 0.03),
                isLoading
                    ? Container(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: const CircularProgressIndicator(
                        color: Colors.blue,
                      ),
                    )
                    : inputButton(context, true, login),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text('New here? ', style: TextStyle(fontSize: 12)),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignupScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
