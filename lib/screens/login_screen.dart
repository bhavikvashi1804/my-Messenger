import 'package:flash_chat/constants.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flash_chat/widgets/button_widget.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  static const String id="login_screen";
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String uEmail,uPassword;

  FirebaseAuth _auth;

  @override
  void initState() {
    _auth=FirebaseAuth.instance;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Hero(
              tag: 'logo',
              child: Container(
                height: 200.0,
                child: Image.asset('images/logo.png'),
              ),
            ),
            SizedBox(
              height: 48.0,
            ),
            TextField(
              keyboardType: TextInputType.emailAddress,
              textAlign: TextAlign.center,
              onChanged: (value) {
                uEmail=value;
              },
              decoration: kInputDeco.copyWith(hintText: 'Enter your email'),
            ),
            SizedBox(
              height: 8.0,
            ),
            TextField(
              textAlign: TextAlign.center,
              onChanged: (value) {
                uPassword=value;
              },
              decoration: kInputDeco.copyWith(hintText: 'Enter your password'),
              obscureText: true,
            ),
            SizedBox(
              height: 24.0,
            ),
            myButton(text: 'Log In',c:Colors.lightBlueAccent,onPress: ()async{
              try{
              final user= await _auth.signInWithEmailAndPassword(email: uEmail, password: uPassword);
              if(user!=null){
                Navigator.pushNamed(context, ChatScreen.id);
              }}
              catch(e){
                print(e);
              }
            },),
          ],
        ),
      ),
    );
  }
}
