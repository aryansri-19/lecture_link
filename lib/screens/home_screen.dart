import 'package:flutter/material.dart';
import 'package:lecture_link/screens/chat.dart';

import '../utils/colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: screenHeight * 0.068,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [bannerBackground, bannerBackground2],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        leadingWidth: screenWidth * 0.2,
        centerTitle: true,
        leading: const Image(image: AssetImage('assets/img/LLlogo.png')),
        title: const Text(
          'Lecture Link',
          style: TextStyle(fontFamily: 'OoohBaby', fontSize: 28),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (context) => const Chat()));
            },
            icon: const Icon(Icons.message),
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.03,
              vertical: screenHeight * 0.01,
            ),
          ),
        ],
      ),
    );
  }
}
