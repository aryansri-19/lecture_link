import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lecture_link/utils/colors.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  Map<String, dynamic>? _userMap;
  final TextEditingController _searchController = TextEditingController();

  void onSearch() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    await firestore
        .collection('users')
        .where('username', isEqualTo: _searchController.text)
        .get()
        .then((value) {
      setState(() {
        if (value.docs.isNotEmpty) {
          _userMap = value.docs[0].data();
        } else {
          _userMap = null;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            pinned: true,
            actions: [
              Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                decoration: BoxDecoration(
                    color: contrast, borderRadius: BorderRadius.circular(10)),
                child: IconButton(
                  icon: const Icon(
                    Icons.search,
                    color: mobileBackground,
                  ),
                  onPressed: onSearch,
                ),
              )
            ],
            title: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                  hintText: 'Search',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: textColor)),
            ),
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    bannerBackground,
                    bannerBackground2
                  ], // Define your gradient colors here
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                if (_userMap != null) {
                  return Card(
                    margin: const EdgeInsets.all(10),
                    child: ListTile(
                      title: Text('Username: ${_userMap!['username']}'),
                      subtitle: Text('Email: ${_userMap!['email']}'),
                    ),
                  );
                } else {
                  // Show empty placeholder
                  return Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(20),
                    child: const Text('No user found'),
                  );
                }
              },
              childCount: 1,
            ),
          ),
        ],
      ),
    );
  }
}
