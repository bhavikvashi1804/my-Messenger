import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {
   static const String id="chat_screen";
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  final _fireStore=Firestore.instance;
  final _auth=FirebaseAuth.instance;
  FirebaseUser logedInUser;


  String messageText='';


  void getCurrentUser()async{
    try{
      final user=await _auth.currentUser();
      if(user!=null){
        logedInUser=user;
        //print(logedInUser.email);
      }
    }
    catch(e){
      print(e);
    }

  }


  /*
  void getMessages()async {
    final messages = await _fireStore.collection('messages').getDocuments();

    for(var msg in messages.documents){
      print(msg.data);
    }
  }

   */


  void getMessages1()async {
    await for (var  snapshot  in _fireStore.collection('messages').snapshots()){
      for(var msg in snapshot.documents){
        print(msg.data);
      }
    }
    //snapshot handle automatically update
  }


  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                _auth.signOut();
                Navigator.pop(context);
                getMessages1();
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        messageText=value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      _fireStore.collection('messages').add({
                        'text': messageText,
                        'sender': logedInUser.email,
                      });
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
