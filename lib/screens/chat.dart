import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lecture_link/screens/chat_room.dart';

import '../utils/colors.dart';

class Chat extends StatefulWidget {
  const Chat({Key? key}) : super(key: key);

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String chatRoomId(String user1, String user2) {
    if (user1[0].toLowerCase().codeUnits[0] >
        user2[0].toLowerCase().codeUnits[0]) {
      return "$user1$user2";
    } else {
      return "$user2$user1";
    }
  }

  Future<List<Map<String, dynamic>>> getUser() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    QuerySnapshot<Map<String, dynamic>> map =
        await firestore.collection('users').get();
    List<Map<String, dynamic>> userMap = [];
    for (DocumentSnapshot doc in map.docs) {
      userMap.add(doc.data() as Map<String, dynamic>);
    }
    return userMap;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Chats'),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [bannerBackground, bannerBackground2],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
        ),
        body: FutureBuilder(
          future: getUser(),
          builder: (BuildContext context,
              AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                  strokeWidth: 4.0,
                ),
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data == null) {
              return const Text('No user found');
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (BuildContext context, int index) {
                  Map<String, dynamic> userMap = snapshot.data![index];
                  return Card(
                    margin: const EdgeInsets.all(10),
                    child: ListTile(
                      onTap: () {
                        String roomId = chatRoomId(
                            _auth.currentUser!.displayName!,
                            userMap['username']); // Use userMap here

                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => ChatRoom(
                                userMap: userMap,
                                chatId: roomId))); // Use userMap here
                      },
                      title: Text('${userMap['username']}'), // Use userMap here
                    ),
                  );
                },
              );
            }
          },
        ));
  }
}
