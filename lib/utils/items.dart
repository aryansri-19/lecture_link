import 'package:flutter/material.dart';
import 'package:lecture_link/screens/add_notes.dart';

import '../screens/home_screen.dart';
import '../screens/profile.dart';
import '../screens/search_screen.dart';

List<Widget> items = [
  const HomePage(),
  const SearchPage(),
  const AddNotes(),
  // NotificationsPage(),
  const Text('Notifications'),
  const ProfilePage(),
];
