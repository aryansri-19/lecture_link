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

  ChatRoom({required this.userMap, required this.chatId, super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    void onSend() async {
      if (_message.text.isNotEmpty) {
        Map<String, dynamic> message = {
          'sender': _auth.currentUser!.displayName,
          'message': _message.text,
          'time': FieldValue.serverTimestamp(),
        };
        await _firestore
            .collection('chats')
            .doc(chatId)
            .collection('chat')
            .add(message);

        _message.clear();
      } else {
        showSnackBar(context, 'Enter some text');
      }
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: StreamBuilder<DocumentSnapshot>(
          stream:
              _firestore.collection('users').doc(userMap!['uid']).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              return Row(
                children: [
                  Icon(
                    Icons.circle,
                    size: screenHeight * 0.01,
                    color:
                        userMap!['status'] == 'Online'
                            ? Colors.green.shade400
                            : Colors.grey.shade800,
                  ),
                  Text(userMap!['username']),
                ],
              );
            } else {
              return Container();
            }
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  _firestore
                      .collection('chats')
                      .doc(chatId)
                      .collection('chat')
                      .orderBy('time', descending: true)
                      .snapshots(),
              builder: (
                BuildContext context,
                AsyncSnapshot<QuerySnapshot> snapshot,
              ) {
                // if (snapshot.connectionState == ConnectionState.waiting) {
                //   return const Center(
                //     child: CircularProgressIndicator(
                //       valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                //       strokeWidth: 4.0,
                //     ),
                //   );
                // }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text('No messages yet', textAlign: TextAlign.center),
                  );
                } else {
                  return ListView.builder(
                    reverse: true,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      return messages(
                        screenWidth,
                        screenHeight,
                        snapshot.data!.docs[index].data()
                            as Map<String, dynamic>,
                      );
                    },
                  );
                }
              },
            ),
          ),
          Container(
            height: screenHeight * 0.1,
            width: screenWidth,
            alignment: Alignment.center,
            child: SizedBox(
              height: screenHeight / 12,
              width: screenWidth / 1.1,
              child: Row(
                children: [
                  Expanded(
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
                  IconButton(icon: const Icon(Icons.send), onPressed: onSend),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget messages(double width, double height, Map<String, dynamic> messages) {
    return Column(
      children: [
        Container(
          alignment:
              messages['sender'] == _auth.currentUser!.displayName
                  ? Alignment.bottomRight
                  : Alignment.bottomLeft,
          width: width,
          child: Container(
            padding: EdgeInsets.symmetric(
              vertical: height * 0.01,
              horizontal: width * 0.05,
            ),
            margin: EdgeInsets.symmetric(
              vertical: height * 0.003,
              horizontal: width * 0.05,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: bannerBackground,
            ),
            child: Text(
              messages['message'],
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
