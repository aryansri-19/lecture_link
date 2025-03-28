import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lecture_link/screens/splash.dart';
import 'package:lecture_link/utils/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var loggedIn = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void checkLogin() async {
    _auth.userChanges().listen((User? user) {
      if (user != null) {
        setState(() {
          loggedIn = true;
        });
      }
    });
  }

  @override
  void initState() {
    checkLogin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lecture Link',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: mobileBackground,
        primaryColor: primaryColor,
      ),
      home: SplashScreen(loggedIn: loggedIn),
    );
  }
}
