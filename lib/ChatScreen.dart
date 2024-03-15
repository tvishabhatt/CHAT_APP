import 'package:chat_app/ForFuncations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  String username;
  String uid;
  String email;
  ChatScreen({required this.username, required this.uid, required this.email});
  @override
  State<StatefulWidget> createState() {
    return ChatScreenState(username, uid, email);
  }
}

class ChatScreenState extends State<ChatScreen> with ForFuncations {
  String collectionNameOfChatrooms = 'CHAT_ROOMS';
  String username;
  String uid;
  String email;
  ChatScreenState(this.username, this.uid, this.email);

  final TextEditingController messageController = TextEditingController();
  String? _previousDate;

  @override
  void initState() {
    super.initState();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Recived message : $message");
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("app opened by notifiaction : $message");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: forbg(),
      appBar: AppBar(
        title: Text("$username"),
        backgroundColor: forappbar(),
      ),
      body: Column(
        children: [
          Expanded(
              child: StreamBuilder<QuerySnapshot>(
            stream: getMessages(user!.email, widget.email),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              } else {
                List<DocumentSnapshot> messages = snapshot.data!.docs;
                return ListView.builder(
                  itemBuilder: (context, index) =>
                      MessageItem(index, messages[index]),
                  itemCount: messages.length,
                );
              }
            },
          )),
          SendMessageTextfiled(),
        ],
      ),
    );
  }

  Widget SendMessageTextfiled() {
    return Row(
      children: [
        Expanded(
            child: ForTextFiled(
                hint: "Enter you Message",
                controller: messageController,
                b: false)),
        IconButton(
            onPressed: () {
              sendMessage(auth.currentUser!.uid, widget.uid,messageController.text, user!.email, widget.email);
              messageController.clear();
            },
            icon: Icon(
              Icons.arrow_upward,
              size: 30,
              color: forappbar(),
            ))
      ],
    );
  }

  Widget MessageItem(int index, DocumentSnapshot documentSnapshot) {
    DateTime timestamp = (documentSnapshot.get('timestamp') as Timestamp).toDate();
    String formattedTime = DateFormat('HH:mm').format(timestamp);
    String formattedDate = DateFormat('MMM dd, yyyy').format(timestamp);
    String currentDate = formattedDate;

    bool showDateCenter = _previousDate != currentDate;
    _previousDate = currentDate;

    return Column(
      children: [
        if (showDateCenter)...[
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: forappbar(),
                ),
                child: Text(
                  currentDate,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
    ]else...[
      SizedBox(),
        ],

        Align(
          alignment: documentSnapshot.get("senderId") == auth.currentUser!.uid ? Alignment.centerRight : Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Expanded(
              child: Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: (documentSnapshot.get('senderId') == user!.uid)
                        ? foryou()
                        : forme(),
                  ),
                  child: Column(mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text("${documentSnapshot.get('message')}",
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                      SizedBox(height: 4,),
                      Text("$formattedTime",
                        textAlign: TextAlign.end,

                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),

                    ],
                  ),
                  ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> sendMessage(String senderId, String receiverId, String message, String senderEmail, String receiverEmail) async {
    if (message.isNotEmpty) {
      String chatRoomId = getChatRoomId(senderEmail, receiverEmail);
      DocumentSnapshot chatDoc =
          await db.collection(collectionNameOfChatrooms).doc(chatRoomId).get();
      if (!chatDoc.exists) {
        await db
            .collection(collectionNameOfChatrooms)
            .doc(chatRoomId)
            .collection(collectionOfMesaages)
            .add({
          'senderId': senderId,
          'receiverId': receiverId,
          'message': message,
          'senderEmial': senderEmail,
          'reciverEmail': receiverEmail,
          'timestamp': FieldValue.serverTimestamp(),
        });
      }
    }
  }

  String getChatRoomId(String userEmail, String otherUserEmail) {
    List<String> emails = [userEmail, otherUserEmail];
    emails.sort();
    return '${emails[0]}_${emails[1]}';
  }

  Stream<QuerySnapshot> getMessages(String userId, String otherUserId) {
    String chatRoomId = getChatRoomId(userId, otherUserId);
    return db
        .collection(collectionNameOfChatrooms)
        .doc(chatRoomId)
        .collection(collectionOfMesaages)
        .orderBy('timestamp', descending: false)
        .snapshots();
  }
}
