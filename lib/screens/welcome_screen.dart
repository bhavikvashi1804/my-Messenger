import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flutter/material.dart';


import 'package:animated_text_kit/animated_text_kit.dart';


import '../widgets/button_widget.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id="welcome_screen";
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin {

  AnimationController controller;
  Animation animation;

  @override
  void initState() {
    
    controller=AnimationController(duration: Duration(seconds: 2),vsync:this );
    animation=ColorTween(
      begin: Colors.blueGrey,
      end: Colors.white,
    ).animate(controller);
    controller.forward();
    controller.addListener((){
        setState(() {
        });
      }
    );
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    //so if app finish it release from memory
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'logo',      
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: 60,
                  ),
                ),
                TypewriterAnimatedTextKit(
                  text: ['Flash Chat'],
                  textStyle: TextStyle(
                    fontSize: 45.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            myButton(text: 'Log In',c: Colors.lightBlueAccent, onPress: (){ Navigator.pushNamed(context, LoginScreen.id);},),
            myButton(text: 'Register',c: Colors.blueAccent, onPress: (){ Navigator.pushNamed(context, RegistrationScreen.id);},),
          ],
        ),
      ),
    );
  }
}
