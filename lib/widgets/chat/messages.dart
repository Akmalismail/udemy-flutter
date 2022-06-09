import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/widgets/chat/message_bubble.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy(
            'createdAt',
            descending: true,
          )
          .snapshots(),
      builder:
          (ctx, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        final chatDocs = snapshot.data.docs;
        return ListView.builder(
          itemCount: chatDocs.length,
          itemBuilder: (ctx, index) => MessageBubble(
            key: ValueKey(chatDocs[index].id),
            username: chatDocs[index].data()['username'],
            message: chatDocs[index].data()['text'],
            userImage: chatDocs[index].data()['userImage'],
            isMe: chatDocs[index].data()['userId'] ==
                FirebaseAuth.instance.currentUser.uid,
          ),
          reverse: true,
        );
      },
    );
  }
}
