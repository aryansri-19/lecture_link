import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lecture_link/screens/topic_screen.dart';
// import 'package:lecture_link/screens/add_notes.dart';
import 'package:lecture_link/utils/colors.dart';
import 'package:lecture_link/widgets/topic.dart';
// import 'package:lecture_link/utils/tags.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  Map<String, dynamic>? _userMap;
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _searchController = TextEditingController();
  bool isSearching = false;

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
          print(_userMap);
        } else {
          _userMap = null;
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        isSearching = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenwidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
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
              focusNode: _focusNode,
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
                if (isSearching) {
                  return _buildSearchResults();
                } else {
                  return Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(20),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () => {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const TopicScreen()))
                                  },
                                  child: topic(
                                      "Assignments",
                                      Colors.yellow,
                                      Colors.orange,
                                      Icons.assignment_turned_in_outlined,
                                      11.8),
                                ),
                                SizedBox(
                                  width: screenwidth * 0.07,
                                ),
                                GestureDetector(
                                  onTap: () => {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const TopicScreen()))
                                  },
                                  child: topic(
                                      "Notes",
                                      Colors.blue,
                                      Colors.blueAccent,
                                      Icons.note_alt_outlined,
                                      13),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () => {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const TopicScreen()))
                                  },
                                  child: topic(
                                      "Tests",
                                      Colors.green,
                                      Colors.greenAccent,
                                      Icons.assignment_outlined,
                                      13),
                                ),
                                SizedBox(
                                  width: screenwidth * 0.07,
                                ),
                                GestureDetector(
                                  onTap: () => {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const TopicScreen()))
                                  },
                                  child: topic(
                                      "Information",
                                      Colors.purple,
                                      Colors.purpleAccent,
                                      Icons.announcement_outlined,
                                      13),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: screenHeight * 0.03,
                            ),
                            const SizedBox(
                              child: Text(
                                "Tags",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                            const Row(
                              children: [
                                Column(
                                  children: [],
                                )
                              ],
                            )
                          ]));
                }
              },
              childCount: 1,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    if (_userMap != null) {
      return Card(
        margin: const EdgeInsets.all(10),
        child: ListTile(
          title: Text('${_userMap!['username']}'),
          subtitle: Text('${_userMap!['status']}'),
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
  }
}
