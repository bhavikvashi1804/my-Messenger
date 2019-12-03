import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



final _fireStore=Firestore.instance;
FirebaseUser logedInUser;

class ChatScreen extends StatefulWidget {
   static const String id="chat_screen";
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {


  final _auth=FirebaseAuth.instance;



  String messageText='';
  final msgTextController=TextEditingController;


  final myController = TextEditingController();

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
            
            MyMessages(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: myController,
                      onChanged: (value) {
                        messageText=value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      myController.clear();
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


class MyMessages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _fireStore.collection('messages').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {

        if (snapshot.hasError){
          return Text('Error: ${snapshot.error}');
        }
        if(snapshot.hasData){
          final msgs=snapshot.data.documents;
          List<MessageBubble> msgWidget=[];

          for(var msg in msgs){
            final msgText=msg.data['text'];
            final msgSender=msg.data['sender'];

            if(msgSender==logedInUser.email){
              final oneMsgWidget=MessageBubble(msgSender,msgText,true);
              msgWidget.add(oneMsgWidget);

            }
            else{
              final oneMsgWidget=MessageBubble(msgSender,msgText,false);
              msgWidget.add(oneMsgWidget);
            }

          }

          return Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 20.0),
              children: msgWidget,
            ),
          );
        }
        return Text('No data'); // unreachable
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  final String sender,msg;
  final bool isMe;
  MessageBubble(this.sender,this.msg,this.isMe);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: isMe?CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(sender,style: TextStyle(fontSize: 12,color: Colors.black54),),
          Material(
            elevation: 5.0,
            borderRadius: isMe? (BorderRadius.only(topLeft: Radius.circular(30),bottomLeft: Radius.circular(30),bottomRight: Radius.circular(30))):(BorderRadius.only(topRight: Radius.circular(30),bottomLeft: Radius.circular(30),bottomRight: Radius.circular(30))),
            color: isMe?Colors.lightBlueAccent:Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0,vertical: 10.0),
              child: Text(
                msg,
                style: TextStyle(
                  color:isMe? Colors.white :Colors.black,
                  fontSize: 20.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

