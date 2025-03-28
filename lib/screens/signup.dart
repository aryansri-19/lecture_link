import 'package:flutter/material.dart';
import 'package:lecture_link/screens/layout_screen.dart';
import 'package:lecture_link/server/auth_methods.dart';
import 'package:lecture_link/widgets/button.dart';
import 'package:lecture_link/widgets/input_field.dart';
import '../widgets/logo.dart';
import '../widgets/snack_bar.dart';
import 'login.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
  }

  void signIn() async {
    setState(() {
      isLoading = true;
    });
    String res = await AuthMethods().signUpUser(
      email: _emailController.text,
      password: _passwordController.text,
      username: _usernameController.text,
    );
    if (res == 'Success') {
      setState(() {
        isLoading = false;
      });
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LayoutScreen()),
        );
      }
    } else {
      showSnackBar(context, res);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            screenWidth * 0.1,
            screenHeight * 0.2,
            screenWidth * 0.1,
            0,
          ),
          child: Column(
            children: <Widget>[
              logoWidget("assets/img/LLlogo.png"),
              const Text(
                'Lecture Link',
                style: TextStyle(fontFamily: 'OoohBaby', fontSize: 30),
              ),
              SizedBox(height: screenHeight * 0.03),
              inputField(
                'What Shall We Call You?',
                Icons.person_outline,
                false,
                _usernameController,
                isLoading,
              ),
              SizedBox(height: screenHeight * 0.03),
              inputField(
                'Domain Email',
                Icons.email_outlined,
                false,
                _emailController,
                isLoading,
              ),
              SizedBox(height: screenHeight * 0.03),
              inputField(
                'Keep A Secret Code',
                Icons.lock_outline,
                true,
                _passwordController,
                isLoading,
              ),
              SizedBox(height: screenHeight * 0.03),
              isLoading
                  ? Container(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: const CircularProgressIndicator(color: Colors.blue),
                  )
                  : inputButton(context, false, signIn),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'Already registered, huh? ',
                    style: TextStyle(fontSize: 12),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      'Log in',
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
    );
  }
}
