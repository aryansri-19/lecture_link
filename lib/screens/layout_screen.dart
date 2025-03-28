import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lecture_link/utils/colors.dart';
import 'package:lecture_link/widgets/bottom_navbar.dart';

import '../utils/items.dart';

class LayoutScreen extends StatefulWidget {
  const LayoutScreen({super.key});

  @override
  State<LayoutScreen> createState() => _LayoutScreenState();
}

class _LayoutScreenState extends State<LayoutScreen>
    with WidgetsBindingObserver {
  int _page = 0;
  late PageController pageController;
  late final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final FirebaseAuth _auth = FirebaseAuth.instance;

  void setStatus(String status) async {
    await _firestore.collection('users').doc(_auth.currentUser!.uid).update({
      "status": status,
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setStatus("Online");
    } else {
      setStatus("Offline");
    }
  }

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    WidgetsBinding.instance.addObserver(this);
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  void tappedNavigation(int page) {
    pageController.jumpToPage(page);
  }

  @override
  Widget build(BuildContext context) {
    // final screenWidth = MediaQuery.of(context).size.width;
    // final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        onPageChanged: onPageChanged,
        children: items,
      ),
      bottomNavigationBar: CupertinoTabBar(
        backgroundColor: mobileBackground,
        items: [
          bottomNavItem(Icons.home, _page == 0 ? textColor : primaryColor, ''),
          bottomNavItem(
            Icons.search,
            _page == 1 ? textColor : primaryColor,
            '',
          ),
          bottomNavItem(Icons.add, _page == 2 ? textColor : primaryColor, ''),
          bottomNavItem(
            Icons.notifications,
            _page == 3 ? textColor : primaryColor,
            '',
          ),
          bottomNavItem(
            Icons.person,
            _page == 4 ? textColor : primaryColor,
            '',
          ),
        ],
        onTap: tappedNavigation,
      ),
    );
  }
}
