import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lecture_link/utils/colors.dart';
import 'package:lecture_link/widgets/snack_bar.dart';

class ChatRoom extends StatelessWidget {
  final Map<String, dynamic>? userMap;
  final String chatId;
  final TextEditingController _message = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  ChatRoom({required this.userMap, required this.chatId, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    void onSend() async {
      if (_message.text.isNotEmpty) {
        Map<String, dynamic> messages = {
          'sender': _auth.currentUser!.displayName,
          'message': _message.text,
          'time': FieldValue.serverTimestamp(),
        };
        await _firestore
            .collection('chats')
            .doc(chatId)
            .collection('chats')
            .add(messages);

        _message.clear();
      } else {
        showSnackBar(context, 'Enter some text');
      }
    }

    return Scaffold(
      appBar: AppBar(title: Text(userMap!['username'])),
      body: SingleChildScrollView(
          child: Column(
        children: [
          Container(
              height: screenHeight / 1.25,
              width: screenWidth,
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('chat')
                    .doc(chatId)
                    .collection('chats')
                    .orderBy('time', descending: true)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.data != null) {
                    return ListView.builder(
                      itemBuilder: (context, index) {
                        return messages(
                            screenWidth,
                            screenHeight,
                            snapshot.data!.docs[index].data()
                                as Map<String, dynamic>);
                      },
                      itemCount: snapshot.data!.docs.length,
                    );
                  } else {
                    return Container();
                  }
                },
              ))
        ],
      )),
      bottomNavigationBar: Container(
          height: screenHeight * 0.1,
          width: screenWidth,
          alignment: Alignment.center,
          child: Container(
            height: screenHeight / 12,
            width: screenWidth / 1.1,
            child: Row(children: [
              Container(
                height: screenHeight / 12,
                width: screenWidth / 1.5,
                child: TextField(
                  controller: _message,
                  decoration: InputDecoration(
                    hintText: "Type a message",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: onSend,
              )
            ]),
          )),
    );
  }

  Widget messages(double width, double height, Map<String, dynamic> messages) {
    return Container(
        width: width,
        alignment: messages['sender'] == _auth.currentUser!.displayName
            ? Alignment.centerRight
            : Alignment.centerLeft,
        child: Container(
          padding: EdgeInsets.symmetric(
              vertical: height * 0.1, horizontal: width * 0.05),
          margin: EdgeInsets.symmetric(
              vertical: height * 0.1, horizontal: width * 0.05),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: bannerBackground,
          ),
          child: Text(
            messages['message'],
            style: const TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ));
  }
}
