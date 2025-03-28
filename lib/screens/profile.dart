import 'package:flutter/material.dart';
import 'package:lecture_link/screens/login.dart';
import '../server/auth_methods.dart';
import '../widgets/snack_bar.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isLoading = false;
  void logOut() async {
    setState(() {
      isLoading = true;
    });
    String res = await AuthMethods().signOut();
    if (res == 'Signed out successfully') {
      setState(() {
        isLoading = false;
      });
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const LoginScreen()));
    } else {
      showSnackBar(context, res);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator(
                color: Colors.blueAccent,
              )
            : TextButton(onPressed: logOut, child: const Text('Log Out')),
      ),
    );
  }
}
